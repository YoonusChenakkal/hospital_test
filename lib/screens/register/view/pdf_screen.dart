import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hospital_app/screens/register/view/widget/dotted_divider.dart';
import 'package:hospital_app/screens/widgets/custom_appbar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PatientInvoicePdfScreen extends StatelessWidget {
  final String patientName;
  final List<Map<String, dynamic>> patientDetailsSet;
  final String patientAddress;
  final String patientPhone;
  final String totalAmount;
  final String discountAmount;
  final String advanceAmount;
  final String balanceAmount;
  final String dateNdTime;

  const PatientInvoicePdfScreen({
    Key? key,
    required this.patientName,
    required this.patientDetailsSet,
    required this.patientAddress,
    required this.patientPhone,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateNdTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: PdfPreview(
        build: (format) => generatePatientPdf(
          patientName,
          patientDetailsSet,
          patientAddress,
          patientPhone,
          totalAmount,
          discountAmount,
          advanceAmount,
          balanceAmount,
          dateNdTime,
        ),
      ),
    );
  }
}

Future<Uint8List> generatePatientPdf(
  String patientName,
  List<Map<String, dynamic>> patientDetailsSet,
  String patientAddress,
  String patientPhone,
  String totalAmount,
  String discountAmount,
  String advanceAmount,
  String balanceAmount,
  String dateNdTime,
) async {
  // Load fonts and images
  final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
  final ttf = pw.Font.ttf(fontData);

  final ByteData logoByteData = await rootBundle.load(
    'assets/logo/pdf_logo.png',
  );
  final Uint8List logoBytes = logoByteData.buffer.asUint8List();
  final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

  //  sign
  final ByteData signByteData = await rootBundle.load('assets/images/sign.png');
  final Uint8List signBytes = signByteData.buffer.asUint8List();
  final pw.MemoryImage signImage = pw.MemoryImage(signBytes);

  final ByteData watermarkByteData = await rootBundle.load(
    'assets/logo/pdf_logo.png',
  );
  final Uint8List watermarkBytes = watermarkByteData.buffer.asUint8List();
  final pw.MemoryImage watermarkImage = pw.MemoryImage(watermarkBytes);

  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(base: ttf, bold: ttf),
  );

  const PdfColor primaryColor = PdfColor.fromInt(0xFF1E8830);
  const PdfColor greyColor = PdfColor.fromInt(0xFF757575);

  final pw.TextStyle headerStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 18,
    color: primaryColor,
  );
  final pw.TextStyle normalTextStyle = pw.TextStyle(fontSize: 10);
  final pw.TextStyle normalTextStyle2 = pw.TextStyle(
    fontSize: 10,
    color: greyColor,
  );

  final pw.TextStyle boldTextStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 10,
  );
  final pw.TextStyle tableHeaderStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 10,
    color: primaryColor,
  );
  final pw.TextStyle totalAmountStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 12,
  );
  final pw.TextStyle thankYouStyle = pw.TextStyle(
    fontSize: 12,
    fontWeight: pw.FontWeight.bold,
    color: primaryColor,
  );
  final pw.TextStyle disclaimerStyle = pw.TextStyle(
    fontSize: 8,
    color: greyColor,
  );

  pw.SizedBox _vSpace(double height) => pw.SizedBox(height: height);
  pw.SizedBox _hSpace(double width) => pw.SizedBox(width: width);

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return dateString.split(' ')[0];
    }
  }

  String formatTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('hh:mma').format(dateTime);
    } catch (e) {
      return dateString.split(' ').length > 1
          ? dateString.split(' ')[1]
          : 'N/A';
    }
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(30),
      build: (pw.Context context) {
        return [
          pw.Stack(
            children: [
              // 🔹 Watermark
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: .1,

                    child: pw.Image(watermarkImage, width: 360, height: 360),
                  ),
                ),
              ),
              // 🔹 Actual page content
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Image(logoImage, width: 60, height: 60),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'KUMARAKOM',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          _vSpace(5),
                          pw.Text(
                            'Cheepunkal P.O. Kumarakom, Kottayam, Kerala - 686563',
                            style: normalTextStyle2,
                          ),
                          _vSpace(4),

                          pw.Text(
                            'E-mail: unknown@gmail.com',
                            style: normalTextStyle2,
                          ),
                          _vSpace(4),

                          pw.Text(
                            'Mob: +91 9876543210 | +91 9786543210',
                            style: normalTextStyle2,
                          ),
                          _vSpace(6),

                          pw.Text(
                            'GST No: 32AABCU9603R1ZW',
                            style: normalTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  _vSpace(20),
                  pw.Divider(color: PdfColors.grey400),
                  _vSpace(10),

                  pw.Text('Patient Details', style: headerStyle),
                  _vSpace(10),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text('Name', style: boldTextStyle),
                                _hSpace(20),
                                pw.Text(patientName, style: normalTextStyle2),
                              ],
                            ),
                            _vSpace(5),
                            pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Address', style: boldTextStyle),
                                _hSpace(10),
                                pw.Expanded(
                                  child: pw.Text(
                                    patientAddress,
                                    style: normalTextStyle2,
                                  ),
                                ),
                              ],
                            ),
                            _vSpace(5),
                            pw.Row(
                              children: [
                                pw.Text(
                                  'WhatsApp Number',
                                  style: boldTextStyle,
                                ),
                                _hSpace(10),
                                pw.Text(patientPhone, style: normalTextStyle2),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _hSpace(20),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text('Booked On', style: boldTextStyle),
                                _hSpace(10),
                                pw.Text(
                                  '${DateFormat('dd/MM/yyyy | hh:mma').format(DateTime.now())}',
                                  style: normalTextStyle2,
                                ),
                              ],
                            ),
                            _vSpace(5),
                            pw.Row(
                              children: [
                                pw.Text('Treatment Date', style: boldTextStyle),
                                _hSpace(10),
                                pw.Text(
                                  formatDate(dateNdTime),
                                  style: normalTextStyle2,
                                ),
                              ],
                            ),
                            _vSpace(5),
                            pw.Row(
                              children: [
                                pw.Text('Treatment Time', style: boldTextStyle),
                                _hSpace(10),
                                pw.Text(
                                  formatTime(dateNdTime),
                                  style: normalTextStyle2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _vSpace(10),
                  DottedDivider(),

                  pw.Table.fromTextArray(
                    border: null,
                    headerAlignment: pw.Alignment.centerLeft,
                    cellAlignment: pw.Alignment.centerLeft,
                    cellPadding: const pw.EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 5,
                    ),

                    headers: ['Treatment', 'Price', 'Male', 'Female', 'Total'],
                    headerStyle: tableHeaderStyle,
                    cellStyle: normalTextStyle,
                    columnWidths: {
                      0: const pw.FlexColumnWidth(2.5),
                      1: const pw.FlexColumnWidth(1),
                      2: const pw.FlexColumnWidth(0.8),
                      3: const pw.FlexColumnWidth(0.8),
                      4: const pw.FlexColumnWidth(1.2),
                    },
                    data: patientDetailsSet.map((detail) {
                      const double baseTreatmentPrice = 230.0;
                      int maleCount =
                          int.tryParse(detail['male'] as String) ?? 0;
                      int femaleCount =
                          int.tryParse(detail['female'] as String) ?? 0;
                      double individualTotal =
                          baseTreatmentPrice * (maleCount + femaleCount);

                      return [
                        detail['treatmentName'] ?? 'N/A',
                        '₹${baseTreatmentPrice.toStringAsFixed(0)}',
                        detail['male'],
                        detail['female'],
                        '₹${individualTotal.toStringAsFixed(0)}',
                      ];
                    }).toList(),
                  ),
                  pw.Center(child: DottedDivider()),
                  _vSpace(15),

                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Text('Total Amount', style: totalAmountStyle),
                            _hSpace(20),
                            pw.Text('₹${totalAmount}', style: totalAmountStyle),
                          ],
                        ),
                        _vSpace(5),
                        pw.Row(
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Text('Discount', style: normalTextStyle),
                            _hSpace(20),
                            pw.Text(
                              '₹${discountAmount}',
                              style: normalTextStyle,
                            ),
                          ],
                        ),
                        _vSpace(5),
                        pw.Row(
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Text('Advance', style: normalTextStyle),
                            _hSpace(10),
                            pw.Text(
                              '₹${advanceAmount}',
                              style: normalTextStyle,
                            ),
                          ],
                        ),
                        pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: DottedDivider(count: 7),
                        ),
                        _vSpace(5),

                        pw.Row(
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Text('Balance', style: totalAmountStyle),
                            _hSpace(20),
                            pw.Text(
                              '₹${balanceAmount}',
                              style: totalAmountStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _vSpace(20),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          textAlign: pw.TextAlign.right,
                          'Thank you for choosing us',
                          style: thankYouStyle,
                        ),
                        _vSpace(5),
                        pw.Text(
                          'Your well-being is our commitment, and we\'re honored\nyou\'ve entrusted us with your health journey',
                          textAlign: pw.TextAlign.right,
                          style: normalTextStyle2,
                        ),
                        _vSpace(20),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(right: 30),
                          child: pw.Image(signImage, width: 60, height: 60),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 40),
                  pw.Center(child: DottedDivider(count: 30)),
                  pw.SizedBox(height: 20),
                  pw.Align(
                    alignment: pw.Alignment.bottomCenter,
                    child: pw.Text(
                      'Booking amount is non-refundable, and it\'s important to arrive on the allotted time for your treatment',
                      style: disclaimerStyle,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ];
      },
    ),
  );
  return pdf.save();
}
