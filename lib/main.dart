import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Rick and Morty Character Finder",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Esta aplicación te permite buscar personajes de "
              "Rick and Morty.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
    SearchScreen(),  // Pantalla de búsqueda actualizada
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rick and Morty Character Finder',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 4,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.teal,
        indicatorColor: Colors.white,
      ),
    );
  }
}

// Pantalla de búsqueda
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = "";
  Future<List<dynamic>>? _searchResults;
  bool _isButtonEnabled = false;  // Estado para habilitar/deshabilitar botón
  Color _buttonColor = Colors.teal;  // Color del botón, por defecto es teal

  Future<List<dynamic>> fetchCharacters(String name) async {
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character/?name=$name'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error al cargar personajes');
    }
  }

  void _onSearch() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _searchQuery = _controller.text;
        _searchResults = fetchCharacters(_searchQuery);
      });

      try {
        final results = await fetchCharacters(_searchQuery);
        if (results.isNotEmpty) {
          setState(() {
            _buttonColor = Colors.green;  // Cambiar color a verde si encuentra personajes
          });
        } else {
          setState(() {
            _buttonColor = Colors.red;  // Cambiar color a rojo si no encuentra personajes
          });
        }
      } catch (error) {
        setState(() {
          _buttonColor = Colors.red;  // Cambiar color a rojo si hay error
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Buscar personaje',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _isButtonEnabled ? _onSearch : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(_buttonColor),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(fontSize: 16),
              ),
            ),
            child: Text('Buscar'),
          ),
          SizedBox(height: 20),
          _searchResults == null
              ? Text('Introduce un nombre para buscar personajes')
              : FutureBuilder<List<dynamic>>(
                  future: _searchResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No se encontraron personajes');
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final character = snapshot.data![index];
                            return ListTile(
                              leading: Image.network(character['image']),
                              title: Text(character['name']),
                              subtitle: Text('Estado: ${character['status']}'),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }
}
