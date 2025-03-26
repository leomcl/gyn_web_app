import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snow_stats_app/domain/entities/gym_class.dart';
import '../cubit/gym_classes/gym_classes_cubit.dart';
import '../cubit/gym_classes/gym_classes_state.dart';
import '../widgets/class_performance_section.dart';

class GymClassesPage extends StatelessWidget {
  const GymClassesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load classes when the page is first opened
    context.read<GymClassesCubit>().loadClasses();

    return BlocBuilder<GymClassesCubit, GymClassesState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gym Classes',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Class'),
                    onPressed: () => _showClassForm(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Filter controls
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<GymClassFilter>(
                      decoration: const InputDecoration(
                        labelText: 'Filter by Tag',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: GymClassFilter.all,
                            child: Text('All Classes')),
                        DropdownMenuItem(
                            value: GymClassFilter.fullBody,
                            child: Text('Full Body')),
                        DropdownMenuItem(
                            value: GymClassFilter.arms, child: Text('Arms')),
                        DropdownMenuItem(
                            value: GymClassFilter.legs, child: Text('Legs')),
                        DropdownMenuItem(
                            value: GymClassFilter.chest, child: Text('Chest')),
                        DropdownMenuItem(
                            value: GymClassFilter.cardio,
                            child: Text('Cardio')),
                      ],
                      value: state.filter,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<GymClassesCubit>().changeFilter(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(state.selectedDate != null
                                ? DateFormat('MMM d, yyyy')
                                    .format(state.selectedDate!)
                                : 'Select Date'),
                            onPressed: () => _selectDate(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        if (state.selectedDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => context
                                .read<GymClassesCubit>()
                                .clearDateFilter(),
                            tooltip: 'Clear date filter',
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Classes list
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.error != null
                        ? Center(child: Text('Error: ${state.error}'))
                        : state.classes.isEmpty
                            ? const Center(child: Text('No classes available'))
                            : _buildClassesGrid(context, state),
              ),

              // Fixed widget at the bottom - using ClassPerformanceSection
              const SizedBox(height: 16),
              Container(
                height: 180, // Fixed height
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: ClassPerformanceSection(
                        limit: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassesGrid(BuildContext context, GymClassesState state) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: state.classes.length,
      itemBuilder: (context, index) {
        final gymClass = state.classes[index];
        return _ClassCard(
          gymClass: gymClass,
          onTap: () {
            context.read<GymClassesCubit>().getClassDetails(gymClass.classId);
            _showClassDetails(context, gymClass);
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      context.read<GymClassesCubit>().selectDate(pickedDate);
    }
  }

  Future<void> _showClassDetails(
      BuildContext context, GymClass gymClass) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(gymClass.className),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Time: ${_formatTimeWithDay(gymClass.classTime, gymClass.dayOfWeek)}'),
                const SizedBox(height: 8),
                const Text('Tags:'),
                Wrap(
                  spacing: 8,
                  children: gymClass.tags.entries
                      .where((entry) => entry.value)
                      .map((entry) => Chip(label: Text(entry.key)))
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showClassForm(context, gymClass);
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                _confirmDelete(context, gymClass.classId);
              },
              child: const Text('Delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, String classId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Class'),
          content: const Text('Are you sure you want to delete this class?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<GymClassesCubit>().removeClass(classId);
                Navigator.of(context).pop(); // Close confirm dialog
                Navigator.of(context).pop(); // Close details dialog
              },
              child: const Text('Delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showClassForm(BuildContext context,
      [GymClass? existingClass]) async {
    final TextEditingController nameController = TextEditingController(
      text: existingClass?.className ?? '',
    );

    DateTime selectedTime = existingClass?.classTime ?? DateTime.now();

    Map<String, bool> tags = {
      'Full Body': false,
      'Arms': false,
      'Legs': false,
      'Chest': false,
      'Cardio': false,
    };

    // If editing existing class, use its tags
    if (existingClass != null) {
      tags = Map.from(existingClass.tags);
    }

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(existingClass == null ? 'Add New Class' : 'Edit Class'),
            content: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Class Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                        'Class Time: ${DateFormat('MMM d, yyyy - h:mm a').format(selectedTime)}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Change Date'),
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedTime,
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: const Text('Change Time'),
                          onPressed: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(selectedTime),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                selectedTime = DateTime(
                                  selectedTime.year,
                                  selectedTime.month,
                                  selectedTime.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Tags:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.entries.map((entry) {
                        return FilterChip(
                          label: Text(entry.key),
                          selected: entry.value,
                          onSelected: (selected) {
                            setState(() {
                              tags[entry.key] = selected;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final className = nameController.text.trim();
                  if (className.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a class name')),
                    );
                    return;
                  }

                  final newClass = GymClass(
                    classId: existingClass?.classId ?? '',
                    className: className,
                    dayOfWeek: selectedTime
                        .weekday, // Using standard format where Monday = 1
                    timeOfDay: selectedTime.hour * 60 +
                        selectedTime
                            .minute, // Convert to minutes since midnight
                    tags: tags,
                  );

                  if (existingClass == null) {
                    context.read<GymClassesCubit>().addClass(newClass);
                  } else {
                    context.read<GymClassesCubit>().modifyClass(newClass);
                  }

                  Navigator.of(context).pop();
                  if (existingClass != null) {
                    Navigator.of(context).pop(); // Close details dialog too
                  }
                },
                child: Text(existingClass == null ? 'Add' : 'Save'),
              ),
            ],
          );
        });
      },
    );
  }
}

String _formatTimeWithDay(DateTime time, int dayOfWeek) {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final timeFormat = DateFormat('h:mm a');
  return '${timeFormat.format(time)} ${days[dayOfWeek - 1]}';
}

class _ClassCard extends StatelessWidget {
  final GymClass gymClass;
  final VoidCallback onTap;

  const _ClassCard({
    required this.gymClass,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gymClass.className,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimeWithDay(gymClass.classTime, gymClass.dayOfWeek),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: gymClass.tags.entries
                      .where((entry) => entry.value)
                      .map((entry) => Chip(
                            label: Text(
                              entry.key,
                              style: const TextStyle(fontSize: 10),
                            ),
                            padding: EdgeInsets.zero,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
