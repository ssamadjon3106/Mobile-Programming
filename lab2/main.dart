// void main(List<String> arguments){
//   var name='Samadjon Sayfullayev';
//   var studentId=240474;
//   var major='Software Engineering';
//   print("My name is $name.\n My student ID: $studentId.\n Major: $major.\n");
//   print("Command-line argument count: ${arguments.length}");
// }

// void main() {
//   const numbers = [12.5, 34, 43.4, 43.2];
  
//   if (numbers.isEmpty) {
//     print('Nothing is provided');
//     return;
//   }

//   double sum = 0;
//   for (var number in numbers) {
//     sum += number;
//   }

//   final average = sum / numbers.length;
//   print('Average: $average');
// }


// void main(List<String> arguments){
//   if(arguments.length!=2){
//     print('Warning: number of arguments is not 2');
//     return;
//   }
//   print("Recieved arguments: ${arguments[0]} and ${arguments[1]}");
// }

// void main(){
//   int age=20;
//   final double gpa=3.3;
//   final String country='Uzbeksitan';
//   final bool IsStudent=true;

//   print("Age: $age. GPA: $gpa. Country: $country. Student: $IsStudent.");
// }

// void main() {
//   final time1 = DateTime.now();
//   const oneHour = Duration(hours: 1);
//   final timeLater = time1.add(oneHour);

//   print('Time 1 (runtime):      $time1');
//   print('Const offset:          $oneHour');
//   print('Time later (runtime):  $timeLater');
// }




// void main(){
//   String requiredUsername='Samadjon';

//   String? nullableNickname;
//   String? nullableBio="Software engineering";

//   final displayName= nullableNickname?? requiredUsername;
//   final displayBio= nullableBio?? "No bio provided";
//   final fallbackExample= nullableNickname?? "Guest user";

//   print("Display Name: $displayName");
//   print("Display Bio: $displayBio");
//   print("fallback Example: $fallbackExample");
// }


// void main() {
//   Object? item = 'Software Engineering';


//   if (item is String) {
//     print('String length: ${item.length}');
//     print('Uppercase: ${item.toUpperCase()}');
//   }

//   item = 240474;

//   if (item is int) {
//     print('Is even student ID? ${item.isEven}');
//   }
//   dynamic rawValue = 3.14159;
//   if (rawValue is double) {
//     print('Rounded pi: ${rawValue.round()}');
//   }
// }


// void main(){
//   int n=4;
//   if (n >0){
//     print("Number is positve.");
//   } else if (n<0)  {
//     print("Number is negative.");
//   } else {
//     print("Number is 0.");
//   }

// }

// int StandardFactorial(int n){

//   if (n<0) throw ArgumentError("Negative number are  not allowed");
//   int result =1;
//   for(int i=1; i<n; i++){
//     result *=i;
//   }
//   return result;
// }

// int FactorialForIn(int n){
//   if (n<0) throw ArgumentError("Negateve numbers are now allowed");
//   int result =1;
//   final sequence=[for (var i=n; i<n; i++) i];
//   for (var i in sequence){
//     result *=i;
//   }
//   return result;
// }

// void main(){
//   int n= 10;
//   print("Stardard for loop: $n! = ${StandardFactorial(n)} ");
//   print("For in loop: $n!= ${FactorialForIn(n)}");
// }

