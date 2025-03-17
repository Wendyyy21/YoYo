import 'package:flutter/material.dart';

class AccountTypeWidget extends StatelessWidget {
  const AccountTypeWidget({
    super.key,
    required this.imagePath,
    required this.text,
    required this.type,
    required this.isSelected,
    required this.onSelect,
  });

  final String imagePath;
  final String text;
  final int type; // 0 = elderly, 1 = young
  final bool isSelected;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(type),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            width: 3.0,
            color:
                isSelected ? Colors.green : Color.fromARGB(255, 249, 219, 110),
          ),
        ),
        color: const Color.fromARGB(255, 249, 219, 110),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(imagePath),
                radius: 80.0,
              ),
              SizedBox(width: 30.0),
              Text(
                text,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
