import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Gera o PDF no formato da cartela
Future<void> generatePdf(List<List<int>> combinations) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Cartela da Mega-Sena',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            ...combinations.map(
                  (game) => pw.Text(
                'Jogo: ${game.join(', ')}',
                style: pw.TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    ),
  );

  // Abre a interface de impressão ou salvamento do PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
