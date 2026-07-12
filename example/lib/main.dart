import 'package:flutter/material.dart';
import 'package:material3_indicators/material3_indicators.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material 3 Expressive Indicators',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3 Expressive Indicators'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.blur_circular), text: 'Loading'),
            Tab(icon: Icon(Icons.linear_scale), text: 'Wavy Linear'),
            Tab(icon: Icon(Icons.looks), text: 'Wavy Circular'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ExpressiveLoadingTab(),
          WavyLinearTab(),
          WavyCircularTab(),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// TAB 1: Expressive Loading (Shape Morphing)
// ----------------------------------------------------
class ExpressiveLoadingTab extends StatefulWidget {
  const ExpressiveLoadingTab({super.key});

  @override
  State<ExpressiveLoadingTab> createState() => _ExpressiveLoadingTabState();
}

class _ExpressiveLoadingTabState extends State<ExpressiveLoadingTab> {
  bool _contained = false;
  double _size = 48.0;
  double _containerSize = 72.0;
  int _morphMs = 800;
  int _rotateMs = 2400;

  // Active shapes inside the morph cycle
  bool _usePentagon = true;
  bool _useSunny = true;
  bool _useSoftBurst = true;
  bool _useCookie = true;
  bool _usePill = true;

  List<ShapeBorder> _getCustomCycle() {
    final List<ShapeBorder> list = [];
    if (_usePentagon) list.add(ExpressiveShapes.pentagon());
    if (_useSunny) list.add(ExpressiveShapes.sunny());
    if (_useSoftBurst) list.add(ExpressiveShapes.softBurst());
    if (_useCookie) list.add(ExpressiveShapes.cookie());
    if (_usePill) list.add(ExpressiveShapes.pill());

    // Fallback if none selected
    if (list.isEmpty) {
      list.add(ExpressiveShapes.cookie());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shapes = _getCustomCycle();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Visual Showcase Panel
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Center(
                child: ExpressiveLoadingIndicator(
                  key: ValueKey([_contained, _size, _containerSize, _morphMs, _rotateMs, shapes.length]),
                  shapes: shapes,
                  size: _size,
                  contained: _contained,
                  containerSize: _containerSize,
                  morphDuration: Duration(milliseconds: _morphMs),
                  rotationDuration: Duration(milliseconds: _rotateMs),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // Configurations Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Configurations', style: theme.textTheme.titleMedium),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Contained Style'),
                    subtitle: const Text('Render within a styled background card'),
                    value: _contained,
                    onChanged: (val) => setState(() => _contained = val),
                  ),
                  if (_contained) ...[
                    ListTile(
                      title: Text('Container Size: ${_containerSize.toStringAsFixed(0)}dp'),
                      subtitle: Slider(
                        min: 60.0,
                        max: 120.0,
                        value: _containerSize,
                        onChanged: (val) => setState(() => _containerSize = val),
                      ),
                    ),
                  ],
                  ListTile(
                    title: Text('Indicator Size: ${_size.toStringAsFixed(0)}dp'),
                    subtitle: Slider(
                      min: 24.0,
                      max: 60.0,
                      value: _size,
                      onChanged: (val) => setState(() => _size = val),
                    ),
                  ),
                  ListTile(
                    title: Text('Morph Transition Speed: ${_morphMs}ms'),
                    subtitle: Slider(
                      min: 300.0,
                      max: 2000.0,
                      divisions: 17,
                      value: _morphMs.toDouble(),
                      onChanged: (val) => setState(() => _morphMs = val.toInt()),
                    ),
                  ),
                  ListTile(
                    title: Text('360° Rotation Speed: ${_rotateMs}ms'),
                    subtitle: Slider(
                      min: 800.0,
                      max: 5000.0,
                      divisions: 21,
                      value: _rotateMs.toDouble(),
                      onChanged: (val) => setState(() => _rotateMs = val.toInt()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Toggle Shapes in Cycle', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      FilterChip(
                        label: const Text('Pentagon'),
                        selected: _usePentagon,
                        onSelected: (val) => setState(() => _usePentagon = val),
                      ),
                      FilterChip(
                        label: const Text('Sunny'),
                        selected: _useSunny,
                        onSelected: (val) => setState(() => _useSunny = val),
                      ),
                      FilterChip(
                        label: const Text('Soft Burst'),
                        selected: _useSoftBurst,
                        onSelected: (val) => setState(() => _useSoftBurst = val),
                      ),
                      FilterChip(
                        label: const Text('Cookie'),
                        selected: _useCookie,
                        onSelected: (val) => setState(() => _useCookie = val),
                      ),
                      FilterChip(
                        label: const Text('Pill/Oval'),
                        selected: _usePill,
                        onSelected: (val) => setState(() => _usePill = val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// TAB 2: Wavy Linear Progress
// ----------------------------------------------------
class WavyLinearTab extends StatefulWidget {
  const WavyLinearTab({super.key});

  @override
  State<WavyLinearTab> createState() => _WavyLinearTabState();
}

class _WavyLinearTabState extends State<WavyLinearTab> {
  bool _isIndeterminate = false;
  double _progress = 0.5;
  double _amplitude = 4.0;
  double _wavelength = 24.0;
  double _speed = 5.0;
  double _strokeWidth = 4.0;
  double _trackWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Visual Showcase Panel
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            child: Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: WavyLinearProgressIndicator(
                  value: _isIndeterminate ? null : _progress,
                  amplitude: _amplitude,
                  wavelength: _wavelength,
                  waveSpeed: _speed,
                  strokeWidth: _strokeWidth,
                  trackStrokeWidth: _trackWidth,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // Configurations Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Configurations', style: theme.textTheme.titleMedium),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Indeterminate State'),
                    subtitle: const Text('Infinite loop instead of static value'),
                    value: _isIndeterminate,
                    onChanged: (val) => setState(() => _isIndeterminate = val),
                  ),
                  if (!_isIndeterminate) ...[
                    ListTile(
                      title: Text('Progress Value: ${(_progress * 100).toInt()}%'),
                      subtitle: Slider(
                        min: 0.0,
                        max: 1.0,
                        value: _progress,
                        onChanged: (val) => setState(() => _progress = val),
                      ),
                    ),
                  ],
                  ListTile(
                    title: Text('Amplitude (Wave Height): ${_amplitude.toStringAsFixed(1)}dp'),
                    subtitle: Slider(
                      min: 0.0,
                      max: 12.0,
                      value: _amplitude,
                      onChanged: (val) => setState(() => _amplitude = val),
                    ),
                  ),
                  ListTile(
                    title: Text('Wavelength (Wave Stretch): ${_wavelength.toStringAsFixed(0)}dp'),
                    subtitle: Slider(
                      min: 10.0,
                      max: 50.0,
                      value: _wavelength,
                      onChanged: (val) => setState(() => _wavelength = val),
                    ),
                  ),
                  ListTile(
                    title: Text('Wave Speed: ${_speed.toStringAsFixed(1)}'),
                    subtitle: Slider(
                      min: 1.0,
                      max: 10.0,
                      value: _speed,
                      onChanged: (val) => setState(() => _speed = val),
                    ),
                  ),
                  ListTile(
                    title: Text('Stroke Thickness: ${_strokeWidth.toStringAsFixed(1)}dp'),
                    subtitle: Slider(
                      min: 1.0,
                      max: 8.0,
                      value: _strokeWidth,
                      onChanged: (val) => setState(() => _strokeWidth = val),
                    ),
                  ),
                  ListTile(
                    title: Text('Track Thickness: ${_trackWidth.toStringAsFixed(1)}dp'),
                    subtitle: Slider(
                      min: 0.5,
                      max: 6.0,
                      value: _trackWidth,
                      onChanged: (val) => setState(() => _trackWidth = val),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// TAB 3: Wavy Circular Progress
// ----------------------------------------------------
class WavyCircularTab extends StatefulWidget {
  const WavyCircularTab({super.key});

  @override
  State<WavyCircularTab> createState() => _WavyCircularTabState();
}

class _WavyCircularTabState extends State<WavyCircularTab> {
  bool _isIndeterminate = false;
  double _progress = 0.65;
  double _amplitude = 3.0;
  double _frequency = 8.0;
  double _speed = 5.0;
  double _strokeWidth = 4.0;
  double _trackWidth = 2.0;
  double _indicatorSize = 64.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Visual Showcase Panel
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: Center(
                child: WavyCircularProgressIndicator(
                  value: _isIndeterminate ? null : _progress,
                  amplitude: _amplitude,
                  frequency: _frequency,
                  waveSpeed: _speed,
                  strokeWidth: _strokeWidth,
                  trackStrokeWidth: _trackWidth,
                  size: _indicatorSize,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // Configurations Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Configurations', style: theme.textTheme.titleMedium),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Indeterminate State'),
                    subtitle: const Text('Continuous cycle with shrinking/growing arc'),
                    value: _isIndeterminate,
                    onChanged: (val) => setState(() => _isIndeterminate = val),
                  ),
                  if (!_isIndeterminate) ...[
                    ListTile(
                      title: Text('Progress Value: ${(_progress * 100).toInt()}%'),
                      subtitle: Slider(
                        min: 0.0,
                        max: 1.0,
                        value: _progress,
                        onChanged: (val) => setState(() => _progress = val),
                      ),
                    ),
                  ],
                  ListTile(
                    title: Text('Indicator Size: ${_indicatorSize.toStringAsFixed(0)}dp'),
                    subtitle: Slider(
                      min: 48.0,
                      max: 100.0,
                      value: _indicatorSize,
                      onChanged: (val) => setState(() => _indicatorSize = val),
                    ),
                  ),
                  ListTile(
                    title: Text('Amplitude (Wave Depth): ${_amplitude.toStringAsFixed(1)}dp'),
                    subtitle: Slider(
                      min: 0.0,
                      max: 8.0,
                      value: _amplitude,
                      onChanged: (val) => setState(() => _amplitude = val),
                    ),
                  ),
                  ListTile(
                    title: Text('Frequency (Wave Crests): ${_frequency.toStringAsFixed(0)}'),
                    subtitle: Slider(
                      min: 4.0,
                      max: 16.0,
                      divisions: 12,
                      value: _frequency,
                      onChanged: (val) => setState(() => _frequency = val),
                    ),
                  ),
                  ListTile(
                    title: Text('Wave Speed: ${_speed.toStringAsFixed(1)}'),
                    subtitle: Slider(
                      min: 1.0,
                      max: 10.0,
                      value: _speed,
                      onChanged: (val) => setState(() => _speed = val),
                    ),
                  ),
                  ListTile(
                    title: Text('Stroke Thickness: ${_strokeWidth.toStringAsFixed(1)}dp'),
                    subtitle: Slider(
                      min: 1.0,
                      max: 8.0,
                      value: _strokeWidth,
                      onChanged: (val) => setState(() => _strokeWidth = val),
                    ),
                  ),
                  ListTile(
                    title: Text('Track Thickness: ${_trackWidth.toStringAsFixed(1)}dp'),
                    subtitle: Slider(
                      min: 0.5,
                      max: 6.0,
                      value: _trackWidth,
                      onChanged: (val) => setState(() => _trackWidth = val),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
