import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<int> dotAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();

    dotAnimation = IntTween(
      begin: 1,
      end: 3,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: dotAnimation,
      builder: (context, child) {
        String dots = '.' * dotAnimation.value;
        return Text(
          dots,
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900),
        );
      },
    );
  }
}

class AIMessageWidget extends StatefulWidget {
  AIMessageWidget({super.key, required this.response, required this.isLoading});
  final String response;
  bool isLoading;

  @override
  State<AIMessageWidget> createState() => _AIMessageWidgetState();
}

class _AIMessageWidgetState extends State<AIMessageWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        widget.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40.0,
          foregroundImage: AssetImage('assets/images/yoyo_avatar.jpg'),
        ),
        SizedBox(width: 10.0),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 250.0,
            minHeight: 20.0,
            minWidth: 20.0,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  widget.isLoading
                      ? LoadingDots()
                      : Text(widget.response, style: TextStyle(fontSize: 20.0)),
            ),
          ),
        ),
      ],
    );
  }
}

class userMessageWidget extends StatelessWidget {
  const userMessageWidget({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 250.0,
            minHeight: 20.0,
            minWidth: 20.0,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(message, style: TextStyle(fontSize: 20.0)),
            ),
          ),
        ),
        SizedBox(width: 10.0),
        CircleAvatar(
          radius: 40.0,
          foregroundImage: AssetImage('assets/images/elderly_avatar.png'),
        ),
      ],
    );
  }
}
