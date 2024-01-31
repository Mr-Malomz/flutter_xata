class Project {
  String? id;
  String name;
  String description;
  String status;

  Project({
    this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "status": status,
    };
  }

  factory Project.fromJson(Map<dynamic, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }
}
