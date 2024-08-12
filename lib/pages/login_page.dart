import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app_flutter/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController loginUsernameController;
  late TextEditingController loginPasswordController;
  late TextEditingController signUpUsernameController;
  late TextEditingController signUpPasswordController;

  Color _appBarColor =
      Color.fromARGB(255, 250, 219, 255); // Color inicial de la AppBar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    loginUsernameController = TextEditingController();
    loginPasswordController = TextEditingController();
    signUpUsernameController = TextEditingController();
    signUpPasswordController = TextEditingController();
  }

  void _handleTabSelection() {
    setState(() {
      // Actualizar el color de la AppBar según la pestaña seleccionada
      if (_tabController.index == 0) {
        _appBarColor = const Color.fromARGB(255, 250, 219, 255);
      } else {
        _appBarColor = const Color.fromARGB(255, 138, 216, 255);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    signUpUsernameController.dispose();
    signUpPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor, // Color dinámico de la AppBar
        title: const Text(
          'Beauty Glam',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              _tabController.animateTo(0);
            },
            tooltip: 'Iniciar Sesión',
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              _tabController.animateTo(1);
            },
            tooltip: 'Crear Cuenta',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pantalla de inicio de sesión
          _buildLoginForm(),
          // Pantalla de registro
          _buildSignUpForm(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 250, 219, 255),
            Color.fromARGB(255, 255, 255, 255)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Inicio de Sesión',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: loginUsernameController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            TextField(
              controller: loginPasswordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              // Botón más largo
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String username = loginUsernameController.text.trim();
                  String password = loginPasswordController.text.trim();

                  try {
                    // Iniciar sesión con Firebase
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: username,
                      password: password,
                    );

                    // Si el inicio de sesión es exitoso, navega a la página de inicio
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                        settings: RouteSettings(arguments: username),
                      ),
                    );

                    // Limpia los campos del formulario
                    loginUsernameController.clear();
                    loginPasswordController.clear();
                  } catch (e) {
                    // Si hay un error durante el inicio de sesión, muestra un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al iniciar sesión: $e'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 138, 216, 255),
            Color.fromARGB(255, 255, 255, 255)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crear Cuenta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: signUpUsernameController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            TextField(
              controller: signUpPasswordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            SizedBox(
              // Botón más largo
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String username = signUpUsernameController.text.trim();
                  String password = signUpPasswordController.text.trim();

                  try {
                    // Crear usuario con Firebase
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: username,
                      password: password,
                    );

                    // Si el usuario se crea exitosamente, muestra un mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cuenta creada con éxito'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    // Limpia los campos del formulario
                    signUpUsernameController.clear();
                    signUpPasswordController.clear();
                  } catch (e) {
                    // Si hay un error durante la creación del usuario, muestra un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al crear usuario: $e'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Crear Cuenta',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
