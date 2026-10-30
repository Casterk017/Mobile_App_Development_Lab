import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Mobile App Dev - Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedOption = 'Gryffindor'; // Default option (Hogwarts house / Role)

  final List<String> _options = [
    'Gryffindor',
    'Hufflepuff',
    'Ravenclaw',
    'Slytherin',
  ];

  // 1. Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 2. Cupertino Date Picker (Modal Sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            onDateTimeChanged: (DateTime newDate) {
              setState(() => _selectedDate = newDate);
            },
          ),
        ),
      ),
    );
  }

  // 4. Cupertino Wheel Picker (Modal Sheet)
  void _showCupertinoPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 220,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            itemExtent: 36,
            scrollController: FixedExtentScrollController(
              initialItem: _options.indexOf(_selectedOption) != -1
                  ? _options.indexOf(_selectedOption)
                  : 0,
            ),
            onSelectedItemChanged: (int index) {
              setState(() => _selectedOption = _options[index]);
            },
            children: _options.map((item) => Center(child: Text(item))).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildPortraitView()
                : _buildLandscapeView();
          },
        ),
      ),
    );
  }

  // Portrait Layout
  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const StudentDetailsSection(),
        const SizedBox(height: 16),
        const LocationSection(),
        const SizedBox(height: 16),
        _buildPickersCard(),
      ],
    );
  }

  // Landscape Layout
  Widget _buildLandscapeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 1,
            child: StudentDetailsSection(),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const LocationSection(),
                const SizedBox(height: 16),
                _buildPickersCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Pickers Section Card
  Widget _buildPickersCard() {
    final String formattedDate =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Interactive Pickers (Lab 02)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Selected Date: $formattedDate\nSelected House/Role: $_selectedOption',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 24),

            // Material Date Picker Button
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: const Text('Select Material Date'),
              onPressed: () => _selectMaterialDate(context),
            ),
            const SizedBox(height: 8),

            // Cupertino Date Picker Button
            OutlinedButton.icon(
              icon: const Icon(CupertinoIcons.calendar),
              label: const Text('Select Cupertino Date'),
              onPressed: () => _showCupertinoDatePicker(context),
            ),
            const SizedBox(height: 12),

            // Material Dropdown
            InputDecorator(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                border: OutlineInputBorder(),
                labelText: 'Material Dropdown',
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedOption,
                  items: _options.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedOption = newValue);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Cupertino Wheel Picker Button
            OutlinedButton.icon(
              icon: const Icon(CupertinoIcons.circle_grid_hex),
              label: const Text('Select Cupertino House Wheel'),
              onPressed: () => _showCupertinoPicker(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Student Details Card
// ---------------------------------------------------------------------------
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircleAvatar(
              radius: 46,
              backgroundColor: Colors.indigo,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            SizedBox(height: 14),
            Text(
              'Chai Yu Chern',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Student ID: BCS24020012',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            Divider(height: 24, thickness: 1),
            Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '"I want to sleep"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Location Section (TitleSection + Image)
// ---------------------------------------------------------------------------
class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleSection(
            name: 'Location Details',
            location: 'Hogwarts School of Witchcraft and Wizardry',
            starCount: 41,
          ),
          Image.asset(
            'assets/lake.jpg',
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 140,
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.image, size: 48, color: Colors.grey[400]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. TitleSection Widget
// ---------------------------------------------------------------------------
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500], size: 20),
          const SizedBox(width: 4),
          Text(
            '$starCount',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}