import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Category extends StatelessWidget {
  final String imagePath;
  final String title;
  const Category({super.key, required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Colors.grey, width: 1), // Garis tepi (outline)
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 50,
            height: 60,
            child: Column(
              children: [
                Image.asset(
                  imagePath,
                  width: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: GoogleFonts.montserrat(fontSize: 10),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
