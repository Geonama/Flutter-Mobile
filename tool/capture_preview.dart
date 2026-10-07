// Jalankan: flutter test tool/capture_preview.dart
// Merender UI aplikasi ke PNG untuk dokumentasi, tanpa emulator.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itenas_counter/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    for (final entry in {
      'Manrope': 'assets/fonts/Manrope.ttf',
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
    }.entries) {
      final loader = FontLoader(entry.key)
        ..addFont(rootBundle.load(entry.value));
      await loader.load();
    }
  });

  for (final size in [const Size(390, 1000), const Size(1440, 900)]) {
    testWidgets('Render preview ${size.width}', (tester) async {
      final previousShadowSetting = debugDisableShadows;
      debugDisableShadows = false;
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const previewKey = ValueKey('preview');
      await tester.pumpWidget(
        const RepaintBoundary(key: previewKey, child: CounterApp()),
      );
      await tester.pumpAndSettle();

      Future<void> capture(String condition) async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(previewKey),
        );
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File(
            'docs/screenshots/${size.width.toInt()}-$condition.png',
          );
          await file.parent.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }

      await capture('genap');
      await tester.tap(find.byKey(const ValueKey('increment_button')));
      await tester.pumpAndSettle();
      await capture('ganjil');
      debugDisableShadows = previousShadowSetting;
    });
  }
}
