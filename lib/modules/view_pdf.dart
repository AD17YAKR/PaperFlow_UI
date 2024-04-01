// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../utils/colors.dart';
import 'comment_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

import 'add_new_user.dart';

class PdfViewPage extends StatefulWidget {
  final data;
  const PdfViewPage({super.key, required this.data});

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  String? filePath;

  @override
  void initState() {
    super.initState();
    downloadPdfFile();
  }

  @override
  void dispose() {
    deletePdfFile();
    super.dispose();
  }

  Future<void> downloadPdfFile() async {
    final url = widget.data['url'];
    final dir = await getTemporaryDirectory();
    final fileSavePath = '${dir.path}/Aditya_Kumar_Singh.pdf';

    try {
      final response = await http.get(Uri.parse(url));
      final file = File(fileSavePath);
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        filePath = fileSavePath;
      });
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  Future<void> deletePdfFile() async {
    if (filePath != null) {
      final file = File(filePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PDF Viewer',
        ),
      ),
      body: filePath != null
          ? SfPdfViewer.file(
              File(
                filePath!,
              ),
              key: _pdfViewerKey,
              maxZoomLevel: 3.0,
            )
          : Center(
              child: SizedBox(
                height: 300,
                width: 300,
                child: Lottie.asset('assets/loading.json'),
              ),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () {
              Get.to(CommentPage(
                id: widget.data['_id'],
              ));
            },
            child: const Icon(
              Icons.message,
            ),
          ),
          const SizedBox(height: 16), // Add some spacing between the buttons
          FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () {
              Get.to(AddNewUser(pdfId: widget.data['_id']));
            },
            child: const Icon(
              Icons.person_add,
            ),
          ),
        ],
      ),
    );
  }
}
