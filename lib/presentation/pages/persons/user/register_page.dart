import 'package:app_dogs/data/repositories/user_repository.dart';
import 'package:app_dogs/presentation/pages/persons/user/login_page.dart';
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
  final TextEditingController confirmasenhaController = TextEditingController();
  final UserViewmodel userViewmodel = UserViewmodel(UserRepository());

  final _formkey = GlobalKey<FormState>();

  // Função para registrar o usuário
  registerUser() async {
    if (_formkey.currentState?.validate() ?? false) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cadastro'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        // Título do Formulário
                        const Text(
                          'Cadastro de Usuário',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Campo de E-mail
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal.shade700),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor cadastre um E-mail';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Campo de Usuário
                        TextFormField(
                          controller: usuarioController,
                          decoration: InputDecoration(
                            labelText: 'Usuário',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal.shade700),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor cadastre um usuário';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Campo de Senha
                        TextFormField(
                          controller: senhaController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal.shade700),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor cadastre uma senha';
                            }
                            if (value.length < 4) {
                              return 'A senha deve ter pelo menos 4 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Campo de Confirmar Senha
                        TextFormField(
                          controller: confirmasenhaController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Redigite a Senha',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal.shade700),
                            ),
                          ),
                          validator: (value) {
                            if (value != senhaController.text) {
                              return "As senhas não coincidem";
                            }
                            if (value != null && value.length < 4) {
                              return 'A senha deve ter pelo menos 4 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Botão de Cadastro
                        ElevatedButton.icon(
                          onPressed: registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 30.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          icon: const Icon(Icons.save, size: 24),
                          label: const Text(
                            'Cadastrar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Botão de Cadastro
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 30.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          label: const Text(
                            'Já tem cadastro, faça o seu login',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
