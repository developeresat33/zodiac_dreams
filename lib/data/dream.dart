


/* import 'package:mongo_dart/mongo_dart.dart'; */


class Dream {
/*   ObjectId id; */
  String dreamTitle;
  List<Subtitle> subtitles;

  Dream({
/*     required this.id, */
    required this.dreamTitle,
    required this.subtitles,
  });

  factory Dream.fromJson(Map<String, dynamic> json) {
    return Dream(
/*       id: json['_id'] as ObjectId, */
      dreamTitle: json['dream_title'] as String,
      subtitles: (json['subtitles'] as List<dynamic>)
          .map((e) => Subtitle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
/*       '_id': id, */
      'dream_title': dreamTitle,
      'subtitles': subtitles.map((e) => e.toJson()).toList(),
    };
  }
}

class Subtitle {
  String subtitle;
  List<String> description;

  Subtitle({
    required this.subtitle,
    required this.description,
  });

  factory Subtitle.fromJson(Map<String, dynamic> json) {
    return Subtitle(
      subtitle: json['subtitle'] as String,
      description: List<String>.from(json['description'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtitle': subtitle,
      'description': description,
    };
  }
}
