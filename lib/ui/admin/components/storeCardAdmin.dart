import 'package:coffee_app/models/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_app/ui/screens.dart';


class StoreCardAdmin extends StatefulWidget {
  final Store store;

  const StoreCardAdmin({super.key, required this.store});

  @override
  State<StoreCardAdmin> createState() => _StoreCardAdminState();
}

class _StoreCardAdminState extends State<StoreCardAdmin> {
  @override
  void initState() {
    super.initState();
    debugPrint("Store Data: ${widget.store.toJson()}");
  }

  Future<void> _deleteStore(String id) async {
    final storeManager = context.read<StoreManager>();
    bool isDeleted = await storeManager.deleteStore(id);

    if (isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Store deleted successfully!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.green.shade200,
        ),
      );
      await storeManager.fetchUserStore();
      if (mounted) {
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Failed to delete store!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.red.shade200,
        ),
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
                widget.store.imageUrl,
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
                      widget.store.name,
                      style: const TextStyle(fontSize: 20),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditStore(
                            widget.store,
                            id: widget.store.id ?? '',
                          ),
                        ),
                      );
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
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                                await _deleteStore(widget.store.id ?? '');
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
