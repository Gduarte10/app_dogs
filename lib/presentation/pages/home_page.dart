import 'package:app_dogs/presentation/pages/main_home_page.dart';
import 'package:app_dogs/presentation/pages/persons/pessoa_page.dart';
import 'package:flutter/material.dart';
import 'dogs/dog_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  //lista de páginas, com homePage como inicial
  final List<Widget> _pages = [
    const MainHomePage(),
    const DogPage(),
    const PessoaPage(),
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
        title: const Text('Gestão de Pets e Clientes'),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Cabeçalho do Drawer
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal.shade300,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile_image.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bem-vindo!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            // Menu para a página de Dogs
            ListTile(
              leading: const Icon(Icons.pets, color: Colors.teal),
              title: const Text('Dogs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DogPage()),
                );
              },
            ),
            // Menu para a página de Clientes
            ListTile(
              leading: const Icon(Icons.people, color: Colors.teal),
              title: const Text('Pessoas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PessoaPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Dog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clientes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (_onItemTapped),
      ),
    );
  }
}
