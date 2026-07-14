import 'package:final_project/reuse/network_place_images.dart';
import 'package:flutter/material.dart';

class SavedPlacesCard extends StatelessWidget {
  final String coverImage;
  final String place;
  final String description;
  final bool isChecked;
  final ValueChanged<bool?>? onChanged;
  const SavedPlacesCard({
    super.key,
    required this.coverImage,
    required this.place,
    required this.description,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              NetworkPlaceImage(fileName:  coverImage, width: 50, height: 50, fit: BoxFit.cover),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(place, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                      SizedBox(height: 5),
                      Text(description, style: TextStyle(color: const Color.fromARGB(255, 101, 101, 101), fontWeight: FontWeight.w500, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              Checkbox(value: isChecked, activeColor: Colors.blue, onChanged: onChanged),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
