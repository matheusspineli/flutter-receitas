import 'package:flutter/material.dart';

import 'style/colors.dart';

class Detalhes extends StatelessWidget {
  final Map<String, dynamic> receita;

  const Detalhes({super.key, required this.receita});

  @override
  Widget build(BuildContext context) {
    final dadosIngredientes = receita['ingredientes'];

    List<String> ingredientes = [];

    if (dadosIngredientes is List) {
      ingredientes = dadosIngredientes.map((item) => item.toString()).toList();
    } else if (dadosIngredientes is String) {
      ingredientes = dadosIngredientes.split(',');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(receita['nome']?.toString() ?? 'Detalhes da receita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                receita['img']?.toString() ?? '',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, erro, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 220,
                    color: AppColors.secundaria,
                    child: const Icon(
                      Icons.restaurant,
                      size: 60,
                      color: AppColors.branco,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Text(
              receita['nome']?.toString() ?? 'Sem nome',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tipo: ${receita['tipo'] ?? 'Não informado'}',
              style: const TextStyle(color: AppColors.principal, fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ingredientes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.principal,
              ),
            ),
            const SizedBox(height: 10),
            if (ingredientes.isEmpty)
              const Text(
                'Nenhum ingrediente informado.',
                style: TextStyle(color: AppColors.texto),
              ),
            ...ingredientes.map(
              (ingrediente) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '• ${ingrediente.trim()}',
                  style: const TextStyle(fontSize: 16, color: AppColors.texto),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Modo de preparo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.principal,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              receita['modoFazer']?.toString() ??
                  'Modo de preparo não informado.',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.texto,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
