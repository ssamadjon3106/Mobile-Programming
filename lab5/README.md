# Lab 5: Navigation and Routing

Flutter mobile programming exercises about moving between screens

## Tasks

### 1. Navigator: push and pop

1. task1_1.dart - Two screens with push and pop
2. task1_2.dart - Three-screen chain
3. task1_3.dart - Login with pushReplacement
4. task1_4.dart - Four steps and popUntil
5. task1_5.dart - BackOrExitButton widget

### 2. Named routes

1. task2_1.dart - Route table and pushNamed
2. task2_2.dart - Menu with four routes
3. task2_3.dart - Page not found
4. task2_4.dart - Drawer navigation
5. task2_5.dart - Log out

### 3. Passing arguments with constructors

1. task3_1.dart - Product list and details
2. task3_2.dart - Greeting
3. task3_3.dart - Contact card
4. task3_4.dart - Pick a colour
5. task3_5.dart - Edit a counter

### 4. Passing arguments with named routes

1. task4_1.dart - ScreenArguments class
2. task4_2.dart - Send a number
3. task4_3.dart - User profile
4. task4_4.dart - onGenerateRoute
5. task4_5.dart - Rating from a named route

### 5. Transition animations

1. task5_1.dart - Fade
2. task5_2.dart - Slide from the right
3. task5_3.dart - Slide from the bottom
4. task5_4.dart - Scale and fade together
5. task5_5.dart - FadeRoute and global theme

### 6. go_router

1. task6_1.dart - go, push and pop
2. task6_2.dart - Path parameters
3. task6_3.dart - Passing an object with extra
4. task6_4.dart - Named routes and 404 page
5. task6_5.dart - Transition in go_router

## How to run

```
flutter pub get
flutter run -d chrome -t lib/task1_1.dart
```

## Self-check questions

**1. What is the difference between push and pushReplacement?**

push puts the new screen on top of the old one, so the back button returns to the old screen. pushReplacement removes the current screen and puts the new one in its place, so the user cannot go back to it. I used it for the login screen.

**2. Why should route names be kept in constants?**

If I write the name as a string every time, I can make a typo and the app only fails when I press the button. With constants the compiler finds the mistake, and I can change the name in one place.

**3. How do you return a value from a screen, and what is received if the user presses the system back button?**

The second screen calls `Navigator.pop(context, value)` and the first screen waits with `await Navigator.push(...)`. If the user presses the back button, nothing is passed, so the result is `null` and it has to be checked.

**4. What is the difference between context.go and context.push in go_router?**

`context.go` replaces the stack with the new location, so there may be no back arrow. `context.push` adds the screen on top of the stack, so the back arrow and `pop` work.

**5. When is a path parameter better than extra?**

When the screen should still work after a reload in the browser or when it is opened by a link. The path parameter is part of the URL, but `extra` is only kept in memory and is lost after reload.

## Notes

- Task 4.5: `pushNamed<int>` crashed with the `routes` table, because the table creates a route without a type. I used `onGenerateRoute` with `MaterialPageRoute<int>` for `/rate`.
- Task 4.5: if the user goes back with the back arrow, Home still shows "Not rated yet".
- Task 6.3: after reload in the browser `extra` is null and the cast fails.
