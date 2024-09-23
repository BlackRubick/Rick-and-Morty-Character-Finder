import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BuscarScreen extends StatefulWidget {
  @override
  _BuscarScreenState createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = "";
  Future<List<dynamic>>? _searchResults;
  bool _isButtonEnabled = false;
  Color _buttonColor = Colors.teal;

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
            _buttonColor = Colors.green;
          });
        } else {
          setState(() {
            _buttonColor = Colors.red;
          });
        }
      } catch (error) {
        setState(() {
          _buttonColor = Colors.red;
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
