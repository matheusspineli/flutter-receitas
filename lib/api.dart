import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = 'https://receitasapi-b-2025.vercel.app';

  static Future<List<Map<String, dynamic>>> buscarReceitas() async {
    final resposta = await http.get(Uri.parse('$baseUrl/receitas'));

    if (resposta.statusCode != 200) {
      throw Exception(
        'Erro ao buscar receitas: ${resposta.statusCode} - ${resposta.body}',
      );
    }

    final dados = jsonDecode(resposta.body);

    if (dados is! List) {
      throw Exception('A API não retornou uma lista de receitas.');
    }

    return dados.map<Map<String, dynamic>>((item) {
      return Map<String, dynamic>.from(item as Map);
    }).toList();
  }

  static Future<bool> salvarReceita({
    required String nome,
    required List<String> ingredientes,
    required String modoFazer,
    required String img,
    required String tipo,
  }) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/receitas'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'nome': nome,
        'tipo': tipo == 'Doce'
            ? 'DOCE'
            : tipo == 'Salgado'
            ? 'SALGADA'
            : 'BEBIDA',
        'ingredientes': ingredientes.join(', '),
        'modoFazer': modoFazer,
        'img': img,
        'custoAproximado': 0.0,
      }),
    );

    print('Status do cadastro: ${resposta.statusCode}');
    print('Resposta da API: ${resposta.body}');

    if (resposta.statusCode == 200 || resposta.statusCode == 201) {
      return true;
    }

    throw Exception(
      'Erro ao cadastrar: ${resposta.statusCode} - ${resposta.body}',
    );
  }
}
