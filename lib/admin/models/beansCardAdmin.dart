import 'package:coffee_app/admin/informations/editCoffeeBean.dart';
import 'package:flutter/material.dart';

class BeansCardAdmin extends StatefulWidget {
  final String beanName;
  final String imageUrl;
  final String? altitude;
  final String? climate;
  final String? caffeine;
  final String? description;

  const BeansCardAdmin({
    super.key,
    required this.beanName,
    required this.imageUrl,
    this.altitude,
    this.climate,
    this.caffeine,
    this.description,
  });

  @override
  State<BeansCardAdmin> createState() => _BeansCardAdminState();
}

class _BeansCardAdminState extends State<BeansCardAdmin> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
                child: SizedBox(
                  width: 180,
                  height: 150,
                  child: Image.asset(widget.imageUrl, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.beanName,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
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
                            builder: (context) => EditCoffeeBean(
                              beanName: widget.beanName,
                              imageUrl: widget.imageUrl,
                              altitude: widget.altitude ?? '',
                              climate: widget.climate ?? '',
                              caffeine: widget.caffeine ?? '',
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
                                "Are you sure you want to delete this bean?"),
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
        ),
      ),
    );
  }
}
