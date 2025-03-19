import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snow_stats_app/domain/entities/user.dart';
import 'package:snow_stats_app/presentation/cubit/users/users_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/users/users_state.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load users when page initializes
    context.read<UsersCubit>().loadUsers();

    // Setup search listener
    _searchController.addListener(() {
      context.read<UsersCubit>().searchUsers(_searchController.text);
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
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
              DataColumn(label: Text('Actions')),
            ],
            rows: users.map((user) {
              return DataRow(
                cells: [
                  DataCell(Text(user.email)),
                  DataCell(Text(user.role ?? 'User')),
                  DataCell(Text(user.membershipStatus ? 'Premium' : 'Basic')),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Handle edit action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Handle delete action
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
