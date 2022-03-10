import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../contacts/instances.dart';
import '../navigator/app_router_delegate.dart';
import 'authorized/provider/authorized_provider.dart';
import 'provider/splash_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @Deprecated('Use [flutter_native_splash] in place of this')
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    await ref.read(authorizedProvider.notifier).initData();

    ref.read(splashProvider.notifier).initFinished();

    AppRouterDelegate.instance.currentBeamState.updateWith(
      showSplash: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: currentTheme.scaffoldBackgroundColor,
      child: const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}