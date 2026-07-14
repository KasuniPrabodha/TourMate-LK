import 'package:flutter/material.dart';

class Budget extends StatelessWidget {
  final String budget;
  final String description;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const Budget({
    super.key,
    required this.budget,
    required this.description,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(budget, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                        const SizedBox(height: 5),
                        Text(description, style: const TextStyle(color: Color.fromARGB(255, 101, 101, 101), fontWeight: FontWeight.w500, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Text(price, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
                Radio<bool>(
                  value: true,
                  // ignore: deprecated_member_use
                  groupValue: isSelected,
                  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.blue;
                    }
                    return Colors.grey;
                  }),
                  // ignore: deprecated_member_use
                  onChanged: (_) => onTap(),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
