



String convertToCamelCase(String input) {
  List<String> segments = input.split('_');
  for (int i = 1; i < segments.length; i++) {
    segments[i] = segments[i][0].toUpperCase() + segments[i].substring(1);
  }
  return segments.join();
}