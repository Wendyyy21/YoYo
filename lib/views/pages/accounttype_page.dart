import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/views/pages/linkaccount_page.dart';
import 'package:frontend/views/widgets/accounttype_widget.dart';

class AccountTypePage extends StatefulWidget {
  const AccountTypePage({super.key});

  @override
  State<AccountTypePage> createState() => _AccountTypePageState();
}

class _AccountTypePageState extends State<AccountTypePage> {
  int? selectedType; // 0 for elderly, 1 for young

  void onTypeSelected(int type) {
    setState(() {
      selectedType = type;
    });
  }

  void validateAccountType() {
    if (selectedType == 0 || selectedType == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LinkAccountPage();
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select an account type')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Create an account')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Select account type',
                  style: TextStyle(fontSize: 30.0),
                ),
                const SizedBox(height: 20.0),
                AccountTypeWidget(
                  imagePath: 'assets/images/elderly_avatar.png',
                  text: "I'm an\nelderly user",
                  type: 0,
                  isSelected: selectedType == 0,
                  onSelect: onTypeSelected,
                ),
                const SizedBox(width: 30.0),
                AccountTypeWidget(
                  imagePath: 'assets/images/young_avatar.png',
                  text: "I'm a\nyoung user",
                  type: 1,
                  isSelected: selectedType == 1,
                  onSelect: onTypeSelected,
                ),
                const SizedBox(height: 20.0),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.buttonTeal,
                    fixedSize: Size(250.0, 50.0),
                    side: BorderSide(color: AppColors.buttonTeal, width: 1.5),
                  ),
                  onPressed: () {
                    validateAccountType();
                  },
                  child: const Text('Next', style: TextStyle(fontSize: 20.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
