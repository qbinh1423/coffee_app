import 'dart:io';
import 'dart:typed_data';

import 'package:coffee_app/theme/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../components/drawerUser.dart';
import '../../../../theme/theme.dart';

class BeanDetails extends StatefulWidget {
  final String beanName;
  final String imageUrl;
  final String altitude;
  final String climate;
  final String caffeine;
  final String? description;
  const BeanDetails({
    super.key,
    required this.beanName,
    required this.imageUrl,
    required this.altitude,
    required this.climate,
    required this.caffeine,
    this.description,
  });
  @override
  State<BeanDetails> createState() => _BeanDetailsState();
}

Future<Uint8List> loadNetworkBeanImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

class _BeanDetailsState extends State<BeanDetails> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    Future<void> generatePDF() async {
      final pdf = pw.Document();
      final Uint8List imageBytes = await loadNetworkBeanImage(widget.imageUrl);
      final pw.MemoryImage image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Image(image,
                      width: 300, height: 200, fit: pw.BoxFit.cover),
                ),
                pw.SizedBox(height: 10),
                pw.Text(widget.beanName,
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Altitude: ${widget.altitude}',
                    style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.Text('Climate: ${widget.climate}',
                    style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.Text('Caffeine: ${widget.caffeine}',
                    style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.Text('Description:',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text(widget.description ?? "No description"),
              ],
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/${widget.beanName}.pdf");
      await file.writeAsBytes(await pdf.save());

      Share.shareXFiles([XFile(file.path)],
          text:
              "You receive a share file about bean coffee: ${widget.beanName}");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Icon(
                Icons.menu,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          ThemeButton(
            changeThemeMode: (isBright) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      drawer: const DrawerUser(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(widget.imageUrl,
                                fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.beanName,
                    style: GoogleFonts.dmSerifDisplay(fontSize: 38),
                  ),
                  ListTile(
                    leading: const Icon(Icons.terrain, size: 26),
                    title: const Text(
                      'Altitude',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.altitude,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.wb_cloudy, size: 26),
                    title: const Text(
                      'Climate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.climate,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.mugHot, size: 26),
                    title: const Text(
                      'Caffein',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.caffeine,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: generatePDF,
                          icon: const Icon(Icons.share),
                          iconSize: 26.0,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.description!,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
