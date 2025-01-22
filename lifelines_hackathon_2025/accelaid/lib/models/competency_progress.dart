class CompetencyProgress {
  final String stId;
  final String compId;
  late bool done;

  CompetencyProgress({
    required this.stId,
    required this.compId,
    required this.done,
  });

  factory CompetencyProgress.fromMap(Map<String, dynamic> map) {
    return CompetencyProgress(
      stId: map['stId'],
      compId: map['compId'],
      done: map['done'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stId': stId,
      'compId':compId,
      'done': done,
    };
  }
}
