import 'dart:math' show pi;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<double> animation;
//   @override
//   void initState() {
//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );

//     animation = Tween<double>(begin: 0, end: 2 * pi).animate(controller);

//     controller.repeat();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//           animation: controller,
//           builder: (context, child) => Transform(
//             alignment: Alignment.center,
//             // origin: const Offset(50, 50),
//             transform: Matrix4.identity()..rotateY(animation.value),
//             child: Container(
//               width: 100,
//               height: 100,
//               color: Colors.blue,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension on VoidCallback {
//   Future<void> delayed(Duration duration) => Future.delayed(duration, this);
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//   late AnimationController counterClockwiseRotationController;
//   late Animation counterClockwiseRotationAnimation;

//   late AnimationController flipController;
//   late Animation flipAnimation;

//   @override
//   void initState() {
//     counterClockwiseRotationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     );

//     counterClockwiseRotationAnimation = Tween<double>(
//       begin: 0,
//       end: -(pi / 2),
//     ).animate(
//       CurvedAnimation(
//         parent: counterClockwiseRotationController,
//         curve: Curves.bounceOut,
//       ),
//     );

//     flipController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     );

//     flipAnimation = Tween<double>(
//       begin: 0,
//       end: pi,
//     ).animate(
//       CurvedAnimation(
//         parent: flipController,
//         curve: Curves.bounceOut,
//       ),
//     );

//     counterClockwiseRotationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         flipAnimation = Tween<double>(
//           begin: flipAnimation.value,
//           end: flipAnimation.value + pi,
//         ).animate(
//           CurvedAnimation(
//             parent: flipController,
//             curve: Curves.bounceOut,
//           ),
//         );
//         flipController
//           ..reset()
//           ..forward();
//       }
//     });

//     flipController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         counterClockwiseRotationAnimation = Tween<double>(
//           begin: counterClockwiseRotationAnimation.value,
//           end: counterClockwiseRotationAnimation.value + -(pi / 2),
//         ).animate(
//           CurvedAnimation(
//             parent: counterClockwiseRotationController,
//             curve: Curves.bounceOut,
//           ),
//         );
//         counterClockwiseRotationController
//           ..reset()
//           ..forward();
//       }
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     counterClockwiseRotationController.dispose();
//     flipController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     counterClockwiseRotationController
//       ..reset()
//       ..forward.delayed(
//         const Duration(seconds: 1),
//       );
//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//             animation: counterClockwiseRotationController,
//             builder: (context, child) {
//               return Transform(
//                 alignment: Alignment.center,
//                 transform: Matrix4.identity()
//                   ..rotateZ(counterClockwiseRotationAnimation.value),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AnimatedBuilder(
//                       animation: flipController,
//                       builder: (context, child) => Transform(
//                         alignment: Alignment.centerRight,
//                         transform: Matrix4.identity()
//                           ..rotateY(flipAnimation.value),
//                         child: ClipPath(
//                           clipper:
//                               HalfCircleClipper(circleSide: CircleSide.left),
//                           child: Container(
//                             width: 100,
//                             height: 100,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ),
//                     AnimatedBuilder(
//                       animation: flipAnimation,
//                       builder: (context, child) => Transform(
//                         alignment: Alignment.centerLeft,
//                         transform: Matrix4.identity()
//                           ..rotateY(flipAnimation.value),
//                         child: ClipPath(
//                           clipper:
//                               HalfCircleClipper(circleSide: CircleSide.right),
//                           child: Container(
//                             width: 100,
//                             height: 100,
//                             color: Colors.yellow,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }

// enum CircleSide {
//   left,
//   right,
// }

// extension ToPath on CircleSide {
//   Path toPath(Size size) {
//     final path = Path();
//     late Offset offset;
//     late bool clockwise;
//     switch (this) {
//       case CircleSide.left:
//         path.moveTo(size.width, 0);
//         offset = Offset(size.width, size.height);
//         clockwise = false;
//         break;
//       case CircleSide.right:
//         offset = Offset(0, size.height);
//         clockwise = true;
//     }

//     path.arcToPoint(
//       offset,
//       clockwise: clockwise,
//       radius: Radius.elliptical(
//         size.width / 2,
//         size.height / 2,
//       ),
//     );

//     path.close();

//     return path;
//   }
// }

// class HalfCircleClipper extends CustomClipper<Path> {
//   HalfCircleClipper({required this.circleSide});

//   final CircleSide circleSide;
//   @override
//   Path getClip(Size size) => circleSide.toPath(size);

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
