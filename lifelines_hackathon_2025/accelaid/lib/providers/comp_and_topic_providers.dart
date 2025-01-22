import 'package:accelaid/providers/repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/competency.dart';
import '../models/topic.dart';

final competenciesByGradeProvider =
FutureProvider.family<List<Competency>, String>((ref, grade) async {
  final compRepoAsync = await ref.watch(compRepoProvider.future);
  return await compRepoAsync.getCompetenciesByGrade(grade);
});

final compByIdProvider =
FutureProvider.family<String, String>((ref, compId) async {
  final compRepoAsync = await ref.watch(compRepoProvider.future);
  return await compRepoAsync.getCompById(compId);
});

final topicsByCompetencyProvider =
FutureProvider.family<List<Topic>, String>((ref, compId) async {
  final topicRepoAsync = await ref.watch(topicRepoProvider.future);
  return await topicRepoAsync.getTopicsByCompetency(compId);
});

final competencyByIdProvider =
FutureProvider.family<Competency, String>((ref, compId) async {
  final compRepoAsync = await ref.watch(compRepoProvider.future);
  return await compRepoAsync.getCompetencyById(compId);
});