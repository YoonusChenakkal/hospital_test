import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DottedDivider extends pw.StatelessWidget {
  final PdfColor color;
  final double fontSize;
  final int count;
  DottedDivider({
    this.color = PdfColors.grey400,
    this.fontSize = 20,
    this.count = 80,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Text(
      List.generate(count, (_) => "_").join(" "),
      maxLines: 1,
      style: pw.TextStyle(color: color, fontSize: fontSize),
    );
  }
}
