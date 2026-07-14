import 'package:flutter/material.dart';

class MainSquare extends StatelessWidget {
  final Color squareColor;
  final Color iconColor;
  final String title;
  final IconData myIcon;
  const MainSquare({super.key, required this.squareColor, required this.iconColor, required this.title, required this.myIcon});

  @override
  Widget build(BuildContext context) {
    // CHANGED: no fixed width/height anymore. This now fills whatever
    // width its parent (an Expanded in home_page's Row) gives it, and
    // AspectRatio keeps it square regardless of screen size.
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: squareColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(myIcon, size: 32, color: iconColor),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color.fromARGB(255, 126, 125, 125),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
