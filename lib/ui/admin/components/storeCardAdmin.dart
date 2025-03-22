import 'package:coffee_app/ui/admin/pages/store/editStore.dart';
import 'package:flutter/material.dart';

class StoreCardAdmin extends StatefulWidget {
  final String storeName;
  final String storeLocation;
  final String imageUrl;
  final String? description;
  final String? phone;
  final String? time;

  const StoreCardAdmin({
    super.key,
    required this.storeName,
    required this.storeLocation,
    required this.imageUrl,
    this.phone,
    this.time,
    this.description,
  });

  @override
  State<StoreCardAdmin> createState() => _StoreCardAdminState();
}

class _StoreCardAdminState extends State<StoreCardAdmin> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                widget.imageUrl,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.storeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 16, color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        widget.storeLocation,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditStore(
                          storeName: widget.storeName,
                          storeLocation: widget.storeLocation,
                          imageUrl: widget.imageUrl,
                          phone: widget.phone ?? '',
                          time: widget.time ?? '',
                          description: widget.description ?? '',
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
                            "Are you sure you want to delete this store?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {},
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
    );
  }
}
