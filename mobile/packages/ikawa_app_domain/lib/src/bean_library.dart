class GreenBean {
  const GreenBean({
    required this.id,
    required this.name,
    required this.densityGPerMl,
    required this.moisturePercent,
    required this.beanSizeScreen,
  });

  final String id;
  final String name;
  final double densityGPerMl;
  final double moisturePercent;
  final int beanSizeScreen;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'densityGPerMl': densityGPerMl,
        'moisturePercent': moisturePercent,
        'beanSizeScreen': beanSizeScreen,
      };

  static GreenBean fromJson(Map<String, dynamic> json) => GreenBean(
        id: json['id'] as String,
        name: json['name'] as String,
        densityGPerMl: (json['densityGPerMl'] as num).toDouble(),
        moisturePercent: (json['moisturePercent'] as num).toDouble(),
        beanSizeScreen: (json['beanSizeScreen'] as num).toInt(),
      );
}
