import 'dart:io';

import 'package:tms/src/common/router/routing_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:root_checker_plus/root_checker_plus.dart';

bool rootedCheck = false;
bool devMode = false;
bool jailbreak = false;

String? checkRootStatus(String route, bool mounted) {
  Box tokensBox = Hive.box('tokens');

  String? access = tokensBox.get('access');
  if (Platform.isAndroid) {
    androidRootChecker(mounted);
    developerMode(mounted);
  }

  if (Platform.isIOS) {
    iosJailbreak(mounted);
  }

  if (rootedCheck || devMode || jailbreak) {
    route = RoutingConst.rootBlock;
  } else {
    if (access == null) {
      route = RoutingConst.auth;
    } else {
      route = RoutingConst.main;
    }
  }
  return route;
}

Future<void> androidRootChecker(bool mounted) async {
  try {
    rootedCheck = (await RootCheckerPlus.isRootChecker())!;
    debugPrint('Root check: ${RootCheckerPlus.isRootChecker()}');
  } on PlatformException {
    rootedCheck = false;
  }
  if (!mounted) return;
  rootedCheck = rootedCheck;
}

Future<void> developerMode(bool mounted) async {
  try {
    devMode = (await RootCheckerPlus.isDeveloperMode())!;
    debugPrint('Developer mode: ${RootCheckerPlus.isDeveloperMode()}');
  } on PlatformException {
    devMode = false;
  }
  if (!mounted) return;
  devMode = devMode;
}

Future<void> iosJailbreak(bool mounted) async {
  try {
    jailbreak = (await RootCheckerPlus.isJailbreak())!;
  } on PlatformException {
    jailbreak = false;
  }
  if (!mounted) return;
  jailbreak = jailbreak;
}
