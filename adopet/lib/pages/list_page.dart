import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../repositories/pet_repository.dart';
import 'form_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final PetRepository _repository = PetRepository();
  List<Pet> _listaPets = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  // Carregamento automático dos dados
  Future<void> _atualizarLista() async {
    setState(() => _carregando = true);
    final pets = await _repository.carregarPets();
    setState(() {
      _listaPets = pets;
      _carregando = false;
    });
  }

  // Confirmação obrigatória antes de remover
  Future<void> _confirmarExclusao(Pet pet) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Pet'),
        content: Text('Tem certeza que deseja remover ${pet.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() {
        _listaPets.removeWhere((p) => p.id == pet.id);
      });
      await _repository.salvarPets(_listaPets);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removido com sucesso!')),
        );
      }
    }
  }

  // Confirmação antes de limpar todos os dados importantes
  Future<void> _limparTudo() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Todos os Dados'),
        content: const Text('Isso apagará permanentemente todos os pets. Continuar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Não')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sim, Limpar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _repository.limparDados();
      _atualizarLista();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todos os dados foram limpos!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0e0e0),
      appBar: AppBar(
        title: const Text('Galeria de Meus Animais', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff4db6ac),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: _limparTudo,
            tooltip: 'Limpar todos os dados',
          )
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra de pesquisa meramente visual baseada no layout
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xffb2dfdb),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: const Color(0xff4db6ac)),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: Color(0xff4db6ac)),
                        hintText: 'Buscar...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Meus Animais',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xffe67e22)),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _listaPets.isEmpty
                      ? const Center(child: Text('Nenhum pet cadastrado.'))
                      : ListView.builder(
                          itemCount: _listaPets.length,
                          itemBuilder: (context, index) {
                            final pet = _listaPets[index];
                            // Alterna cores baseado na espécie ou index para simular o protótipo
                            final bool isCat = pet.especie.toLowerCase().contains('gato');
                            final cardColor = isCat ? const Color(0xfff5b041) : const Color(0xff85c1e9);
                            final avatarColor = isCat ? const Color(0xffe67e22) : const Color(0xff3498db);

                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              color: cardColor.withOpacity(0.7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: avatarColor,
                                  child: Icon(
                                    Icons.pets,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  pet.nome,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                                ),
                                subtitle: Text(
                                  '${pet.especie} • ${pet.sexo}\n${pet.idade} • Tutor: ${pet.tutor}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                isThreeLine: true,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.white),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => FormPage(pet: pet)),
                                        );
                                        _atualizarLista();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.white),
                                      onPressed: () => _confirmarExclusao(pet),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // Botão "Adicionar mais um animal" posicionado de forma similar ao layout
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FormPage()),
                        );
                        _atualizarLista();
                      },
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                      label: const Text('Adicionar mais um animal', style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xfff39c12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}