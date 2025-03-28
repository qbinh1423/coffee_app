import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/tool.dart';
import 'pocketbase_client.dart';

class ToolService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel toolModel) {
    final toolImage = toolModel.getStringValue('toolImage');
    return pb.files.getUrl(toolModel, toolImage).toString();
  }

  Future<Tool?> addTool(Tool tool) async {
    try {
      final pb = await getPocketbaseInstance();
      print('PocketBase URL: ${pb.baseUrl}');

      if (!pb.authStore.isValid) {
        return null;
      }

      List<http.MultipartFile> files = [];
      if (tool.toolImage != null) {
        final imageBytes = await tool.toolImage!.readAsBytes();
        final filename = tool.toolImage!.uri.pathSegments.last;
        print('Upload file: $filename');

        files.add(http.MultipartFile.fromBytes(
          'toolImage',
          imageBytes,
          filename: filename,
        ));
      }

      final record = await pb.collection('tool').create(
        body: {
          ...tool.toJson(),
          'userId': pb.authStore.model?.id,
        },
        files: files,
      );

      print('Data: ${record.toJson()}');

      return tool.copyWith(
        id: record.id,
        imageUrl: _getFeaturedImageUrl(pb, record),
      );
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  Future<List<Tool>> fetchTools({bool filteredByUser = false}) async {
    final List<Tool> tools = [];

    try {
      final pb = await getPocketbaseInstance();
      String? filter;

      if (filteredByUser && pb.authStore.isValid) {
        final userId = pb.authStore.record?.id;
        filter = "userId='$userId' || userId = ''";
      }

      final toolModels =
          await pb.collection('tool').getFullList(filter: filter);
      print(' Fetched ${toolModels.length} beans from PocketBase.');

      for (final toolModel in toolModels) {
        print('Tool data: ${toolModel.toJson()}');

        tools.add(
          Tool.fromJson(
            toolModel.toJson()
              ..addAll({'imageUrl': _getFeaturedImageUrl(pb, toolModel)}),
          ),
        );
      }
      return tools;
    } catch (error) {
      print('Error fetching tools: $error');
      return [];
    }
  }

  Future<Tool?> updateTool(Tool tool) async {
    try {
      final pb = await getPocketbaseInstance();
      final toolModel = await pb.collection('tool').update(
            tool.id!,
            body: tool.toJson(),
            files: tool.toolImage != null
                ? [
                    http.MultipartFile.fromBytes(
                      'toolImage',
                      await tool.toolImage!.readAsBytes(),
                      filename: tool.toolImage!.uri.pathSegments.last,
                    ),
                  ]
                : [],
          );
      return tool.copyWith(
        imageUrl: tool.toolImage != null
            ? _getFeaturedImageUrl(pb, toolModel)
            : tool.imageUrl,
      );
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteTool(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('tool').delete(id);
      return true;
    } catch (error) {
      return false;
    }
  }
}
