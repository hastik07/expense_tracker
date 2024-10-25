import 'dart:async';
import 'package:expense_tracker/api/gsheets_api.dart';
import 'package:expense_tracker/loadingcircle.dart';
import 'package:expense_tracker/plusbutton.dart';
import 'package:expense_tracker/topneucard.dart';
import 'package:expense_tracker/transaction.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final textControllerAmount = TextEditingController();
  final textControllerITEM = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isIncome = false;
  bool timerHasStarted = false;

  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (GoogleSheetApi.loading == false) {
          setState(() {});
          timer.cancel();
        }
      },
    );
  }

  void enterTransaction() {
    GoogleSheetApi.insert(
      textControllerITEM.text,
      textControllerAmount.text,
      isIncome,
    );
    setState(() {});
  }

  void newTransaction() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('N E W T R A N S A C T I O N'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Expense'),
                        Switch(
                          value: isIncome,
                          onChanged: (newValue) {
                            setState(() {
                              isIncome = newValue;
                            });
                          },
                        ),
                        const Text('Income'),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?'),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Enter an amount';
                                }
                                return null;
                              },
                              controller: textControllerAmount,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For What?'),
                            controller: textControllerITEM,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.grey[600],
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      enterTransaction();
                      Navigator.of(context).pop();
                    }
                  },
                  color: Colors.grey[600],
                  child: const Text(
                    'Enter',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetApi.loading == true && timerHasStarted == false) {
      startLoading();
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            TopNeuCard(
              balance: (GoogleSheetApi.calculateIncome() -
                      GoogleSheetApi.calculateExpense())
                  .toString(),
              income: GoogleSheetApi.calculateIncome().toString(),
              expense: GoogleSheetApi.calculateExpense().toString(),
            ),
            Expanded(
              child: GoogleSheetApi.loading == true
                  ? const LoadingCircle()
                  : ListView.builder(
                      itemCount: GoogleSheetApi.currentTransactions.length,
                      itemBuilder: (context, index) {
                        return Transaction(
                          transactionName:
                              GoogleSheetApi.currentTransactions[index][0],
                          money: GoogleSheetApi.currentTransactions[index][1],
                          expenseOrIncome:
                              GoogleSheetApi.currentTransactions[index][2],
                        );
                      },
                    ),
            ),
            PlusButton(
              function: newTransaction,
            ),
          ],
        ),
      ),
    );
  }
}
