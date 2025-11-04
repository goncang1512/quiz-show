import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_show/screens/finish_screen.dart';
import 'package:quiz_show/screens/form_user_screen.dart';
import 'package:quiz_show/screens/home_screen.dart';
import 'package:quiz_show/screens/question_screen.dart';
import 'package:quiz_show/screens/score_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      name: "Home",
      builder: (context, state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      path: "/profile",
      name: "Profile",
      builder: (context, state) {
        return FormUserScreen();
      },
    ),
    GoRoute(
      path: "/question/:question_id",
      name: "Question",
      builder: (context, state) {
        final String questionId = state.pathParameters["question_id"]!;

        return QuestionScreen(
          key: ValueKey(questionId),
          questionId: questionId,
        );
      },
    ),
    GoRoute(
      path: "/finish",
      name: "Finish",
      builder: (context, state) {
        return FinishScreen();
      },
    ),
    GoRoute(
      path: "/score",
      name: "Score",
      builder: (context, state) {
        return LastScoreScreen();
      },
    ),
  ],
);
