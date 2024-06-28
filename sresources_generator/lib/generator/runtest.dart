void main() {
  String myString =  """Hello
   blank ' "  \n \t \r
  fragment"""; // Replace with your own string
  List<int> asciiCodes = [];

  for (int i = 0; i < myString.length; i++) {
    print("${myString.codeUnitAt(i)}=${myString[i]}");
  }

  print("ASCII codes for each character in the string:");
  print(asciiCodes);
}