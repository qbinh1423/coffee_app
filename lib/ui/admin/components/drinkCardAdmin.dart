import 'package:coffee_app/models/drink.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_app/ui/screens.dart';

class DrinkCardAdmin extends StatefulWidget {
  final Drink drink;
  const DrinkCardAdmin({super.key, required this.drink});

  @override
  State<DrinkCardAdmin> createState() => _DrinkCardAdminState();
}

class _DrinkCardAdminState extends State<DrinkCardAdmin> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _deleteDrink(String id) async {
    if (id.isEmpty) {
      return;
    }

    final drinkManager = context.read<DrinkManager>();
    bool isDeleted = await drinkManager.deleteDrink(id);

    if (isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Drink deleted successfully!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.green.shade200,
        ),
      );
      await drinkManager.fetchDrink();
      if (mounted) {
        setState(() {});
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Failed to delete drink!',
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
    print("Drink Name: ${widget.drink.name}");

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
                widget.drink.imageUrl,
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
                      widget.drink.name,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 20),
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
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDrink(
                            widget.drink,
                            id: widget.drink.id ?? '',
                          ),
                        ),
                      );
                      await context.read<DrinkManager>().fetchUserDrinks();
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
                                await _deleteDrink(widget.drink.id ?? '');
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
