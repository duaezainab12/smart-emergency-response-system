import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  bool _isOnDuty = true;

  final List<Map<String, dynamic>> _requests = [
    {
      'patient': 'Ali Hassan',
      'type': 'Heart Attack',
      'severity': 'Critical',
      'location': 'G-9/4, Islamabad',
      'distance': '1.2 KM',
      'time': '2 min ago',
      'accepted': false,
    },
    {
      'patient': 'Sara Khan',
      'type': 'Accident',
      'severity': 'Moderate',
      'location': 'F-8 Markaz, Islamabad',
      'distance': '3.5 KM',
      'time': '5 min ago',
      'accepted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: const Color(0xFFE65100),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFBF360C), Color(0xFFE65100)],
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
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Driver Mode',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 13)),
                                SizedBox(height: 4),
                                Text('Ahmed (Unit A-12)',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                            // Duty toggle
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _isOnDuty = !_isOnDuty),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _isOnDuty
                                      ? AppColors.success
                                      : Colors.white24,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _isOnDuty ? '● On Duty' : '○ Off Duty',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            leading: const BackButton(color: Colors.white),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats
                  Row(
                    children: [
                      _DriverStat(
                          label: 'Completed',
                          value: '12',
                          icon: Icons.check_circle_rounded,
                          color: AppColors.success),
                      const SizedBox(width: 12),
                      _DriverStat(
                          label: 'Pending',
                          value: '${_requests.where((r) => !(r['accepted'] as bool)).length}',
                          icon: Icons.hourglass_top_rounded,
                          color: AppColors.warning),
                      const SizedBox(width: 12),
                      const _DriverStat(
                          label: 'Rating',
                          value: '4.9',
                          icon: Icons.star_rounded,
                          color: Color(0xFFE65100)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text('Incoming Requests',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.charcoal)),
                  const SizedBox(height: 12),

                  ..._requests.asMap().entries.map((entry) {
                    final index = entry.key;
                    final req   = entry.value;
                    final isAccepted = req['accepted'] as bool;
                    final severityColor = req['severity'] == 'Critical'
                        ? AppColors.primary
                        : AppColors.warning;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: isAccepted
                            ? Border.all(
                                color: AppColors.success, width: 2)
                            : null,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: severityColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(req['severity'] as String,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: severityColor)),
                                ),
                                const Spacer(),
                                Text(req['time'] as String,
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.grey)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(req['patient'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.charcoal)),
                            const SizedBox(height: 3),
                            Text(req['type'] as String,
                                style: const TextStyle(
                                    fontSize: 13, color: AppColors.grey)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    size: 14, color: AppColors.grey),
                                const SizedBox(width: 4),
                                Text(req['location'] as String,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grey)),
                                const Spacer(),
                                Text(req['distance'] as String,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.charcoal)),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: AppColors.grey),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                    ),
                                    child: const Text('Decline',
                                        style: TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 13)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: isAccepted
                                        ? null
                                        : () => setState(() {
                                              _requests[index]
                                                  ['accepted'] = true;
                                            }),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isAccepted
                                          ? AppColors.success
                                          : const Color(0xFFE65100),
                                      shadowColor: const Color(0xFFE65100)
                                          .withOpacity(0.3),
                                      minimumSize: Size.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                    ),
                                    child: Text(
                                        isAccepted ? '✓ Accepted' : 'Accept Request',
                                        style: const TextStyle(fontSize: 13)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const _DriverStat(
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
                color: AppColors.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            Text(label,
                style: const TextStyle(fontSize: 10, color: AppColors.grey)),
          ],
        ),
      ),
    );
  }
}