import 'package:gsheets/gsheets.dart';

class GoogleSheetApi {
  static const credentials = r'''
  {
  "type": "service_account",
  "project_id": "expense-tracker-439411",
  "private_key_id": "49ed0b34291f7eed8e5a2897e04aeece00f6dfc6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCd+fx/0jKJJSL/\nhqZOyS1ixWbx2RVXqwdxcn/necJR217a+Qz8VH2br7UFuV3p/YNqjewLem7m+s/b\nAX10csDYuGVX32L8CL8mJMbVL1Q2G2jpPftIU5k/RelBEJEge5uPTSAC2r7fn4nU\ndT6BhXHgILqkw6D+1jExLpYt/3GDFCOCX1ua7pgWSy1T12ocHnOUO5u/7Cr1IsAT\nibL6c496Bkoo+AAigLKSOYHcj1E9aMZO6ucL0xIWhuSiRbnnoBPlB9nCVBCG3nbg\nPHQCJMQ6tlF2Rqd3UeVUIkIECFK5Xr/IcWhYh2Qaz0j0x+sBiMUXJ77hWET0GRJ/\nNIme1oAzAgMBAAECggEASepVwljPXGwL3BNcbTCkE7rZV/+ChOp5KROx1NSbn0FN\nOJefA9FklBu6T1tUHc+IVarh7tzyVxCzgH1J/dpTcROWF29mGRbemTJL9iOW+1oH\n1Foz4Lt80KYdZVwjC1fKiVpEyBEhjfBPxSC2hlOx3HRz3/PIuHPvwFtT2WHT8sgV\nRLUx72W+E6Ymq3vYmi/qLOD0y0mUKohGt0s4jsPKjcX9uFr7pLpF+K5RFKAAJ+5A\niz88bRFQ5+rx5w7XLYvZTSiQ30ILEH6APUIgDPBQrGD15TLe9FK1qoV0d0s4Vf43\n4Jw/ouMuOP1jKBdml6xcIXw+fWnHXr+N5m2AIZFEwQKBgQDJc3FczpkKQlWxroJq\nkHv/xqg9McaLwV98q57xAhUU+Q64I7vbyqIZoIc1vcF9Lhi1JTzEY7dFsXrhmfQS\nxuiJflmHKYh5zuJ7iuGgSFQU3Ol6MIhX/672fuR+veTlTJnRs200E0mxtIIC33Dq\ncDd/JrKbjM6FWrCs4yeC5uGw1wKBgQDIwOZ1pKohFbXQdBaEVlVGev/Aw/30QZ4e\nV4mmCTrvozmYT/cdu81pCDwzYlFtrHqskSMmwvn0H58hq/HCaFsMXOoMRSbefrvK\nvzHXaDJZgQ0BbmlBDDoO+zfCohvRECVSzw30Bvh+q6o1aEUMEB/AUEu6ucl9zuoP\nq3NbrmTUBQKBgQDIEIxe/RbkJ2jvoz4GEyPyqxpeW9aw6QSpzc91zvmc8JP7sBFb\ngOxnwxNE/gTxCxyimi61Y8qZvl8pOjo5g61hD0hegZL2Vc57nzvgcLSAW7zMCvL9\nYgIi73aBoJl4WBDTP/yOITGo+Hm93KZJTdTvxEDRVo+rxJt9t8J/sEgn1QKBgGBb\nNkKBJqd6pCnJjoU2avfJUbhUWjBCzoIBwi/PflpHHf3dY98BpTYkncCMEElz3+20\nPAr+yrpB8z9WKFQHgqwMbMo25tEkQz6tRl79xCzxpCxrsllmZPeL3Neut2tBNKjq\neOgH8H3cJ3Y69ek0VAkagT6+rdeU2QNsZ5I5wmuBAoGAJueX4XSRgGzMYdr7uD3v\nmaYOQEdFpPevJri7d+LgmP3tac0RRPIJZrlVdEN7o4K38qTtV+r1CEg4zq/i0B9g\nLBfeD9qTip+3fuE22yeAoeDAFVTmsFoJIoHOxbWpgD3Sfw4hcdrlWU7R1TJv7XfL\ny9V+8ydTxo+Lqctw19/UL48=\n-----END PRIVATE KEY-----\n",
  "client_email": "expense-tracker@expense-tracker-439411.iam.gserviceaccount.com",
  "client_id": "102303651608667710424",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense-tracker%40expense-tracker-439411.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
  }
  ''';

  static const spredsheetId = '1BckgDUrfGJBp-QcxFHj3RV1JlzCukdeh7t9yjTLxIOY';
  static final gsheets = GSheets(credentials);
  static Worksheet? worksheet;

  static int numberOfTransaction = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async {
    final ss = await gsheets.spreadsheet(spredsheetId);
    worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  static Future countRows() async {
    while ((await worksheet!.values
            .value(column: 1, row: numberOfTransaction + 1)) !=
        '') {
      numberOfTransaction++;
    }
    loadTransaction();
  }

  static Future loadTransaction() async {
    if (worksheet == null) return;
    for (int i = 1; i < numberOfTransaction; i++) {
      final String transactionName = await worksheet!.values.value(
        column: 1,
        row: i + 1,
      );
      final String transactionAmount = await worksheet!.values.value(
        column: 2,
        row: i + 1,
      );
      final String transactionType = await worksheet!.values.value(
        column: 3,
        row: i + 1,
      );
      if (currentTransactions.length < numberOfTransaction) {
        currentTransactions.add(
          [
            transactionName,
            transactionAmount,
            transactionType,
          ],
        );
      }
    }
    loading = false;
  }

  static Future insert(String name, String amount, bool isIncome) async {
    if (worksheet == null) return;
    numberOfTransaction++;
    currentTransactions.add([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
    await worksheet!.values.appendRow([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
  }

  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome = double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense = double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
