import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/emergency_provider.dart';
import '../emergency/request_screen.dart';
import '../emergency/tracking_screen.dart';
import '../hospitals/hospital_screen.dart';
import '../driver/driver_dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emergencyProvider = Provider.of<EmergencyProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // ── Sliver AppBar ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Good day 👋',
                                  style: TextStyle(
                                    color: AppColors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Emergency Dashboard',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .logout();
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.logout_rounded,
                                  color: AppColors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats Row ──────────────────────────────────────
                  Row(
                    children: [
                      _StatCard(
                        label: 'Active\nRequests',
                        value:
                            '${emergencyProvider.requests.where((r) => r.severity == 'Critical').length}',
                        icon: Icons.emergency_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        label: 'Total\nDispatched',
                        value: '${emergencyProvider.requests.length}',
                        icon: Icons.local_shipping_rounded,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 12),
                      const _StatCard(
                        label: 'Hospitals\nNearby',
                        value: '5',
                        icon: Icons.local_hospital_rounded,
                        color: AppColors.warning,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── SOS Button ────────────────────────────────────
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RequestScreen()),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.45),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.emergency_share_rounded,
                              color: AppColors.white, size: 44),
                          SizedBox(height: 10),
                          Text(
                            'SOS — Request Ambulance',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tap to dispatch nearest ambulance',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Quick Actions ─────────────────────────────────
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 14),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.25,
                    children: [
                      _ActionCard(
                        icon: Icons.map_rounded,
                        label: 'Live Tracking',
                        subtitle: 'Track ambulance',
                        color: const Color(0xFF1565C0),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TrackingScreen()),
                        ),
                      ),
                      _ActionCard(
                        icon: Icons.local_hospital_rounded,
                        label: 'Hospitals',
                        subtitle: 'Find nearby',
                        color: const Color(0xFF2E7D32),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HospitalScreen()),
                        ),
                      ),
                      _ActionCard(
                        icon: Icons.drive_eta_rounded,
                        label: 'Driver Mode',
                        subtitle: 'Accept requests',
                        color: const Color(0xFFE65100),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DriverDashboard()),
                        ),
                      ),
                      _ActionCard(
                        icon: Icons.history_rounded,
                        label: 'History',
                        subtitle: 'Past requests',
                        color: const Color(0xFF6A1B9A),
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Recent Requests ───────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Requests',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.charcoal,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All',
                            style: TextStyle(color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  emergencyProvider.requests.isEmpty
                      ? _EmptyState()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: emergencyProvider.requests.length,
                          itemBuilder: (context, index) {
                            final req =
                                emergencyProvider.requests[index];
                            return _RequestTile(
                              name: req.patientName,
                              type: req.emergencyType,
                              severity: req.severity,
                            );
                          },
                        ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Card ──────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.grey, height: 1.3)),
          ],
        ),
      ),
    );
  }
}

// ── Action Card ────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14,
                    color: AppColors.charcoal)),
            Text(subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.grey)),
          ],
        ),
      ),
    );
  }
}

// ── Request Tile ───────────────────────────────────────────────────────────
class _RequestTile extends StatelessWidget {
  final String name, type, severity;
  const _RequestTile(
      {required this.name, required this.type, required this.severity});

  Color get _severityColor {
    switch (severity) {
      case 'Critical': return AppColors.primary;
      case 'Moderate': return AppColors.warning;
      default:         return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _severityColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.personal_injury_rounded,
                color: _severityColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.charcoal)),
                Text(type,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _severityColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(severity,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _severityColor)),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: AppColors.grey),
          SizedBox(height: 10),
          Text('No requests yet',
              style: TextStyle(color: AppColors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}