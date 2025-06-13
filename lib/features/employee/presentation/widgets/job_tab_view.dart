import 'package:flutter/material.dart';

class JobTabView extends StatelessWidget {
  final String type;

  const JobTabView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom illustration matching the screenshot
              Stack(
                children: [
                  // Base green shape
                  Container(
                    width: 120,
                    height: 80,
                    child: CustomPaint(
                      painter: _ApplicationIllustrationPainter(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Main message
              Text(
                _getMainMessage(type),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description text
              Text(
                _getDescriptionMessage(type),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // Find jobs button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to find jobs
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Find jobs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // "Not seeing an application?" text
              if (type == 'applied')
                GestureDetector(
                  onTap: () {
                    // Handle "Not seeing an application?" tap
                  },
                  child: Text(
                    'Not seeing an application?',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF4A90E2),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMainMessage(String type) {
    switch (type) {
      case 'saved':
        return 'No saved jobs yet';
      case 'applied':
        return 'No applications yet';
      case 'interviews':
        return 'No interviews scheduled';
      case 'archived':
        return 'No archived jobs';
      default:
        return 'No data';
    }
  }

  String _getDescriptionMessage(String type) {
    switch (type) {
      case 'saved':
        return 'Jobs you save will appear here.';
      case 'applied':
        return 'Applications completed on Indeed will\nappear here for 6 months.';
      case 'interviews':
        return 'Interview invitations will appear here.';
      case 'archived':
        return 'Archived applications will appear here.';
      default:
        return '';
    }
  }
}

// Custom painter for the application illustration
class _ApplicationIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw the green curved shape (like paper airplane base)
    paint.color = const Color(0xFF7DD3C0);
    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    path1.quadraticBezierTo(size.width * 0.3, 0, size.width * 0.7, size.height * 0.2);
    path1.quadraticBezierTo(size.width * 0.9, size.height * 0.3, size.width * 0.8, size.height * 0.8);
    path1.quadraticBezierTo(size.width * 0.5, size.height, 0, size.height * 0.7);
    path1.close();
    canvas.drawPath(path1, paint);

    // Draw the pink/purple paper airplane
    paint.color = const Color(0xFFD63384);
    final path2 = Path();
    path2.moveTo(size.width * 0.4, size.height * 0.3);
    path2.lineTo(size.width * 0.9, size.height * 0.1);
    path2.lineTo(size.width * 0.7, size.height * 0.4);
    path2.lineTo(size.width * 0.85, size.height * 0.45);
    path2.lineTo(size.width * 0.5, size.height * 0.6);
    path2.close();
    canvas.drawPath(path2, paint);

    // Draw the orange/brown accent
    paint.color = const Color(0xFFB8860B);
    final path3 = Path();
    path3.moveTo(size.width * 0.45, size.height * 0.35);
    path3.lineTo(size.width * 0.6, size.height * 0.25);
    path3.lineTo(size.width * 0.55, size.height * 0.5);
    path3.close();
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}