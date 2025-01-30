import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  
  final String title;
  final String description;
  final String assetPath;
  
  
  const InfoWidget({
    super.key,
    this.title = '',
    this.description = '',
    this.assetPath = '',
  });

  

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          assetPath,
          scale: 8,
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
              )
            ),
            const SizedBox(height: 3),
            Text(
              description,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}



