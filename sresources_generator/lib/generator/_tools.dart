



String convertToCamelCase(String input) {
  List<String> segments = input.split('_');
  for (int i = 0; i < segments.length; i++) {
    segments[i] = (i == 0 ? segments[i][0].toLowerCase() : segments[i][0].toUpperCase()) + segments[i].substring(1);
  }
  return segments.join();
}