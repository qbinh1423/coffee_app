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
      final userId = pb.authStore.record!.id;

      final toolModel = await pb.collection('tool').create(
        body: {
          ...tool.toJson(),
          'userId': userId,
        },
        files: [
          http.MultipartFile.fromBytes(
            'toolImage',
            await tool.toolImage!.readAsBytes(),
            filename: tool.toolImage!.uri.pathSegments.last,
          ),
        ],
      );

      return tool.copyWith(
        id: toolModel.id,
        imageUrl: _getFeaturedImageUrl(pb, toolModel),
      );
    } catch (error) {
      return null;
    }
  }

  Future<List<Tool>> fetchTools({bool filteredByUser = false}) async {
    final List<Tool> tools = [];

    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      final toolModels = await pb
          .collection('tool')
          .getFullList(filter: filteredByUser ? "userId='$userId'" : null);
      for (final toolModel in toolModels) {
        tools.add(
          Tool.fromJson(
            toolModel.toJson()
              ..addAll({'imageUrl': _getFeaturedImageUrl(pb, toolModel)}),
          ),
        );
      }
      return tools;
    } catch (error) {
      return tools;
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
