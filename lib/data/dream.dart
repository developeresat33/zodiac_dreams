class Subtitle {
  final String subtitle;
  final List<String> description;

  Subtitle({required this.subtitle, required this.description});
}

class Dream {
  final String title;
  final List<Subtitle> subtitles;

  Dream({required this.title, required this.subtitles});

  factory Dream.fromJson(Map<String, dynamic> json) {
    String content = json['content'] as String;
    List<Subtitle> subtitles = _extractSubtitlesFromContent(content);

    return Dream(
      title: json['title'] as String,
      subtitles: subtitles,
    );
  }

  static List<Subtitle> _extractSubtitlesFromContent(String content) {
    final RegExp titleExp = RegExp(r'\*(.*?)\*');
    final List<Subtitle> subtitles = [];
    final matches = titleExp.allMatches(content);

    for (int i = 0; i < matches.length; i++) {
      final titleMatch = matches.elementAt(i);
      final startIndex = titleMatch.end;
      final endIndex = (i < matches.length - 1)
          ? matches.elementAt(i + 1).start
          : content.length;
      final subtitleContent = content.substring(startIndex, endIndex).trim();

      subtitles.add(Subtitle(
        subtitle: titleMatch.group(1) ?? 'Untitled',
        description:
            subtitleContent.split('\n').map((desc) => desc.trim()).toList(),
      ));
    }

    return subtitles;
  }
}
