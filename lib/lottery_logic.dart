import 'dart:math';

// Gera desdobramentos a partir dos números selecionados
List<List<int>> generateCombinations(List<int> selectedNumbers, int groupSize) {
  if (selectedNumbers.length < groupSize) {
    throw Exception("Selecione ao menos $groupSize números para desdobrar!");
  }

  List<List<int>> combinations = [];
  void combine(List<int> current, int start) {
    if (current.length == groupSize) {
      combinations.add(List.from(current));
      return;
    }
    for (int i = start; i < selectedNumbers.length; i++) {
      current.add(selectedNumbers[i]);
      combine(current, i + 1);
      current.removeLast();
    }
  }

  combine([], 0);
  return combinations;
}
