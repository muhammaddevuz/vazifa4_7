import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vazifa/controllers/quiz_controller.dart';
import 'package:vazifa/models/quiz.dart';
import 'package:vazifa/views/screens/final_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final questionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final correctIndexController = TextEditingController();
  PageController pageController = PageController();
  int correct = 0;

  @override
  void dispose() {
    questionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    correctIndexController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = context.watch<QuizController>();
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text("Quiz"),
      ),
      body: StreamBuilder(
        stream: quizController.getQuizes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text("quizlar topilmadi"),
            );
          }

          final quizes = snapshot.data!.docs;

          return quizes.isEmpty
              ? const Center(
                  child: Text("quizlar yo'q"),
                )
              : PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Orqaga qaytarilmasin
                  itemCount: quizes.length,
                  itemBuilder: (context, index) {
                    final quiz = Quiz.fromJson(quizes[index]);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onLongPress: () {
                            questionController.text = quiz.question;
                            option1Controller.text = quiz.options[0];
                            option2Controller.text = quiz.options[1];
                            option3Controller.text = quiz.options[2];
                            correctIndexController.text =
                                quiz.correctIndex.toString();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Edit quiz"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: questionController,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Enter question"),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller: option1Controller,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Enter 1 st option"),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller: option2Controller,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Enter 2 nd option"),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller: option3Controller,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Enter 3 rd option"),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller: correctIndexController,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText:
                                                    "Enter correct index"),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              quizController.editQuiz(
                                                  quiz.id,
                                                  questionController.text,
                                                  option1Controller.text,
                                                  option2Controller.text,
                                                  option3Controller.text,
                                                  int.parse(
                                                      correctIndexController
                                                          .text));
                                              Navigator.pop(context);
                                              questionController.clear();
                                              option1Controller.clear();
                                              option2Controller.clear();
                                              option3Controller.clear();
                                              correctIndexController.clear();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text("Edit"),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            quiz.question,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (var i = 0; i < quiz.options.length; i++)
                              ElevatedButton(
                                  onPressed: () {
                                    if (i == quiz.correctIndex.toInt()) {
                                      correct += 1;
                                    }
                                    if (index != quizes.length - 1) {
                                      pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FinalScreen(
                                                correctAnsver: correct),
                                          ));
                                    }
                                  },
                                  child: Text(
                                    quiz.options[i],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  )),
                          ],
                        )
                      ],
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 139, 104, 200),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Quiz"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: questionController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter question"),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: option1Controller,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter 1 st option"),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: option2Controller,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter 2 nd option"),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: option3Controller,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter 3 rd option"),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: correctIndexController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter correct index"),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          quizController.addQuiz(
                              questionController.text,
                              option1Controller.text,
                              option2Controller.text,
                              option3Controller.text,
                              int.parse(correctIndexController.text));
                          Navigator.pop(context);
                          questionController.clear();
                          option1Controller.clear();
                          option2Controller.clear();
                          option3Controller.clear();
                          correctIndexController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:  const Text("Add"),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
