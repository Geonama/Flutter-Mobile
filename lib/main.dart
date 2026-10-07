import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CounterApp());
}

/// Warna utama disimpan satu kali agar konsisten di seluruh tampilan.
abstract final class ItenasColors {
  static const blue = Color(0xFF0054A6);
  static const orange = Color(0xFFF58220);
  static const ink = Color(0xFF18243B);
  static const muted = Color(0xFF66738A);
  static const canvas = Color(0xFFF5F7FB);
}

/// StatelessWidget: konfigurasi aplikasi tidak menyimpan nilai counter.
class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITENAS · Counter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
        scaffoldBackgroundColor: ItenasColors.canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: ItenasColors.blue),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: ItenasColors.ink),
          bodyLarge: TextStyle(color: ItenasColors.ink),
        ),
      ),
      home: const CounterScreen(),
    );
  }
}

/// StatefulWidget tetap immutable. Nilai yang berubah berada di objek State.
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    // Inisialisasi sekali saat State pertama kali dibuat.
    _counter = 0;
    debugPrint('CounterScreen: initState');
  }

  // Nol dan bilangan negatif mengikuti aturan genap/ganjil yang sama.
  bool get _isEven => _counter % 2 == 0;

  void _increment() {
    HapticFeedback.selectionClick();
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    HapticFeedback.selectionClick();
    setState(() {
      _counter--;
    });
  }

  void _reset() {
    // Hindari rebuild yang tidak diperlukan jika nilainya sudah nol.
    if (_counter == 0) return;
    HapticFeedback.lightImpact();
    setState(() {
      _counter = 0;
    });
  }

  @override
  void dispose() {
    // Tidak ada controller atau listener pada aplikasi ini.
    // Jika ditambahkan, bersihkan resource tersebut sebelum super.dispose().
    debugPrint('CounterScreen: dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // build hanya menyusun UI; tidak mengubah state atau menjalankan setState.
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 840;
            final workbench = _CounterWorkbench(
              counter: _counter,
              isEven: _isEven,
              onIncrement: _increment,
              onDecrement: _decrement,
              onReset: _reset,
            );

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1160),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        wide ? 48 : 24,
                        wide ? 36 : 24,
                        wide ? 48 : 24,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _LabHeader(),
                          SizedBox(height: wide ? 64 : 32),
                          if (wide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(
                                  child: _Introduction(wide: true),
                                ),
                                const SizedBox(width: 72),
                                Expanded(child: workbench),
                              ],
                            )
                          else ...[
                            const _Introduction(wide: false),
                            const SizedBox(height: 28),
                            workbench,
                            const SizedBox(height: 24),
                            const _ParityGuide(),
                          ],
                          SizedBox(height: wide ? 52 : 28),
                          const _LabFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LabHeader extends StatelessWidget {
  const _LabHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: ItenasColors.ink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.exposure_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Counter Lab.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                ),
              ),
              Text(
                'ITENAS BANDUNG',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: ItenasColors.muted,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFE3E8F0)),
          ),
          child: const Text(
            'PRAKTIKUM 02',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _Introduction extends StatelessWidget {
  const _Introduction({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.circle, size: 7, color: ItenasColors.orange),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'INTERAKTIF. BERWARNA.',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                  color: ItenasColors.muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Hitung. Ubah.\nLihat warnanya.',
          style: TextStyle(
            fontSize: wide ? 50 : 32,
            height: 1.14,
            fontWeight: FontWeight.w800,
            letterSpacing: wide ? -2.5 : -1.3,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tambah atau kurangi angkanya.\nSetiap perubahan punya warna sendiri.',
          style: TextStyle(
            fontSize: 13,
            height: 1.8,
            color: ItenasColors.muted,
          ),
        ),
        if (wide) ...[const SizedBox(height: 40), const _ParityGuide()],
      ],
    );
  }
}

class _CounterWorkbench extends StatelessWidget {
  const _CounterWorkbench({
    required this.counter,
    required this.isEven,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
  });

  final int counter;
  final bool isEven;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final accent = isEven ? ItenasColors.blue : ItenasColors.orange;
    final foreground = isEven ? Colors.white : const Color(0xFF35200D);
    final buttonColor = isEven ? ItenasColors.blue : const Color(0xFFB94C00);
    final label = isEven ? 'GENAP' : 'GANJIL';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0E18243B),
            blurRadius: 40,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              key: const ValueKey('counter_background'),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    right: -76,
                    top: -88,
                    child: _OrbitDecoration(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'NILAI COUNTER',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.8,
                                  color: foreground.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: foreground.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: foreground,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    label,
                                    key: const ValueKey('parity_label'),
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.1,
                                      color: foreground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Semantics(
                          liveRegion: true,
                          label:
                              'Nilai counter $counter, ${label.toLowerCase()}',
                          excludeSemantics: true,
                          child: SizedBox(
                            height: 144,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: Tween<double>(
                                        begin: 0.92,
                                        end: 1,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  ),
                              child: Padding(
                                key: ValueKey(counter),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '$counter',
                                    key: const ValueKey('counter_value'),
                                    style: TextStyle(
                                      fontSize: 116,
                                      height: 1.2,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -6,
                                      color: foreground,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Divider(
                          color: foreground.withValues(alpha: 0.22),
                          height: 1,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.palette_outlined,
                              color: foreground,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isEven ? 'Biru ITENAS' : 'Oranye ITENAS',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: foreground,
                                ),
                              ),
                            ),
                            Text(
                              isEven ? 'Warna genap' : 'Warna ganjil',
                              style: TextStyle(
                                fontSize: 10,
                                color: foreground.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 22, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _CounterButton(
                          buttonKey: const ValueKey('decrement_button'),
                          icon: Icons.remove_rounded,
                          label: 'Kurang',
                          color: ItenasColors.ink,
                          background: const Color(0xFFF0F3F8),
                          onPressed: onDecrement,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CounterButton(
                          buttonKey: const ValueKey('increment_button'),
                          icon: Icons.add_rounded,
                          label: 'Tambah',
                          color: Colors.white,
                          background: buttonColor,
                          onPressed: onIncrement,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    key: const ValueKey('reset_button'),
                    onPressed: onReset,
                    icon: const Icon(Icons.restart_alt_rounded, size: 19),
                    label: const Text('Reset ke 0'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ItenasColors.muted,
                      minimumSize: const Size.fromHeight(48),
                      side: const BorderSide(color: Color(0xFFE3E8F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final Color color;
  final Color background;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      key: buttonKey,
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: FilledButton.styleFrom(
        foregroundColor: color,
        backgroundColor: background,
        minimumSize: const Size.fromHeight(60),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _OrbitDecoration extends StatelessWidget {
  const _OrbitDecoration();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (final size in [260.0, 196.0, 132.0])
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0x16FFFFFF), width: 1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ParityGuide extends StatelessWidget {
  const _ParityGuide();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DUA KONDISI, DUA WARNA',
          style: TextStyle(
            fontSize: 9,
            color: ItenasColors.muted,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 14),
        _ColorRule(
          color: ItenasColors.blue,
          title: 'Genap',
          description: '0, 2, 4, 6, …',
          colorName: 'Biru ITENAS',
        ),
        SizedBox(height: 10),
        _ColorRule(
          color: ItenasColors.orange,
          title: 'Ganjil',
          description: '1, 3, 5, 7, …',
          colorName: 'Oranye ITENAS',
        ),
      ],
    );
  }
}

class _ColorRule extends StatelessWidget {
  const _ColorRule({
    required this.color,
    required this.title,
    required this.description,
    required this.colorName,
  });

  final Color color;
  final String title;
  final String description;
  final String colorName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 10, color: ItenasColors.muted),
              ),
            ],
          ),
        ),
        Text(
          colorName,
          style: const TextStyle(fontSize: 11, color: ItenasColors.muted),
        ),
      ],
    );
  }
}

class _LabFooter extends StatelessWidget {
  const _LabFooter();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Divider(color: Color(0xFFE3E8F0)),
        SizedBox(height: 12),
        Text(
          'SATU KETUKAN, SATU PERUBAHAN.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: ItenasColors.muted,
          ),
        ),
      ],
    );
  }
}
