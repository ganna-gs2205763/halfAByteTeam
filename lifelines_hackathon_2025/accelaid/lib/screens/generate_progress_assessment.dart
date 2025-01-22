import 'package:accelaid/consts.dart';
import 'package:accelaid/models/color_const.dart';
import 'package:accelaid/models/competency_progress.dart';
import 'package:accelaid/models/student.dart';
import 'package:accelaid/providers/comp_and_topic_providers.dart';
import 'package:accelaid/providers/comp_progress_provider.dart';
import 'package:accelaid/providers/student_provider.dart';
import 'package:accelaid/routes/app_router.dart';
import 'package:accelaid/screens/widgets/discard_changes_dialog.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GenerateProgressAssessmentScreen extends ConsumerStatefulWidget {
  final String stId;

  const GenerateProgressAssessmentScreen({super.key, required this.stId});

  @override
  ConsumerState<GenerateProgressAssessmentScreen> createState() =>
      _GenerateProgressAssessmentScreenState();
}

class _GenerateProgressAssessmentScreenState
    extends ConsumerState<GenerateProgressAssessmentScreen> {
  final competencyIdsSelected = [];
  final finalList = [];

  @override
  Widget build(BuildContext context) {
    Student? student =
        ref.read(studentNotifierProvider.notifier).getStudentById(widget.stId);
    final progressProvider = ref.watch(compProgressNotifierProvider);
    final progressNotifier = ref.read(compProgressNotifierProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const DiscardChangesDialog(),
              );
            },
            icon: const Icon(CupertinoIcons.back),
          ),
          title: Text(
            "Generate Progress Assessment",
            style: TextStyle(
              fontSize: 22,
              color: darkblue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<List<CompetencyProgress>>(
            future: progressNotifier.fetchCompProgressByStudent(widget.stId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No progress data."));
              } else {
                final progressList = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "COMPETENCIES FROM STUDENT'S PLAN",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: darkblue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: progressList.length,
                        itemBuilder: (context, index) {
                          final progress = progressList[index];
                          final topicsOfComp = ref.watch(
                            topicsByCompetencyProvider(progress.compId),
                          );

                          ValueNotifier<bool> isExpanded = ValueNotifier(false);

                          return ValueListenableBuilder<bool>(
                            valueListenable: isExpanded,
                            builder: (context, expanded, child) {
                              return ExpansionTile(
                                initiallyExpanded: true,
                                leading: Icon(
                                  expanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                                trailing: Checkbox(
                                  value: competencyIdsSelected
                                      .contains(progress.compId),
                                  onChanged: (isSelected) {
                                    print(
                                        "Clicked. Exists: ${competencyIdsSelected.contains(progress.compId)}");

                                    setState(() {
                                      if (isSelected ?? false) {
                                        competencyIdsSelected
                                            .add(progress.compId);
                                      } else {
                                        competencyIdsSelected
                                            .remove(progress.compId);
                                      }
                                    });
                                    print(competencyIdsSelected);
                                  },
                                  activeColor: Colors.grey,
                                  side: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Consumer(
                                        builder: (context, ref, child) {
                                          final compByIdAsync = ref.watch(
                                              compByIdProvider(
                                                  progress.compId));

                                          return compByIdAsync.when(
                                            data: (competencyName) => Text(
                                              "${progress.compId.substring(2)} - $competencyName",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            loading: () =>
                                                const CircularProgressIndicator(),
                                            error: (error, stackTrace) => Text(
                                              "Error: $error",
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                onExpansionChanged: (expandedState) {
                                  isExpanded.value = expandedState;
                                },
                                children: [
                                  topicsOfComp.when(
                                    data: (topics) {
                                      if (topics.isEmpty) {
                                        return const ListTile(
                                          title: Text("No topics available."),
                                        );
                                      }
                                      return Column(
                                        children: topics.map((topic) {
                                          return ListTile(
                                            title: Text(
                                              "${topic.topicId.substring(2)} - ${topic.topic}",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                    loading: () => const ListTile(
                                      title: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    error: (error, stackTrace) => ListTile(
                                      title: Text('Error: $error'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        finalList.clear();
                        for (String c in competencyIdsSelected) {
                          final competencyAsync =
                              await ref.read(competencyByIdProvider(c).future);
                          finalList.add(competencyAsync);
                        }
                        generateExamInParts(finalList, student!.gradeLevel);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: darkblue,
                          elevation: 3,
                          fixedSize: const Size(340, 80),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text(
                        "Generate Progress Assessment",
                        style: TextStyle(
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ));
  }

  final openAI = OpenAI.instance.build(
    token: OPENAI_API_K,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 50)),
    enableLog: true,
  );

  Future<void> generateExamInParts(
      List<dynamic> competencies, String grade) async {
    List<String> fullExam = [];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      for (var competency in competencies) {
        final topicsProvider =
            ref.read(topicsByCompetencyProvider(competency.compId));
        final topics = topicsProvider.maybeWhen(
          data: (topics) => topics.map((t) => t.topic).toList(),
          orElse: () => [],
        );

        String prompt =
            "Generate a total of ${(topics.length) * 2} multiple-choice questions for the competency "
            "'${competency.competency}' for students in grade ${int.parse(grade) - 1}. "
            "Each question should have exactly 3 options (A, B, and C), only 1 being correct. "
            "Do not make any text bold. Do not tell me the correct answer."
            "Create 2 questions for each of these topics: ${topics.join(', ')}.";

        /// generating the request !
        final request = ChatCompleteText(
          messages: [
            {"role": "user", "content": prompt},
          ],
          model: ChatModelFromValue(
              model: 'gpt-4o-mini-2024-07-18'), // works best so far
          maxToken: 1000, // don't think any of the ones i've tested exceed that
          temperature: 0.2,
        );

        /// getting the response from api
        final response = await openAI.onChatCompletion(request: request);
        final strResponse =
            response?.choices.first.message?.content ?? "No response";

        final formattedResponse = strResponse.split('\n').map((line) {
          if (line.contains(r'\(') || line.contains(r'\)')) {
            return Math.tex(
              line.replaceAll(r'\(', '').replaceAll(r'\)', ''),
              textStyle: const TextStyle(fontSize: 16),
            ).toString();
          }
          return line;
        }).join('\n');
        fullExam.add("--> ${competency.competency}\n\n$formattedResponse");
      }

      final completeExam = fullExam.join("\n\n\n");

      Navigator.pop(context);
      context.pushNamed(
        AppRouter.generatedProgressAssessment.name,
        pathParameters: {'response': completeExam},
      );
    } catch (error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }
}
