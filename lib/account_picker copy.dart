import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importera för inputFormatters

class Account {
  final String number;
  final String name;

  Account({required this.number, required this.name});
}

class AccountPickerWidget extends StatefulWidget {
  const AccountPickerWidget({super.key});

  @override
  _AccountPickerWidgetState createState() => _AccountPickerWidgetState();
}

class _AccountPickerWidgetState extends State<AccountPickerWidget> {
  final TextEditingController _controller = TextEditingController();
  List<Account> suggestions = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateSuggestions);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateSuggestions);
    _controller.dispose();
    super.dispose();
  }

  /* void _updateSuggestions() {
    String input = _controller.text;
    if (input.isEmpty) {
      setState(() {
        suggestions = [];
      });
      return;
    }

    List<Account> filteredSuggestions = getAccountSuggestions(input);
    setState(() {
      suggestions = filteredSuggestions;
    });
  } */
  void _updateSuggestions() {
    String input = _controller.text;
    if (input.isEmpty) {
      setState(() {
        suggestions = [];
      });
      return;
    }

    List<Account> filteredSuggestions = getAccountSuggestions(input);
    setState(() {
      suggestions = filteredSuggestions;
    });

    // Ny logik: Om användaren har fyllt i fyra siffror och det finns ett exakt matchande konto
    if (input.length == 4 && filteredSuggestions.length == 1) {
      _selectAccount(filteredSuggestions.first);
    }
  }

  void _selectAccount(Account account) {
    setState(() {
      _controller.text =
          account.number; // Uppdatera TextField med det valda kontonumret
      suggestions = []; // Rensa förslagslistan
    });
    // Implementera eventuell ytterligare logik som behövs när ett konto väljs, som att stänga tangentbordet
    FocusScope.of(context)
        .requestFocus(FocusNode()); // Ta bort fokus från TextField
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width:
              100, // Justera bredden för att matcha visuell storlek för 4 siffror
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
          ),
        ),
        SizedBox(height: 10),
        if (suggestions.isNotEmpty)
          Container(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${suggestions[index].name} (${suggestions[index].number})'),
                  onTap: () {
                    _controller.text = suggestions[index].number;
                    setState(() {
                      suggestions = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

List<Account> getAccountSuggestions(String input) {
  List<Account> allAccounts = [
    Account(number: '1234', name: 'Konto A'),
    Account(number: '1567', name: 'Konto B'),
    Account(number: '1289', name: 'Konto C'),
  ];
  return allAccounts
      .where((account) => account.number.startsWith(input))
      .toList();
}
