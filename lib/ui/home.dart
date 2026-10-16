import 'package:flutter/material.dart';

import '../api.dart';
import 'detalhes.dart';
import 'style/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> receitas;

  @override
  void initState() {
    super.initState();
    atualizarReceitas();
  }

  void atualizarReceitas() {
    receitas = Api.buscarReceitas();
  }

  Future<void> recarregar() async {
    setState(() {
      atualizarReceitas();
    });

    await receitas;
  }

  void abrirCadastro() {
    final nomeController = TextEditingController();
    final ingredientesController = TextEditingController();
    final modoController = TextEditingController();
    final imgController = TextEditingController();

    String tipo = 'Doce';
    bool salvando = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contexto, atualizarDialog) {
            return AlertDialog(
              backgroundColor: AppColors.fundo,
              title: const Text(
                'Nova receita',
                style: TextStyle(color: AppColors.texto),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da receita',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ingredientesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Ingredientes',
                        hintText: 'Separe por vírgulas',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: modoController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Modo de preparo',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: imgController,
                      decoration: const InputDecoration(
                        labelText: 'URL da imagem',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: tipo,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de receita',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Doce', child: Text('Doce')),
                        DropdownMenuItem(
                          value: 'Salgado',
                          child: Text('Salgado'),
                        ),
                        DropdownMenuItem(
                          value: 'Bebida',
                          child: Text('Bebida'),
                        ),
                      ],
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizarDialog(() {
                            tipo = valor;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: salvando
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: AppColors.principal),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principal,
                    foregroundColor: AppColors.branco,
                  ),
                  onPressed: salvando
                      ? null
                      : () async {
                          if (nomeController.text.trim().isEmpty ||
                              ingredientesController.text.trim().isEmpty ||
                              modoController.text.trim().isEmpty ||
                              imgController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(contexto).showSnackBar(
                              const SnackBar(
                                content: Text('Preencha todos os campos!'),
                              ),
                            );
                            return;
                          }

                          final nome = nomeController.text.trim();

                          final ingredientes = ingredientesController.text
                              .split(',')
                              .map((item) => item.trim())
                              .where((item) => item.isNotEmpty)
                              .toList();

                          final modo = modoController.text.trim();
                          final img = imgController.text.trim();

                          atualizarDialog(() {
                            salvando = true;
                          });

                          try {
                            await Api.salvarReceita(
                              nome: nome,
                              ingredientes: ingredientes,
                              modoFazer: modo,
                              img: img,
                              tipo: tipo,
                            );

                            if (!mounted) return;

                            Navigator.pop(dialogContext);

                            setState(() {
                              atualizarReceitas();
                            });

                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Receita cadastrada com sucesso!',
                                ),
                              ),
                            );
                          } catch (erro) {
                            atualizarDialog(() {
                              salvando = false;
                            });

                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text('Não foi possível salvar: $erro'),
                                backgroundColor: AppColors.erro,
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        },
                  child: salvando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.branco,
                          ),
                        )
                      : const Text('Salvar receita'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      nomeController.dispose();
      ingredientesController.dispose();
      modoController.dispose();
      imgController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receitas')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: receitas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.principal),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Erro ao carregar as receitas.',
                    style: TextStyle(color: AppColors.texto),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: recarregar,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final lista = snapshot.data ?? [];

          if (lista.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma receita encontrada.',
                style: TextStyle(color: AppColors.texto),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.principal,
            onRefresh: recarregar,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final receita = lista[index];

                return Card(
                  color: AppColors.branco,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        receita['img']?.toString() ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, erro, stackTrace) {
                          return const SizedBox(
                            width: 60,
                            height: 60,
                            child: Icon(
                              Icons.restaurant,
                              color: AppColors.secundaria,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      receita['nome']?.toString() ?? 'Sem nome',
                      style: const TextStyle(
                        color: AppColors.texto,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      receita['tipo']?.toString() ?? 'Receita',
                      style: const TextStyle(color: AppColors.principal),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.principal,
                      size: 18,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Detalhes(receita: receita);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCadastro,
        child: const Icon(Icons.add),
      ),
    );
  }
}
