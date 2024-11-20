class User {
  final int? id; //permite ser null
  final String usuario;
  final String senha; //poder ser null
  final int idPessoa;

  User({
    this.id,
    required this.usuario,
    required this.senha,
    required this.idPessoa,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'senha': senha,
      'id_pessoa': idPessoa,
    };
  }
  //factory Pessoa.fromMap (Map<String>)
}
