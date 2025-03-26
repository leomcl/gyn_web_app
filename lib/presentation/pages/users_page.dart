import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snow_stats_app/domain/entities/user.dart';
import 'package:snow_stats_app/presentation/cubit/users/users_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/users/users_state.dart';
import 'package:snow_stats_app/presentation/cubit/user_details/user_details_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/user_details/user_details_state.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _loadingStates = {};
  String _currentFilter = 'All'; // Track current filter

  // Define filter options
  final List<String> _filterOptions = [
    'All',
    'Premium',
    'Basic',
    'Inactive Premium'
  ];

  @override
  void initState() {
    super.initState();
    // Load users when page initializes
    context.read<UsersCubit>().loadUsers();

    // Setup search listener
    _searchController.addListener(() {
      _applyFilters(); // Call our new method instead
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Users',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _currentFilter,
                      items: _filterOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _currentFilter = newValue;
                          });
                          _applyFilters();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                if (state is UsersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UsersError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is UsersLoaded) {
                  return _buildUsersTable(state.users);
                } else {
                  return const Center(child: Text('No users available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTable(List<User> users) {
    return Card(
      child: ListView(
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Role')),
              DataColumn(label: Text('Membership')),
              DataColumn(label: Text('Status')),
            ],
            rows: users.map((user) {
              // Simple check for warning icon - premium user with no workout in 30+ days
              bool showWarning = user.membershipStatus &&
                  (user.lastWorkoutDate == null ||
                      user.lastWorkoutDate!.isBefore(
                          DateTime.now().subtract(const Duration(days: 30))));

              return DataRow(
                onSelectChanged: (selected) {
                  if (selected ?? false) {
                    _showUserDetailsDialog(context, user);
                  }
                },
                cells: [
                  DataCell(Text(user.email)),
                  DataCell(Text(user.role ?? 'User')),
                  DataCell(Text(user.membershipStatus ? 'Premium' : 'Basic')),
                  // Simple status cell with warning icon
                  DataCell(
                    showWarning
                        ? const Tooltip(
                            message: 'Premium member inactive for 30+ days',
                            child: Icon(Icons.warning_amber_rounded,
                                color: Colors.amber),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context, User user) {
    // Load user details when dialog is opened
    context.read<UserDetailsCubit>().loadUserDetails(user.uid);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Set a wider width with constraints
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.7, // 70% of screen width
            constraints: BoxConstraints(
              maxWidth: 800, // Maximum width in pixels
              minWidth: 400, // Minimum width in pixels
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
                    builder: (context, state) {
                      if (state is UserDetailsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is UserDetailsError) {
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      } else if (state is UserDetailsLoaded) {
                        final details = state.userDetails;
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('Email'),
                                subtitle: Text(details.email),
                              ),
                              ListTile(
                                title: const Text('Role'),
                                subtitle: Text(details.role ?? 'User'),
                              ),
                              ListTile(
                                title: const Text('Membership'),
                                subtitle: Text(details.membershipStatus
                                    ? 'Premium'
                                    : 'Basic'),
                              ),
                              ListTile(
                                  title: const Text('Last Workout'),
                                  subtitle: Text(details.lastWorkoutDate != null
                                      ? details.lastWorkoutDate!
                                          .toString()
                                          .split(
                                              ' ')[0] // Show only the date part
                                      : 'No workout yet')),
                              if (details.preferredDays.isNotEmpty)
                                ExpansionTile(
                                  title: const Text('Preferred Days'),
                                  initiallyExpanded: true,
                                  children:
                                      details.preferredDays.map((dayIndex) {
                                    final days = [
                                      'Monday',
                                      'Tuesday',
                                      'Wednesday',
                                      'Thursday',
                                      'Friday',
                                      'Saturday',
                                      'Sunday'
                                    ];
                                    return ListTile(
                                      title: Text(days[dayIndex]),
                                    );
                                  }).toList(),
                                ),
                              if (details.preferredWorkouts.isNotEmpty)
                                ExpansionTile(
                                  title: const Text('Preferred Workouts'),
                                  initiallyExpanded: true,
                                  children: details.preferredWorkouts
                                      .map((workout) => ListTile(
                                            title: Text(workout),
                                          ))
                                      .toList(),
                                ),
                            ],
                          ),
                        );
                      }
                      return const Center(
                        child: Text('No details available'),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Clear user details state when dialog is closed
                        context.read<UserDetailsCubit>().clearUserDetails();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add this method to handle filter application
  void _applyFilters() {
    final String searchQuery = _searchController.text;
    context.read<UsersCubit>().filterUsers(searchQuery, _currentFilter);
  }
}
