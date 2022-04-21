import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  const TriviaDisplay({Key? key, required this.message, required this.number})
      : super(key: key);
  final String message;
  final int number;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            number.toString(),
            style: const TextStyle(fontSize: 50),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                  child: Text(
                message,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
