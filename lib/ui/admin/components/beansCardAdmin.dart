import 'package:coffee_app/models/bean.dart';
import 'package:coffee_app/ui/admin/pages/bean/bean_manager.dart';
import 'package:coffee_app/ui/admin/pages/bean/editCoffeeBean.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeansCardAdmin extends StatefulWidget {
  final Bean bean;

  const BeansCardAdmin({
    super.key,
    required this.bean,
  });

  @override
  State<BeansCardAdmin> createState() => _BeansCardAdminState();
}

class _BeansCardAdminState extends State<BeansCardAdmin> {
  @override
  void initState() {
    super.initState();
    print("Bean Data: ${widget.bean.toJson()}");
  }

  Future<void> _deleteBean(String id) async {
    final beansManager = context.read<BeansManager>();
    bool isDeleted = await beansManager.deleteBean(id);

    if (isDeleted) {
      await beansManager.fetchBeans();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bean deleted successfully!')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete bean!')),
      );
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.bean.imageUrl,
                width: 180,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bean.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.bean.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
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
                          builder: (context) => EditCoffeeBean(
                            widget.bean,
                            id: widget.bean.id ?? '',
                          ),
                        ),
                      );
                      await context.read<BeansManager>().fetchUserBeans();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: const Text(
                              "Are you sure you want to delete this bean?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _deleteBean(widget.bean.id ?? '');
                              },
                              child: const Text("Delete",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
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
