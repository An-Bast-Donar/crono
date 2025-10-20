class Project {
  final String id;
  final String name;
  final Duration estimatedTime;
  final Duration elapsedTime;

  Project({
    required this.id,
    required this.name,
    required this.estimatedTime,
    this.elapsedTime = Duration.zero,
  });

  Project copyWith({
    String? id,
    String? name,
    Duration? estimatedTime,
    Duration? elapsedTime,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      elapsedTime: elapsedTime ?? this.elapsedTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'estimatedTime': estimatedTime.inSeconds,
      'elapsedTime': elapsedTime.inSeconds,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      estimatedTime: Duration(seconds: json['estimatedTime'] as int),
      elapsedTime: Duration(seconds: json['elapsedTime'] as int? ?? 0),
    );
  }
}
