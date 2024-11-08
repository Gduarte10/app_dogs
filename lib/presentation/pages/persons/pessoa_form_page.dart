import 'dart:convert';

import 'package:app_dogs/data/models/pessoa_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../data/repositories/pessoa_repository.dart';
import '../../viewmodels/pessoa_viewmodel.dart';

class PessoaFormPage extends StatefulWidget {
  const PessoaFormPage({super.key});

  @override
  State<PessoaFormPage> createState() => _PessoaPageFormState();
}

class _PessoaPageFormState extends State<PessoaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final enderecoAvRuaController = TextEditingController();
  final enderecoNumeroController = TextEditingController();
  final enderecoCepController = TextEditingController();
  final enderecoCidadeController = TextEditingController();
  final enderecoEstadoController = TextEditingController();
  final PessoaViewModel _viewModel = PessoaViewModel(PessoaRepository());

  Future<void> savepessoa() async {
    if (_formKey.currentState!.validate()) {
      final pessoa = Pessoa(
          nome: nomeController.text,
          telefone: telefoneController.text,
          email: emailController.text,
          enderecoAvRua: enderecoAvRuaController.text,
          enderecoNumero: enderecoNumeroController.text,
          enderecoCidade: enderecoCidadeController.text,
          enderecoCep: enderecoCepController.text,
          enderecoEstado: enderecoEstadoController.text);
      // print(dog.toMap());
      await _viewModel.addPessoa(pessoa);

      // Verifica se o widget ainda está montado antes de exibir o Snackbar ou navegar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente adicionado com sucesso!')),
        );
        Navigator.pop(context); // Fecha a página após salvar
      }
    }
  }

  _buscarendereco(String cep) async {
    if (cep.length != 8) return;

    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('erro')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('CEP não encontrado!')),
            );
          }
          return;
        }
        setState(() {
          enderecoAvRuaController.text = data['logradouro'] ?? '';
          enderecoCidadeController.text = data['localidade'] ?? '';
          enderecoEstadoController.text = data['uf'] ?? '';
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('erro ao buscar endereço')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro de rede ao buscar o endereço')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo cadstrar'),
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
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Novo cliente',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nomeController,
                            decoration: InputDecoration(
                              labelText: 'Nome',
                              labelStyle:
                                  TextStyle(color: Colors.teal.shade700),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal.shade700),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor cadastre um nome';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: telefoneController,
                            decoration: InputDecoration(
                              labelText: 'Telefone',
                              labelStyle:
                                  TextStyle(color: Colors.teal.shade700),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal.shade700),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor cadastre um telefone';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle:
                                  TextStyle(color: Colors.teal.shade700),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal.shade700),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor cadastre um email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: enderecoCepController,
                            decoration: InputDecoration(
                              labelText: 'CEP',
                              labelStyle:
                                  TextStyle(color: Colors.teal.shade700),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal.shade700),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _buscarendereco(value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor cadastre seu Cep';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: enderecoAvRuaController,
                            decoration: InputDecoration(
                              labelText: 'Endereço (Rua/AV)',
                              labelStyle:
                                  TextStyle(color: Colors.teal.shade700),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal.shade700),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor cadastre um Endereço';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: enderecoNumeroController,
                            decoration: InputDecoration(
                              labelText: 'Numero endereço',
                              labelStyle:
                                  TextStyle(color: Colors.teal.shade700),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal.shade700),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor cadastre um numero endereço';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: enderecoCidadeController,
                            decoration: InputDecoration(
                              labelText: 'Cidade',
                              labelStyle:
                                  TextStyle(color: Colors.teal.shade700),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal.shade700),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor cadastre sua cidade';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: enderecoEstadoController,
                            decoration: InputDecoration(
                              labelText: 'Estado',
                              labelStyle:
                                  TextStyle(color: Colors.teal.shade700),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal.shade700),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor cadastre seu Estado';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: savepessoa,
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
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
