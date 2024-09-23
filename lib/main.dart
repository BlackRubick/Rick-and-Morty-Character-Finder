import 'package:flutter/material.dart';
import 'yo.dart'; // Asegúrate de que este archivo exista
import 'buscar.dart'; // Importa tu archivo de búsqueda

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YoScreen()), // Navega a YoScreen
                  );
                },
                child: Text("Sobre mí"),
              ),
            ],
          ),
        ),
      ),
      BuscarScreen(), // Cambia aquí a BuscarScreen
    ];

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
