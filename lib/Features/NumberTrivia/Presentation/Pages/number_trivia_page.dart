import 'package:clean_architecture/Features/NumberTrivia/Presentation/Widgets/trivia_controll.dart';
import 'package:clean_architecture/Features/NumberTrivia/Presentation/getx/number_trivia_getx.dart';
import 'package:get/get.dart';

import '../Widgets/message_display.dart';
import 'package:flutter/material.dart';

import '../Widgets/loading_widget.dart';
import '../Widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: const SingleChildScrollView(child: Body()),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberTriviaGetx controller = Get.find();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Obx(
              () {
                if (controller.state == NumberTriviaStates.Error) {
                  return MessageDisplay(
                    message: controller.message,
                  );
                } else if (controller.state == NumberTriviaStates.Loading) {
                  return const LoadingWidget();
                } else if (controller.state == NumberTriviaStates.Loaded) {
                  return TriviaDisplay(
                      message: controller.trivia.text,
                      number: controller.trivia.number);
                }
                return const MessageDisplay(
                  message: 'Start Searching!',
                );
              },
            ),
            const SizedBox(height: 20),
            const TriviaControll()
          ],
        ),
      ),
    );
  }
}
