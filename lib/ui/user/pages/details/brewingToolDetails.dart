import 'dart:io';
import 'dart:typed_data';

import 'package:coffee_app/theme/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../components/drawerUser.dart';
import '../../../../theme/theme.dart';

class BrewingToolDetails extends StatefulWidget {
  final String name;
  final String origin;
  final String type;
  final String material;
  final String? description;
  final String imageUrl;

  const BrewingToolDetails({
    super.key,
    required this.name,
    required this.origin,
    required this.type,
    required this.material,
    required this.imageUrl,
    this.description,
  });

  @override
  State<BrewingToolDetails> createState() => _BrewingToolDetailsState();
}

Future<Uint8List> loadNetworkToolImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

class _BrewingToolDetailsState extends State<BrewingToolDetails> {
  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final Uint8List imageBytes = await loadNetworkToolImage(widget.imageUrl);
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
              pw.Text(widget.name,
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Origin: ${widget.origin}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Type: ${widget.type}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Material: ${widget.material}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Description:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(widget.description ?? "No description"),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${widget.name}.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareXFiles([XFile(file.path)],
        text: "You receive a share file about drink: ${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

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
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                    widget.name,
                    style: GoogleFonts.dmSerifDisplay(fontSize: 38),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on, size: 26),
                    title: const Text(
                      'Origin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.origin,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.type_specimen, size: 26),
                    title: const Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.type,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.build, size: 26),
                    title: const Text(
                      'Material',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.material,
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
                  const SizedBox(height: 10),
                  Text(
                    widget.description!,
                    style: const TextStyle(
                      fontSize: 14,
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
