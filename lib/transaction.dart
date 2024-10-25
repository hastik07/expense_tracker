import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;

  const Transaction({
    super.key,
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.grey[200],
                  height: 60,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.attach_money_outlined,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              transactionName,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${expenseOrIncome == 'expense' ? '-' : '+'}\$$money',
                          style: TextStyle(
                              color: expenseOrIncome == 'expense'
                                  ? Colors.red
                                  : Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
