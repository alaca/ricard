class ListPlayItem {
  final String itemId;
  final String title;
  final String subtitle;
  final String sound;

  ListPlayItem({
    required this.itemId,
    required this.title,
    required this.subtitle,
    required this.sound
  });

  ListPlayItem.fromMap(Map<String, dynamic> map)
    : itemId = map['itemId'],
      title = map['title'],
      subtitle = map['subtitle'],
      sound = map['sound'];
}