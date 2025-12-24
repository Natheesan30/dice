import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home:  AddExpenseForm());
  }
}

class ExpenseHome extends StatelessWidget {
  const ExpenseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker'),),
      body: const Column(children: [
                  ExpenseCard(title: "Groceries", date: "Dec 22, 2025", amount: 250.0),
                  ExpenseCard(title: "Rent", date: "Dec 1, 2025", amount: 1200.0), 
                  ExpenseCard(title: "Utilities", date: "Dec 15, 2025", amount: 150.0)],) 
    );
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
      child: Padding(padding: EdgeInsets.all(10), child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                         Text(date, style: TextStyle(fontSize: 16, color: Colors.grey[600]))],),
            Container(
              child: Text("\$${amount.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade400),),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade400), borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            ),
         ],
      ),
    )
         );
  }
}

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({super.key});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> { // This is the state class

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void showDate() async {
    final pickedDate = await showDatePicker(
      context: context,           // This context already define in the state class
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),  
      lastDate: DateTime.now(),
    );
    if(pickedDate != null) {
      _selectedDate = pickedDate;
  }
  }

  void submitForm(){
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);

    print("Title: $title, Amount: $amount, Date: $_selectedDate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: showDate,  // Connect the function here
              child: Text( "Select Date"),
            ),
            ElevatedButton(onPressed: () => submitForm(), child: Text("Add Expense"))
          ],
        ),
      ),
    );
  }
}