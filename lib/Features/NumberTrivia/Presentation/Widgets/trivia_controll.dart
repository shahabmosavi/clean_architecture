import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../getx/number_trivia_getx.dart';

class TriviaControll extends StatefulWidget {
  const TriviaControll({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControll> createState() => _TriviaControllState();
}

class _TriviaControllState extends State<TriviaControll> {
  late TextEditingController controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onEditingComplete: getConcrete,
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (String value) {
            inputStr = value;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: getConcrete,
                child: const Text('Search'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: addRandom,
                child: const Text('Get random trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void getConcrete() {
    controller.clear();

    Get.find<NumberTriviaGetx>().getTriviaForConcreteNumber(inputStr);
  }

  void addRandom() {
    controller.clear();

    Get.find<NumberTriviaGetx>().getTriviaForRandomNumber();
  }
}
