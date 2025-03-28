import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/drawerUser.dart';
import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class StoreDetails extends StatefulWidget {
  final String storeName;
  final String storeLocation;
  final String imageUrl;
  final String? description;
  final String? phone;
  final String? startTime;
  final String? endTime;

  const StoreDetails({
    super.key,
    required this.storeName,
    required this.storeLocation,
    required this.imageUrl,
    this.description,
    this.phone,
    this.startTime,
    this.endTime,
  });

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

Future<Uint8List> loadNetworkStoreImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

class _StoreDetailsState extends State<StoreDetails> {
  void _openMap() async {
    String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.storeLocation)}';

    if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
      await launchUrl(Uri.parse(googleMapUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final Uint8List imageBytes = await loadNetworkStoreImage(widget.imageUrl);
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
              pw.Text(widget.storeName,
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Location: ${widget.storeLocation}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Phone: ${widget.phone}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Start time: ${widget.startTime}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('End time: ${widget.endTime}',
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
    final file = File("${output.path}/${widget.storeName}.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareXFiles([XFile(file.path)],
        text: "Your friend share file about store: ${widget.storeName}");
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              child: ClipRRect(
                child: Image.network(
                  widget.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.storeName,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.location_on,
                        size: 26, color: Theme.of(context).iconTheme.color),
                    title: Text(widget.storeLocation),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.phone,
                        size: 26, color: Theme.of(context).iconTheme.color),
                    title: Text(widget.phone!),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.access_time,
                        size: 26, color: Theme.of(context).iconTheme.color),
                    title: Text(
                      (widget.startTime != null && widget.endTime != null)
                          ? '${widget.startTime} - ${widget.endTime}'
                          : 'No information',
                    ),
                  ),
                  const SizedBox(height: 15),
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
                      const SizedBox(width: 10),
                      Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: _openMap,
                          icon: const Icon(Icons.map_outlined),
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
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
