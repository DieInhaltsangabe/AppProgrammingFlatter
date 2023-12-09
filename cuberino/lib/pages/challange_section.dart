import 'dart:async';
import 'package:cuberino/components/bottom_app_bar.dart';
import 'package:cuberino/app_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ChallangesSection extends StatefulWidget {
  const ChallangesSection({super.key});

  @override
  State<ChallangesSection> createState() => Challanges();
}

class Challanges extends State<ChallangesSection> {
  List logs = [];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
          child: Center(
            child: Text("Hey"),
          ),
      ),
      bottomNavigationBar: BottomMenu(true, true, true, false),
    );
  }
}
