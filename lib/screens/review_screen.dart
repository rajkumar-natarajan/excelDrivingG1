import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../l10n/app_strings.dart';
import '../models/question.dart';

class ReviewScreen extends StatefulWidget {
  final TestResult result;
  final List<Question> questions;

  const ReviewScreen({super.key, required this.result, required this.questions});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _showOnlyIncorrect = false;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(SettingsController().language);
    final filtered = _showOnlyIncorrect
        ? widget.result.answers.where((a) => !a.isCorrect).toList()
        : widget.result.answers;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.reviewAnswers),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(s.incorrectOnly),
              selected: _showOnlyIncorrect,
              onSelected: (v) => setState(() => _showOnlyIncorrect = v),
              selectedColor: Colors.red.withAlpha(40),
            ),
          ),
        ],
      ),
      body: filtered.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 64),
                  const SizedBox(height: 16),
                  Text(s.allAnswersCorrect, style: const TextStyle(fontSize: 18)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final answer = filtered.elementAt(index);
                final question = widget.questions.firstWhere(
                  (q) => q.id == answer.questionId,
                  orElse: () => widget.questions.first,
                );
                return _buildReviewCard(context, question, answer, index + 1, s);
              },
            ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Question question, UserAnswer answer, int questionNumber, AppStrings s) {
    final isCorrect = answer.isCorrect;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green.withAlpha(30) : Colors.red.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        size: 14,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Q$questionNumber',
                        style: TextStyle(
                          fontSize: 12,
                          color: isCorrect ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withAlpha(60),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    s.questionTypeName(question.type),
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question.stem,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 12),
            ...List.generate(question.options.length, (i) {
              final isUserAnswer = answer.selectedOption == i;
              final isCorrectAnswer = question.correctAnswer == i;
              Color bgColor = Colors.transparent;
              Color borderColor = Theme.of(context).colorScheme.outlineVariant;

              if (isCorrectAnswer) {
                bgColor = Colors.green.withAlpha(25);
                borderColor = Colors.green;
              } else if (isUserAnswer && !isCorrect) {
                bgColor = Colors.red.withAlpha(25);
                borderColor = Colors.red;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + i)}.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCorrectAnswer
                              ? Colors.green
                              : isUserAnswer && !isCorrect
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          question.options[i],
                          style: TextStyle(
                            fontSize: 13,
                            color: isCorrectAnswer
                                ? Colors.green
                                : isUserAnswer && !isCorrect
                                    ? Colors.red
                                    : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (isCorrectAnswer) const Icon(Icons.check, color: Colors.green, size: 16),
                      if (isUserAnswer && !isCorrect) const Icon(Icons.close, color: Colors.red, size: 16),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withAlpha(60),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question.explanation,
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
