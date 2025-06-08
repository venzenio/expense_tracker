import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('expenses');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: ExpenseTracker(),
    );
  }
}

class ExpenseTracker extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  final _box = Hive.box('expenses');

  void _addExpense() {
    final amount = double.tryParse(_amountController.text);
    final desc = _descController.text;

    if (amount != null && desc.isNotEmpty) {
      _box.add({'amount': amount, 'description': desc, 'date': DateTime.now().toString()});
      _amountController.clear();
      _descController.clear();
      setState(() {});
    }
  }

  void _deleteExpense(int index) {
    _box.deleteAt(index);
    setState(() {});
  }

  Map<String, double> _getCategorySummary() {
    final expenses = _box.values.toList();
    final Map<String, double> summary = {};
    for (var item in expenses) {
      final category = item['description'];
      final amount = item['amount'];
      if (summary.containsKey(category)) {
        summary[category] = summary[category]! + amount;
      } else {
        summary[category] = amount;
      }
    }
    return summary;
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final data = _getCategorySummary();
    return data.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        color: Colors.primaries[data.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        radius: 50,
        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  void _showSummaryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Expense Summary'),
        content: Container(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: _buildPieChartSections(),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.pie_chart),
            onPressed: _showSummaryDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: _addExpense, child: Text('Add Expense')),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _box.listenable(),
              builder: (context, Box box, _) {
                if (box.isEmpty) {
                  return Center(child: Text('No expenses yet.'));
                } else {
                  final expenses = box.values.toList();
                  return ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final item = expenses[index];
                      return ListTile(
                        title: Text('₹${item['amount']}'),
                        subtitle: Text(item['description']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteExpense(index),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
