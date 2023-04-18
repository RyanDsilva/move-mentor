import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:movementor/screens/pose.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/dancer-man.json',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Move',
                  style: GoogleFonts.righteous(
                    fontSize: 56,
                    color: Colors.orange.shade600,
                  ),
                ),
                Text(
                  'Mentor',
                  style: GoogleFonts.righteous(
                    fontSize: 56,
                    color: Colors.yellow.shade700,
                  ),
                ),
              ],
            ),
            Text(
              'Where Movement Meets Motivation',
              style: GoogleFonts.play(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
            // const SizedBox(height: 5),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PoseScreen(),
                  ),
                );
              },
              style: ButtonStyle(
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.orange.shade600,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  'Take Us For A Spin',
                  style: GoogleFonts.play(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
