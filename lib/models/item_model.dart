class ItemModel {
  final String title;
  final String subtitle;
  final String description;

  ItemModel(
      {required this.title, required this.subtitle, required this.description});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
    );
  }
}
