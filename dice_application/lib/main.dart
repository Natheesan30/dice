import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AddExpenseForm());
  }
}

class ExpenseHome extends StatelessWidget {
  const ExpenseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
        ),
        body: const Column(
          children: [
            ExpenseCard(
                title: "Groceries", date: "Dec 22, 2025", amount: 250.0),
            ExpenseCard(title: "Rent", date: "Dec 1, 2025", amount: 1200.0),
            ExpenseCard(title: "Utilities", date: "Dec 15, 2025", amount: 150.0)
          ],
        ));
  }
}

class ExpenseCard extends StatelessWidget {
  final String title;
  final String date;
  final double amount;

  const ExpenseCard({
    required this.title,
    required this.date,
    required this.amount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(20),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(date,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]))
                ],
              ),
              Container(
                child: Text(
                  "\$${amount.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade400),
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade400),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              ),
            ],
          ),
        ));
  }
}

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({super.key});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  // This is the state class

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

  void showDate() async {
    final pickedDate = await showDatePicker(
      context: context, // This context already define in the state class
      initialDate: _selectedDate == null ? DateTime.now() : _selectedDate!,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void submitForm() {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      return;
    }
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);

    print("Title: $title, Amount: $amount, Date: $_selectedDate");
  }

  void resetForm(){
    _titleController.clear();
    _amountController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a title'
                  : null,
            ),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            Text(_selectedDate == null
                ? "No Date Chosen!"
                : "Picked Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}"),
            const SizedBox(height: 20),
            TextButton(
              onPressed: showDate, // Connect the function here
              child: Text("Select Date"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => submitForm(),
                  child: Text("Add Expense"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade500,
                      foregroundColor: Colors.white),
                ),
                SizedBox(width: 25),
                ElevatedButton(
                  onPressed: () => resetForm(),
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade500,
                      foregroundColor: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
