import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Asegúrate de agregar esta dependencia en pubspec.yaml

class YoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre mí'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[300]!, Colors.teal[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(75),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/yo.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Soy programador.\n'
                    'Me llamo Cesar Gómez Aguilera.\n'
                    'Mi matrícula es 213507.\n'
                    'Tengo 22 años.\n'
                    'Me gusta programar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          launch('tel:+529611519667'); 
                        },
                        child: Text('Llamar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          launch('sms:+529611519667'); 
                        },
                        child: Text('Mensaje'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          launch('https://github.com/BlackRubick/Rick-and-Morty-Character-Finder.git'); 
                        },
                        child: Text('Repositorio'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
