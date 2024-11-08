import 'dart:convert';

import 'package:app_dogs/data/models/pessoa_model.dart';
import 'package:app_dogs/data/repositories/pessoa_repository.dart';
import 'package:app_dogs/presentation/viewmodels/pessoa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PessoaEditPage extends StatefulWidget {
  final Pessoa pessoa;

  const PessoaEditPage({super.key, required this.pessoa});

  @override
  PessoaEditPageState createState() => PessoaEditPageState();
}

class PessoaEditPageState extends State<PessoaEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _enderecoAvRuaController = TextEditingController();
  final _enderecoNumeroController = TextEditingController();
  final _enderecoCidadeController = TextEditingController();
  final _enderecoCepController = TextEditingController();
  final _enderecoEstadoController = TextEditingController();
  final PessoaViewModel _viewModel = PessoaViewModel(PessoaRepository());

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.pessoa.nome;
    _telefoneController.text = widget.pessoa.telefone.toString();
    _emailController.text = widget.pessoa.email.toString();
    _enderecoAvRuaController.text = widget.pessoa.enderecoAvRua.toString();
    _enderecoNumeroController.text = widget.pessoa.enderecoNumero.toString();
    _enderecoCidadeController.text = widget.pessoa.enderecoCidade.toString();
    _enderecoCepController.text = widget.pessoa.enderecoCep.toString();
    _enderecoEstadoController.text = widget.pessoa.enderecoEstado.toString();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _enderecoAvRuaController.dispose();
    _enderecoNumeroController.dispose();
    _enderecoCidadeController.dispose();
    _enderecoCepController.dispose();
    _enderecoEstadoController.dispose();
    super.dispose();
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
          _enderecoAvRuaController.text = data['logradouro'] ?? '';
          _enderecoCidadeController.text = data['localidade'] ?? '';
          _enderecoEstadoController.text = data['uf'] ?? '';
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

  _updatePessoa() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedPessoa = Pessoa(
          id: widget.pessoa.id, // Mantém o ID original
          nome: _nomeController.text,
          telefone: _telefoneController.text,
          email: _emailController.text,
          enderecoAvRua: _enderecoAvRuaController.text,
          enderecoNumero: _enderecoNumeroController.text,
          enderecoCidade: _enderecoCidadeController.text,
          enderecoCep: _enderecoCepController.text,
          enderecoEstado: _enderecoEstadoController.text);

      await _viewModel.updatePessoa(updatedPessoa);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro atualizado com sucesso!')),
        );
        Navigator.pop(context, updatedPessoa);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edição do cadastro'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Editar cadastro',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com um nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _telefoneController,
                        decoration: InputDecoration(
                          labelText: 'telefone',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com um telefone';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com um email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _enderecoAvRuaController,
                        decoration: InputDecoration(
                          labelText: 'Rua Av',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com uma Rua ou Av';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _enderecoNumeroController,
                        decoration: InputDecoration(
                          labelText: 'Numero',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com um numero';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _enderecoCidadeController,
                        decoration: InputDecoration(
                          labelText: 'Cidade',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com uma cidade';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _enderecoCepController,
                        decoration: InputDecoration(
                          labelText: 'Cep',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _buscarendereco(value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com um cep';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _enderecoEstadoController,
                        decoration: InputDecoration(
                          labelText: 'Estado',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com um estado';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _updatePessoa,
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
                          'Salvar Alterações',
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
    );
  }
}
