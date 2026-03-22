// lib/models/subject_model.dart - Fixed version
class Subject {
  final String id;
  final String name;
  final String icon;
  final double progress;
  final int pyqFrequency;
  final List<Blindspot> blindspots;

  Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.progress,
    required this.pyqFrequency,
    required this.blindspots,
  });

  static List<Subject> mockList() {
    return [
      Subject(
        id: '1',
        name: 'Physics',
        icon: '⚛️',
        progress: 0.45,
        pyqFrequency: 8,
        blindspots: [
          Blindspot(topic: 'Thermodynamics', probability: 0.85, pyqCount: 12),
          Blindspot(topic: 'Electrostatics', probability: 0.92, pyqCount: 15),
          Blindspot(topic: 'Optics', probability: 0.78, pyqCount: 8),
        ],
      ),
      Subject(
        id: '2',
        name: 'Mathematics',
        icon: '📐',
        progress: 0.62,
        pyqFrequency: 7,
        blindspots: [],
      ),
      Subject(
        id: '3',
        name: 'Chemistry',
        icon: '🧪',
        progress: 0.38,
        pyqFrequency: 9,
        blindspots: [
          Blindspot(topic: 'Organic Reactions', probability: 0.88, pyqCount: 10),
        ],
      ),
    ];
  }
}

class Blindspot {
  final String topic;
  final double probability;
  final int pyqCount;
  Blindspot({required this.topic, required this.probability, required this.pyqCount});
}

class StudyStreak {
  final int currentStreak;
  final int totalStudyDays;
  final int weeklyGoal;
  final int weeklyAchieved;
  StudyStreak({
    required this.currentStreak,
    required this.totalStudyDays,
    required this.weeklyGoal,
    required this.weeklyAchieved,
  });
  factory StudyStreak.mock() => StudyStreak(
    currentStreak: 12,
    totalStudyDays: 45,
    weeklyGoal: 7,
    weeklyAchieved: 5,
  );
}