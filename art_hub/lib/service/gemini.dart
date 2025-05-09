import 'package:flutter_gemini/flutter_gemini.dart';

Future<String?> fazerTextoGemini(List checkListErros, String observacao) async {
  // Constrói o prompt com contexto e lista de erros
  final buffer = StringBuffer();
  buffer.writeln('Por favor, analise a seguinte situação:');
  buffer.writeln(observacao);
  buffer.writeln('\nErros identificados:');
  for (var erro in checkListErros) {
    buffer.writeln('- $erro');
  }
  buffer.writeln(
      '\nCom base nisso, sugira correções e recomendações claras. E sugira uma nota de 0 a 10 que deveria ser dada ao aluno.');

  try {
    final response = await Gemini.instance.prompt(
      parts: [Part.text(buffer.toString())],
    );

    // Formata a resposta para colocar negrito nos trechos com **
    String formattedOutput = response?.output ?? '';
    formattedOutput = formattedOutput.replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
      (match) => '${match.group(1)}',
    );

    return formattedOutput;
  } catch (e) {
    return null;
  }
}
