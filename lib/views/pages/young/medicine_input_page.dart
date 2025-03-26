import 'package:flutter/material.dart';

class Young_MedicinePage extends StatefulWidget {
  const Young_MedicinePage({super.key});

  @override
  State<Young_MedicinePage> createState() => _Young_MedicinePageState();
}

class _Young_MedicinePageState extends State<Young_MedicinePage> {
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int _timesPerDay = 1;
  int _piecesPerTime = 1;
  String _mealTime = 'Before Meal';
  List<TimeOfDay> _alarms = [];

  void _addAlarm() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _alarms.add(pickedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Reminder & Notes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Medicine Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _medicineNameController,
              decoration: const InputDecoration(
                labelText: 'Medicine Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _timesPerDay,
                    items: List.generate(5, (index) => index + 1)
                        .map((e) => DropdownMenuItem(value: e, child: Text('$e times/day')))
                        .toList(),
                    onChanged: (value) => setState(() => _timesPerDay = value!),
                    decoration: const InputDecoration(labelText: 'Times per Day'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _piecesPerTime,
                    items: List.generate(5, (index) => index + 1)
                        .map((e) => DropdownMenuItem(value: e, child: Text('$e pieces/time')))
                        .toList(),
                    onChanged: (value) => setState(() => _piecesPerTime = value!),
                    decoration: const InputDecoration(labelText: 'Pieces per Time'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _mealTime,
              items: ['Before Meal', 'After Meal']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => _mealTime = value!),
              decoration: const InputDecoration(labelText: 'Meal Time'),
            ),
            const SizedBox(height: 30),
            const Text('Set Alarms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ..._alarms.map((alarm) => Text('${alarm.format(context)}', style: const TextStyle(fontSize: 16))).toList(),
            TextButton.icon(
              onPressed: _addAlarm,
              icon: const Icon(Icons.add_alarm),
              label: const Text('Add Alarm'),
            ),
            const SizedBox(height: 30),
            const Text('Custom Note for Elderly', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Write your note here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reminder, Alarms & Note Submitted')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}