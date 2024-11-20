import 'package:app_dogs/data/repositories/user_repository.dart';
import 'package:app_dogs/presentation/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final UserViewmodel userViewmodel = UserViewmodel(UserRepository());

  // Função para registrar o usuário
  registerUser() async {
    final email = emailController.text;
    final usuario = usuarioController.text;
    final senha = senhaController.text;

    // Chama o método registerUser da camada de ViewModel para realizar o registro
    final message = await userViewmodel.registerUser(email, usuario, senha);

    if (mounted) {
      // Exibe uma Snackbar com a mensagem de sucesso ou erro
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor:
            message.contains('sucesso') ? Colors.green : Colors.red,
      ));

      if (message.contains('sucesso')) {
        // Se o registro for bem-sucedido, navega para a página de login (comentado por enquanto)
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const LoginPage(),
        //     ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de E-mail
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Campo de Usuário
              TextField(
                controller: usuarioController,
                decoration: const InputDecoration(
                  labelText: 'Usuário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Campo de Senha
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Botão de Registro
              ElevatedButton(
                onPressed: registerUser,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
