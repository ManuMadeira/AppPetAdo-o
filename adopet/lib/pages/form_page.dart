import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../repositories/pet_repository.dart';

class FormPage extends StatefulWidget {
  final Pet? pet; // Se for nulo: Cadastro. Se tiver um pet: Edição.

  const FormPage({super.key, this.pet});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final PetRepository _repository = PetRepository();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tutorController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _especieController = TextEditingController();
  
  String _sexoSelecionado = 'Fêmea';
  bool _isEdicao = false;

  @override
  void initState() {
    super.initState();
    // Se veio um pet por parâmetro, preenche os campos (Modo Edição)
    if (widget.pet != null) {
      _isEdicao = true;
      _nomeController.text = widget.pet!.nome;
      _tutorController.text = widget.pet!.tutor;
      _idadeController.text = widget.pet!.idade;
      _especieController.text = widget.pet!.especie;
      _sexoSelecionado = widget.pet!.sexo;
    }
  }

 
  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      List<Pet> listaAtual = await _repository.carregarPets();

      if (_isEdicao) {
        // Fluxo de alteração/edição
        int index = listaAtual.indexWhere((p) => p.id == widget.pet!.id);
        if (index != -1) {
          listaAtual[index] = Pet(
            id: widget.pet!.id,
            nome: _nomeController.text,
            especie: _especieController.text,
            tutor: _tutorController.text,
            idade: _idadeController.text,
            sexo: _sexoSelecionado,
          );
        }
      } else {
        // Fluxo de novo cadastro
        final novoPet = Pet(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nome: _nomeController.text,
          especie: _especieController.text,
          tutor: _tutorController.text,
          idade: _idadeController.text,
          sexo: _sexoSelecionado,
        );
        listaAtual.add(novoPet);
      }

      // Salva no SharedPreferences
      await _repository.salvarPets(listaAtual);

      if (mounted) {
        // ESSA É A MENSAGEM PEDIDA NA ATIVIDADE!
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEdicao ? 'Item alterado com sucesso!' : 'Item registrado com sucesso!'),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context); // Fecha o formulário e volta para a lista
      }
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xffe67e22), fontWeight: FontWeight.bold),
      filled: true,
      fillColor: const Color(0xffebd6c1),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xffe67e22), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0e0e0),
      appBar: AppBar(
        title: Text(_isEdicao ? 'Editar cadastro' : 'Cadastro de animais'),
        backgroundColor: const Color(0xff4db6ac),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Topo verde-água arredondado igual ao seu desenho
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xff4db6ac),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Icon(Icons.pets, size: 60, color: Color(0xfff39c12)),
                  const SizedBox(height: 10),
                  Text(
                    _isEdicao ? 'Editar dados do pet' : 'Cadastro de animal\npara adoção',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [                  
                    
                    TextFormField(
                      controller: _nomeController,
                      decoration: _buildInputDecoration('Nome do Pet'),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _tutorController,
                      decoration: _buildInputDecoration('Nome do Tutor Temporário'),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _idadeController,
                      decoration: _buildInputDecoration('Idade (Aproximada)'),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _especieController,
                      decoration: _buildInputDecoration('Espécie (Ex: Cão, Gato)'),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: _sexoSelecionado,
                      decoration: _buildInputDecoration('Sexo'),
                      items: ['Fêmea', 'Macho'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _sexoSelecionado = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 30),

                    // Botão Laranja "Colocar para adoção"
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _salvar, // Chama a função com a mensagem
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfff39c12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Text(
                          _isEdicao ? 'Salvar Alterações' : 'Colocar para adoção',
                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}