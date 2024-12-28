import 'package:flutter/material.dart';
import 'lottery_logic.dart'; // Importa a lógica do desdobramento
import 'pdf_generator.dart'; // Importa a função para gerar o PDF

void main() {
  runApp(const MegaSenaApp());
}

class MegaSenaApp extends StatelessWidget {
  const MegaSenaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mega-Sena',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MegaSenaHomePage(),
    );
  }
}

class MegaSenaHomePage extends StatefulWidget {
  @override
  _MegaSenaHomePageState createState() => _MegaSenaHomePageState();
}

class _MegaSenaHomePageState extends State<MegaSenaHomePage> {
  final Set<int> selectedNumbers = {};
  List<List<int>> combinations = [];

  // Seleciona ou desmarca números
  void toggleNumber(int number) {
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number);
      } else {
        selectedNumbers.add(number);
      }
    });
  }

  // Gera desdobramentos
  void generate() {
    try {
      setState(() {
        combinations = generateCombinations(
          selectedNumbers.toList(),
          6, // Tamanho do grupo (Mega-Sena usa 6 números)
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mega-Sena Gerador'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text('Selecione os números:', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),

          // Tabela de números centralizada
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6, // Ajusta a largura total da tabela
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10, // 10 colunas (10 números por linha)
                    childAspectRatio: 1.5, // Quadrados perfeitos
                    crossAxisSpacing: 2, // Espaçamento horizontal
                    mainAxisSpacing: 2, // Espaçamento vertical
                  ),

                  itemCount: 60, // Total de números
                  itemBuilder: (context, index) {
                    final number = index + 1; // Números de 1 a 60
                    final isSelected = selectedNumbers.contains(number);
                    return GestureDetector(
                      onTap: () => toggleNumber(number), // Seleciona/desmarca o número
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.white, // Cor do quadrado
                          border: Border.all(color: Colors.black), // Borda preta
                          borderRadius: BorderRadius.circular(4), // Bordas arredondadas leves
                        ),
                        alignment: Alignment.center, // Centraliza o número
                        child: Text(
                          '$number',
                          style: TextStyle(
                            fontSize: 14, // Tamanho menor para se ajustar ao quadrado
                            color: isSelected ? Colors.white : Colors.black, // Cor do número
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Botão para gerar combinações
          ElevatedButton(
            onPressed: generate,
            child: const Text('Gerar Combinações'),
          ),
          const SizedBox(height: 10),
          // Exibição das combinações geradas
          Expanded(
            child: ListView.builder(
              itemCount: combinations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Jogo ${index + 1}: ${combinations[index].join(', ')}',
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Botão para imprimir a cartela
          ElevatedButton(
            onPressed: () async {
              if (combinations.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nenhuma combinação gerada!')),
                );
                return;
              }
              await generatePdf(combinations); // Gera o PDF com as combinações
            },
            child: const Text('Imprimir Cartela'),
          ),
        ],
      ),
    );
  }
}
