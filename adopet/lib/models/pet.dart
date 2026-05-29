class Pet {
  String id;
  String nome;
  String especie;
  String tutor;
  String idade;
  String sexo;

  Pet({
    required this.id,
    required this.nome,
    required this.especie,
    required this.tutor,
    required this.idade,
    required this.sexo,
  });

  // Converte um JSON (Map) para o objeto Pet
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      especie: json['especie'] ?? '',
      tutor: json['tutor'] ?? '',
      idade: json['idade'] ?? '',
      sexo: json['sexo'] ?? '',
    );
  }

  // Converte o objeto Pet para um JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'especie': especie,
      'tutor': tutor,
      'idade': idade,
      'sexo': sexo,
    };
  }
}