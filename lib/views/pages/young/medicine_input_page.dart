import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'dart:math';

class MedicineDosage {
  final TimeOfDay time;
  final int quantity;

  MedicineDosage({required this.time, required this.quantity});
}

class Medicine {
  String id;
  String name;
  String mealTime;
  List<MedicineDosage> dosages;
  String note;
  String? elderlyName;
  List<String> frequency;

  Medicine({
    required this.id,
    required this.name,
    required this.mealTime,
    this.dosages = const [],
    this.note = '',
    this.elderlyName,
    this.frequency = const [],
  });
}

class Young_MedicinePage extends StatefulWidget {
  const Young_MedicinePage({super.key});

  @override
  State<Young_MedicinePage> createState() => _YoungMedicinePageState();
}

class _YoungMedicinePageState extends State<Young_MedicinePage> {
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _mealTime = 'Before Meal';
  List<MedicineDosage> _dosages = [];
  List<String> _selectedFrequency = [];

  final List<String> _elderlyList = [
    "Grandma (Alice)",
    "Grandpa (Bob)",
    "Uncle Charlie",
    "Aunt Daisy",
  ];
  String? _selectedElderly;

  List<Medicine> _medicines = [];
  Medicine? _editingMedicine;
  bool _isEditing = false;
  bool _isFormExpanded = false;

  void _addDosage() async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedTime != null) {
    int selectedQuantity = 1;
    final quantity = await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Medicine Quantity'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('How many tablets should be taken?'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (selectedQuantity > 1) {
                            setState(() => selectedQuantity--);
                          }
                        },
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '$selectedQuantity',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (selectedQuantity < 10) {
                            setState(() => selectedQuantity++);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: Slider(
                      value: selectedQuantity.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: selectedQuantity.toString(),
                      onChanged: (value) {
                        setState(() {
                          selectedQuantity = value.toInt();
                        });
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, selectedQuantity),
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );

    if (quantity != null) {
      setState(() {
        _dosages.add(MedicineDosage(time: pickedTime, quantity: quantity));
      });
    }
  }
}

  void _saveMedicine() {
    if (_medicineNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter medicine name')),
      );
      return;
    }

    if (_selectedElderly == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an elderly person')),
      );
      return;
    }

    final newMedicine = Medicine(
      id: _editingMedicine?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _medicineNameController.text,
      mealTime: _mealTime,
      dosages: List.from(_dosages),
      note: _noteController.text,
      elderlyName: _selectedElderly,
      frequency: _selectedFrequency,
    );

    setState(() {
      if (_isEditing) {
        final index = _medicines.indexWhere((m) => m.id == _editingMedicine!.id);
        if (index != -1) {
          _medicines[index] = newMedicine;
        }
      } else {
        _medicines.add(newMedicine);
      }

      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Medicine updated' : 'Medicine added')),
      );
    });
  }

  void _editMedicine(Medicine medicine) {
    setState(() {
      _editingMedicine = medicine;
      _isEditing = true;
      _isFormExpanded = true;
      _medicineNameController.text = medicine.name;
      _mealTime = medicine.mealTime;
      _dosages = List.from(medicine.dosages);
      _noteController.text = medicine.note;
      _selectedElderly = medicine.elderlyName;
      _selectedFrequency = List.from(medicine.frequency);
    });
  }

  void _deleteMedicine(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: const Text('Are you sure you want to delete this medicine?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _medicines.removeWhere((m) => m.id == id);
                if (_editingMedicine?.id == id) {
                  _resetForm();
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Medicine deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _medicineNameController.clear();
      _noteController.clear();
      _mealTime = 'Before Meal';
      _dosages.clear();
      _editingMedicine = null;
      _selectedElderly = null;
      _selectedFrequency.clear();
      _isEditing = false;
      _isFormExpanded = false;
    });
  }

  void _toggleFormExpansion() {
    setState(() {
      _isFormExpanded = !_isFormExpanded;
    });
  }

  Widget _buildFrequencySelector() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consume Frequency',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: days.map((day) {
            final isSelected = _selectedFrequency.contains(day);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFrequency.remove(day);
                  } else {
                    _selectedFrequency.add(day);
                  }
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.titleGreen : Colors.grey[300],
                ),
                alignment: Alignment.center,
                child: Text(
                  day,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Management'),
      ),
      body: Column(
        children: [
          // Form Section
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isFormExpanded ? min(MediaQuery.of(context).size.height * 0.7 - 45 , 600) : 48,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      _isEditing ? 'Edit Medicine' : 'Add New Medicine',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: _isEditing
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _isFormExpanded = false;
                                _resetForm();
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              _isFormExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                            onPressed: _toggleFormExpansion,
                          ),
                  ),
                  if (_isFormExpanded) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedElderly,
                            decoration: const InputDecoration(
                              labelText: 'Select Elderly',
                              border: OutlineInputBorder(),
                            ),
                            items: _elderlyList.map((elderly) {
                              return DropdownMenuItem(
                                value: elderly,
                                child: Text(elderly),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedElderly = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          TextField(
                            controller: _medicineNameController,
                            decoration: const InputDecoration(
                              labelText: 'Medicine Name',
                              border: OutlineInputBorder(),
                              hintText: 'Enter medicine name',
                            ),
                          ),
                          const SizedBox(height: 20),

                          DropdownButtonFormField<String>(
                            value: _mealTime,
                            items: ['Before Meal', 'After Meal']
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => _mealTime = value!),
                            decoration: const InputDecoration(
                              labelText: 'Meal Time',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildFrequencySelector(),

                          const Text(
                            'Time & Quantity',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          if (_dosages.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('No dosages added yet'),
                            ),
                          ..._dosages.map((dosage) => Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Time: ${dosage.time.format(context)}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Quantity: ${dosage.quantity} piece${dosage.quantity > 1 ? 's' : ''}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => setState(() => _dosages.remove(dosage)),
                                      ),
                                    ],
                                  ),
                                ),
                              )).toList(),
                          ElevatedButton.icon(
                            onPressed: _addDosage,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Time & Quantity'),
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            'Custom Note for Elderly',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _noteController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Write your note here...',
                              border: OutlineInputBorder(),
                              hintText: 'Any special instructions...',
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: _saveMedicine,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                child: Text(_isEditing ? 'Update Medicine' : 'Add Medicine'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // Medicines List Section
          Expanded(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_isEditing) {
                      setState(() {
                        _isFormExpanded = false;
                        _resetForm();
                      });
                    } else {
                      _toggleFormExpansion();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isEditing) ...[
                            Container(
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Icon(
                                _isFormExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            'Current Medicines (${_medicines.length})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _medicines.isEmpty
                      ? const Center(
                          child: Text(
                            'No medicines added yet',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _medicines.length,
                          itemBuilder: (context, index) {
                            final medicine = _medicines[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              elevation: 1,
                              child: ListTile(
                                title: Text(
                                  medicine.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text('For: ${medicine.elderlyName ?? "Not specified"}'),
                                    Text('Meal: ${medicine.mealTime}'),
                                    if (medicine.frequency.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Frequency: ${medicine.frequency.join(', ')}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    if (medicine.dosages.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: medicine.dosages.map((dosage) => Text(
                                            '${dosage.time.format(context)} - ${dosage.quantity} piece${dosage.quantity > 1 ? 's' : ''}',
                                            style: const TextStyle(fontSize: 13),
                                          )).toList(),
                                        ),
                                      ),
                                    if (medicine.note.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Note: ${medicine.note}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _editMedicine(medicine),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteMedicine(medicine.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}