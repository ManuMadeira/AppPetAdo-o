import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';

class PetRepository {
  static const String _key = 'lista_pets';

  // Salva a lista completa de pets convertendo para JSON
  Future<void> salvarPets(List<Pet> pets) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = pets.map((pet) => pet.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);
    await prefs.setString(_key, jsonString);
  }

  // Carrega os pets do SharedPreferences decodificando o JSON
  Future<List<Pet>> carregarPets() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    
    if (jsonString == null) return [];

    final List<dynamic> decodedList = jsonDecode(jsonString);
    return decodedList.map((item) => Pet.fromJson(item)).toList();
  }

  // Limpa todos os dados salvos (Requisito: Confirmação antes de limpar)
  Future<void> limparDados() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}