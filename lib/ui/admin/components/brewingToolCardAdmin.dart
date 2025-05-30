import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_app/models/tool.dart';
import 'package:coffee_app/ui/screens.dart';

class BrewingToolCardAdmin extends StatefulWidget {
  final Tool tool;

  const BrewingToolCardAdmin({
    super.key,
    required this.tool,
  });

  @override
  State<BrewingToolCardAdmin> createState() => _BrewingToolCardAdminState();
}

class _BrewingToolCardAdminState extends State<BrewingToolCardAdmin> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _deleteTool(String id) async {
    final toolsManager = context.read<ToolManager>();
    bool isDeleted = await toolsManager.deleteTool(id);

    if (mounted) {
      if (isDeleted) {
        await toolsManager.fetchTools();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Tool deleted successfully!',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.green.shade200,
          ),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Failed to delete tool!',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.red.shade200,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17.0, bottom: 25.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 180,
                height: 150,
                child: Image.network(
                  widget.tool.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tool.name,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBrewingTool(widget.tool,
                              id: widget.tool.id ?? ''),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: const Text(
                              "Are you sure you want to delete this tool?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                                await _deleteTool(widget.tool.id ?? '');
                              },
                              child: const Text("Delete",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (widget.tool.id != null &&
                          widget.tool.id!.isNotEmpty) {
                        await context
                            .read<ToolManager>()
                            .deleteTool(widget.tool.id!);
                      }
                    },
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
