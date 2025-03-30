import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Dosage {
  final TimeOfDay time;
  final int quantity;

  Dosage({required this.time, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'time': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'quantity': quantity,
    };
  }
}

class Medicine {
  final String id;
  final String name;
  final String mealTime;
  final List<String> frequency;
  final List<Dosage> dosages;
  final String note;
  final String? elderlyName;

  Medicine({
    required this.id,
    required this.name,
    required this.mealTime,
    required this.frequency,
    required this.dosages,
    required this.note,
    this.elderlyName,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mealTime': mealTime,
      'frequency': frequency,
      'dosages': dosages.map((dosage) => dosage.toMap()).toList(),
      'note': note,
      'elderlyName': elderlyName,
    };
  }
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
  List<Dosage> _dosages = [];
  List<String> _selectedFrequency = [];
  String? _selectedElderly;
  List<String> _elderlyList = [];
  List<Medicine> _medicines = [];
  Medicine? _editingMedicine;
  bool _isEditing = false;
  bool _isFormExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchElders();
    _fetchMedicines();
  }

  Future<void> _fetchElders() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String familyCode = userSnapshot['familyCode'];

      DocumentSnapshot familySnapshot = await FirebaseFirestore.instance
          .collection('family')
          .doc(familyCode)
          .get();

      List<String> memberIds = [];
      Map<String, dynamic>? familyData = familySnapshot.data() as Map<String, dynamic>?;

      if (familyData != null) {
        familyData.forEach((key, value) {
          if (key.startsWith('member') && value is String) {
            memberIds.add(value);
          }
        });
      }

      List<String> elders = [];
      for (String memberId in memberIds) {
        DocumentSnapshot memberSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(memberId)
            .get();
        if (memberSnapshot['role'] == 'elder') {
          elders.add(memberSnapshot['username']);
        }
      }

      setState(() {
        _elderlyList = elders;
      });
    } catch (e) {
      print('Error fetching elders: $e');
    }
  }
  
  Future<void> _fetchMedicines() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String familyCode = userSnapshot['familyCode'];

      DocumentSnapshot familySnapshot = await FirebaseFirestore.instance
          .collection('family')
          .doc(familyCode)
          .get();

      List<String> memberIds = [];
      Map<String, dynamic>? familyData = familySnapshot.data() as Map<String, dynamic>?;

      if (familyData != null) {
        familyData.forEach((key, value) {
          if (key.startsWith('member') && value is String) {
            memberIds.add(value);
          }
        });
      }

      List<Medicine> allMedicines = [];

      for (String memberId in memberIds) {
        QuerySnapshot medicinesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(memberId)
            .collection('medicines')
            .get();

        for (var doc in medicinesSnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          List<dynamic> dosagesData = data['dosages'] ?? [];
          List<Dosage> dosages = dosagesData.map((d) => Dosage(
                time: TimeOfDay(hour: d['time']['hour'], minute: d['time']['minute']),
                quantity: d['quantity'],
              )).toList();

          allMedicines.add(Medicine(
            id: doc.id,
            name: data['name'],
            mealTime: data['mealTime'],
            dosages: dosages,
            note: data['note'],
            elderlyName: data['elderlyName'],
            frequency: List<String>.from(data['frequency'] ?? []),
          ));
        }
      }

      setState(() {
        _medicines = allMedicines;
      });
    } catch (e) {
      print('Error fetching medicines: $e');
    }
  }

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
          _dosages.add(Dosage(time: pickedTime, quantity: quantity));
        });
      }
    }
  }

  Future<void> _saveMedicine() async {
    if (_selectedElderly == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an elderly.')),
      );
      return;
    }

    try {
      final QuerySnapshot userIdQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: _selectedElderly)
          .get();

      if (userIdQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Elderly user not found')),
        );
        return;
      }

      final String elderUserId = userIdQuery.docs.first.id;

      final medicine = Medicine(
        id: _isEditing ? _editingMedicine!.id : DateTime.now().toString(),
        name: _medicineNameController.text,
        mealTime: _mealTime,
        frequency: List.from(_selectedFrequency),
        dosages: _dosages,
        note: _noteController.text,
        elderlyName: _selectedElderly,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(elderUserId)
          .collection('medicines')
          .doc(medicine.id)
          .set(medicine.toMap());

      setState(() {
        if (_isEditing) {
          final index = _medicines.indexWhere((m) => m.id == medicine.id);
          if (index != -1) {
            _medicines[index] = medicine;
          }
        } else {
          _medicines.add(medicine);
        }
        _resetForm();
        _isFormExpanded = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Medicine updated.' : 'Medicine added.')),
      );
    } catch (e) {
      print('Error saving medicine: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save medicine.')),
      );
    }

    _fetchMedicines();
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

  void _deleteMedicine(String id) async {
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
            onPressed: () async { 
              try {
                User? user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();
                String familyCode = userSnapshot['familyCode'];

                DocumentSnapshot familySnapshot = await FirebaseFirestore.instance
                    .collection('family')
                    .doc(familyCode)
                    .get();

                List<String> memberIds = [];
                Map<String, dynamic>? familyData = familySnapshot.data() as Map<String, dynamic>?;

                if (familyData != null) {
                  familyData.forEach((key, value) {
                    if (key.startsWith('member') && value is String) {
                      memberIds.add(value);
                    }
                  });
                }
                for (String memberId in memberIds) {
                  QuerySnapshot medicineSnapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(memberId)
                      .collection('medicines')
                      .where('id', isEqualTo: id)
                      .get();
                  if (medicineSnapshot.docs.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(memberId)
                        .collection('medicines')
                        .doc(id)
                        .delete();
                    break;
                  }
                }

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
              } catch (e) {
                print('Error deleting medicine: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete medicine')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((_) {
      _fetchMedicines();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine Management',
          style: TextStyle(fontWeight: FontWeight.bold,
          color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.titleGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _isFormExpanded ? min(MediaQuery.of(context).size.height * 0.6 - 40, 600) : 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.titleGreen.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            _isEditing ? 'Edit Medicine' : 'Add New Medicine',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.titleGreen,
                            ),
                          ),
                          trailing: _isEditing
                              ? IconButton(
                                  icon: const Icon(Icons.close, color: Colors.black),
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
                                    color: Colors.black,
                                  ),
                                  onPressed: _toggleFormExpansion,
                                ),
                        ),
                      ),
                      if (_isFormExpanded) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                value: _selectedElderly,
                                decoration: InputDecoration(
                                  labelText: 'Select Elderly',
                                  labelStyle: const TextStyle(color: Colors.black87),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                items: _elderlyList.map((elderly) {
                                  return DropdownMenuItem(
                                    value: elderly,
                                    child: Text(
                                      elderly,
                                      style: const TextStyle(color: Colors.black),
                                    ),
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
                                decoration: InputDecoration(
                                  labelText: 'Medicine Name',
                                  labelStyle: const TextStyle(color: Colors.black87),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: 'Enter medicine name',
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                              ),
                              const SizedBox(height: 20),

                              DropdownButtonFormField<String>(
                                value: _mealTime,
                                items: ['Before Meal', 'After Meal']
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: const TextStyle(color: Colors.black),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(() => _mealTime = value!),
                                decoration: InputDecoration(
                                  labelText: 'Meal Time',
                                  labelStyle: const TextStyle(color: Colors.black87),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                              ),
                              const SizedBox(height: 20),

                              _buildFrequencySelector(),

                              const Text(
                                'Time & Quantity',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (_dosages.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'No dosages added yet',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                              ..._dosages.map((dosage) => Card(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    color: Colors.grey[50],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
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
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Quantity: ${dosage.quantity} piece${dosage.quantity > 1 ? 's' : ''}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
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
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const Text(
                                  'Add Time & Quantity',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.titleGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                ),
                              ),
                              const SizedBox(height: 20),

                              const Text(
                                'Custom Note for Elderly',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _noteController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Write your note here...',
                                  labelStyle: const TextStyle(color: Colors.black87),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: 'Any special instructions...',
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                              ),
                              const SizedBox(height: 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: _saveMedicine,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.titleGreen,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      _isEditing ? 'Update Medicine' : 'Add Medicine',
                                      style: const TextStyle(color: Colors.white),
                                    ),
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
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.titleGreen.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
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
                                  color: AppColors.titleGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _medicines.isEmpty
                          ? Center(
                              child: Text(
                                'No medicines added yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
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
                                  elevation: 2,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      medicine.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          'For: ${medicine.elderlyName ?? "Not specified"}',
                                          style: TextStyle(color: Colors.grey[800]),
                                        ),
                                        Text(
                                          'Meal: ${medicine.mealTime}',
                                          style: TextStyle(color: Colors.grey[800]),
                                        ),
                                        if (medicine.frequency.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Frequency: ${medicine.frequency.join(', ')}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                        if (medicine.dosages.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: medicine.dosages.map((dosage) => Text(
                                                '${dosage.time.format(context)} - ${dosage.quantity} piece${dosage.quantity > 1 ? 's' : ''}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[800],
                                                ),
                                              )).toList(),
                                            ),
                                          ),
                                        if (medicine.note.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Note: ${medicine.note}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey[800],
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencySelector() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What day should this medication be consumed?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
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
                  border: Border.all(
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  day,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
  void dispose() {
    _medicineNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}