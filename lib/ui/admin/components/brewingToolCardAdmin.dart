import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_app/models/tool.dart';
import '../pages/tool/editBrewingTool.dart';
import '../pages/tool/toolManager.dart';

class BrewingToolCardAdmin extends StatefulWidget {
  final Tool tool;

  const BrewingToolCardAdmin({super.key, required this.tool});

  @override
  State<BrewingToolCardAdmin> createState() => _BrewingToolCardAdminState();
}

class _BrewingToolCardAdminState extends State<BrewingToolCardAdmin> {
  @override
  void initState() {
    super.initState();
    print("Tool Data: ${widget.tool.toJson()}");
  }

  Future<void> _deleteTool(String id) async {
    final toolsManager = context.read<ToolManager>();
    bool isDeleted = await toolsManager.deleteTool(id);

    if (isDeleted) {
      await toolsManager.fetchTools();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tool deleted successfully!')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete tool!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17.0, bottom: 25.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 300,
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
                width: 70,
                height: 70,
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
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    widget.tool.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
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
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBrewingTool(widget.tool,
                              id: widget.tool.id ?? ''),
                        ),
                      );
                      await context.read<ToolManager>().fetchUserTool();

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
                                Navigator.pop(context);
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




// import 'package:flutter/material.dart';
// import '../../../models/tool.dart';
// import '../pages/tool/editBrewingTool.dart';

// class BrewingToolCardAdmin extends StatelessWidget {
//   final Tool tool;
//   const BrewingToolCardAdmin({required this.tool, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: [
//           Expanded(
//             child: tool.imageUrl.isEmpty
//                 ? const Icon(Icons.image_not_supported, size: 50)
//                 : Image.network(tool.imageUrl, fit: BoxFit.cover),
//           ),
//           ListTile(
//             title: Text(tool.name),
//             subtitle: Text(tool.origin),
//             trailing: IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => EditBrewingTool(tool: tool)),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
