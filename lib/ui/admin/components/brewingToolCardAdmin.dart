import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_app/models/tool.dart';
import '../../../theme/theme.dart';
import '../../../theme/themeProvider.dart';
import '../components/adminDrawer.dart';
import '../pages/tool/editBrewingTool.dart';
import '../pages/tool/toolManager.dart';

class BrewingToolCardAdmin extends StatelessWidget {
  final Tool tool;

  const BrewingToolCardAdmin({super.key, required this.tool});

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
                  tool.imageUrl,
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
                    tool.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    tool.description,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditBrewingTool(tool, id: tool.id ?? ''),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog(
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
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Delete",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (tool.id != null && tool.id!.isNotEmpty) {
                        await context.read<ToolManager>().deleteTool(tool.id!);
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
