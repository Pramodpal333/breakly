import 'package:flutter/material.dart';
import '../models/move_activity.dart';

final List<MoveActivity> defaultActivities = [
  MoveActivity(
    title: "Seated Spinal Twist",
    description:
        "Turn your torso to the left, hold chair back. Repeat right side.",
    icon: Icons.accessibility_new,
    isStealth: true,
  ),
  MoveActivity(
    title: "Neck Release",
    description: "Gently tilt your ear to your shoulder. Hold 10s each side.",
    icon: Icons.face,
    isStealth: true,
  ),
  MoveActivity(
    title: "The Invisible Chair",
    description: "Hover just above your seat for 15 seconds. Feel the burn.",
    icon: Icons.event_seat,
    isStealth: false,
  ),
  MoveActivity(
    title: "Desk Pushups",
    description: "Place hands on desk edge, lean in, push back. Do 10 reps.",
    icon: Icons.fitness_center,
    isStealth: false,
  ),
  MoveActivity(
    title: "Eye Reset",
    description: "Look at something 20 feet away for 20 seconds.",
    icon: Icons.remove_red_eye,
    isStealth: true,
  ),
  MoveActivity(
    title: "Ankle Rolls",
    description: "Lift feet slightly. Rotate ankles clockwise, then counter.",
    icon: Icons.refresh,
    isStealth: true,
  ),
];
