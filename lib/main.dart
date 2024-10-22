import 'package:flutter/material.dart';
import 'services/hero_service.dart';

void main() {
  runApp(PahlawanApp());
}

class PahlawanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pahlawan Nasional',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 70, 0, 0),
      ),
      home: PahlawanListPage(),
    );
  }
}

class PahlawanListPage extends StatefulWidget {
  @override
  _PahlawanListPageState createState() => _PahlawanListPageState();
}

class _PahlawanListPageState extends State<PahlawanListPage> {
  late Future<List<dynamic>> _heroes;
  String _selectedLetter = 'A'; // Default abjad yang dipilih
  List<String> alphabet = List<String>.generate(26, (i) => String.fromCharCode(i + 65)); // A-Z

  @override
  void initState() {
    super.initState();
    _heroes = HeroService.fetchHeroes();
  }

  // Fungsi untuk memfilter pahlawan berdasarkan huruf depan nama
  List<dynamic> _filterHeroesByLetter(List<dynamic> heroes, String letter) {
    return heroes.where((hero) {
      var name = hero['name'] ?? '';
      return name.toString().toUpperCase().startsWith(letter);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pahlawan Nasional Indonesia'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _heroes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data'));
          } else {
            // Filter pahlawan sesuai huruf depan yang dipilih
            var filteredHeroes = _filterHeroesByLetter(snapshot.data!, _selectedLetter);

            return Column(
              children: [
                // Abjad A-Z sebagai tombol
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0, // Jarak antar huruf
                    children: alphabet.map((letter) {
                      return ChoiceChip(
                        label: Text(
                          letter,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        selected: _selectedLetter == letter,
                        selectedColor: const Color.fromARGB(255, 175, 0, 0),
                        onSelected: (selected) {
                          setState(() {
                            _selectedLetter = letter; // Set huruf yang dipilih
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

                // List pahlawan yang difilter sesuai abjad
                Expanded(
                  child: filteredHeroes.isEmpty
                      ? Center(child: Text('Tidak ada pahlawan dengan huruf $_selectedLetter'))
                      : ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: filteredHeroes.length,
                          itemBuilder: (context, index) {
                            var hero = filteredHeroes[index];
                            var birthYear = hero['birth_year'] ?? 'N/A'; // Tahun lahir
                            var deathYear = hero['death_year'] ?? 'N/A'; // Tahun kematian
                            var ascensionYear = hero['ascension_year'] ?? 'N/A'; // Tahun pengangkatan

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(10),
                                  title: Text(
                                    hero['name'] ?? 'Nama tidak tersedia',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tahun Lahir: $birthYear',
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 26, 26, 26),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Tahun Wafat: $deathYear',
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 26, 26, 26),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Tahun Pengangkatan: $ascensionYear',
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 26, 26, 26),
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          hero['description'] ?? 'Deskripsi tidak tersedia',
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 26, 26, 26),
                                            fontSize: 14,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
