import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:streambeats/l10n/app_localizations.dart';
import 'package:streambeats/screens/screen/home_views/setting_views/about.dart';
import 'package:streambeats/screens/screen/home_views/setting_views/appui_setting.dart';
import 'package:streambeats/screens/screen/home_views/setting_views/statistics_view.dart';
import 'package:streambeats/screens/screen/home_views/timer_view.dart';
import 'package:streambeats/screens/screen/player_views/equalizer_view.dart';

import 'package:streambeats/screens/widgets/snackbar.dart';

import 'package:streambeats/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeSidebarDrawer extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeSidebarDrawer({
    super.key,
    required this.navigationShell,
  });

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161618),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.diamond_rounded, color: Colors.amber, size: 28),
            SizedBox(width: 10),
            Text(
              'Premium Aktif',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat! Anda adalah pengguna StreamBeats Premium.',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text(
              'Fitur aktif:\n'
              '• Kualitas audio studio (lossless)\n'
              '• Putar musik tanpa iklan\n'
              '• Mode Party Room (Listen Together) tanpa batas\n'
              '• Lirik realtime & download offline cepat',
              style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final nameController = TextEditingController();
    final messageController = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF161618),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Kirim Umpan Balik',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masukan Anda sangat berharga bagi kami untuk mengembangkan StreamBeats.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              // Rating Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? MingCute.star_fill : MingCute.star_line,
                      color: Colors.amber,
                      size: 28,
                    ),
                    onPressed: () => setState(() => rating = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 12),
              // Name input
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Nama Anda (opsional)',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF222225),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Message input
              TextField(
                controller: messageController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Tulis saran, kritik atau laporkan bug...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF222225),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                SnackbarService.showMessage('Terima kasih atas umpan balik Anda!');
              },
              child: const Text('Kirim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161618),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Bagaimana cara memutar lagu?',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Masuk ke menu Cari, lalu cari lagu, artis, atau album. Pastikan plugin pemutar musik sudah aktif di Pengaturan → Plugin.',
                  style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
                ),
                SizedBox(height: 16),
                Text(
                  '2. Cara mengunduh lagu untuk offline?',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Buka daftar lagu, klik tombol tiga titik di sebelah kanan lagu, lalu pilih "Unduh Lagu". Lagu Anda akan tersimpan di menu Offline.',
                  style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
                ),
                SizedBox(height: 16),
                Text(
                  '3. Mengapa tidak bisa memutar musik?',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Periksa koneksi internet Anda atau pastikan plugin repository diatur dengan benar di Pengaturan.',
                  style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    // ignore: deprecated_member_use
    Share.share('Download StreamBeats sekarang! Pemutar musik gratis tanpa iklan: https://streambeats.valoraofficial.workers.dev/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentIdx = navigationShell.currentIndex;

    return Drawer(
      backgroundColor: const Color(0xFF0B0B0C),
      child: SafeArea(
        child: Column(
          children: [
            // User profile section wrapped in StreamBuilder auth listener
            StreamBuilder<AuthState>(
              stream: SupabaseAuthService.authStateChanges,
              builder: (context, snapshot) {
                final user = SupabaseAuthService.currentUser;
                String displayName = 'Guest';
                String subtitle = 'Lovers of good music \uD83D\uDC9C';
                String? avatarUrl;

                if (user != null) {
                  final meta = user.userMetadata ?? {};
                  displayName = meta['full_name'] ?? user.email?.split('@')[0] ?? 'User';
                  avatarUrl = meta['avatar_url'];
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Row(
                    children: [
                      // Circle Avatar
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: avatarUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(avatarUrl),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage('assets/icons/loading.gif'),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: avatarUrl == null
                            ? const Center(
                                child: Icon(Icons.person, color: Colors.white24, size: 28),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      // User Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Premium Badge Pill
                            GestureDetector(
                              onTap: () => _showPremiumDialog(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.diamond_rounded, color: Colors.white, size: 10),
                                    SizedBox(width: 4),
                                    Text(
                                      'Premium >',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Muted divider
            Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),

            // Scrollable Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // --- MENU SECTION ---
                  _buildSectionTitle('MENU'),
                  _buildDrawerItem(
                    label: l10n.navHome,
                    icon: currentIdx == 0 ? MingCute.home_4_fill : MingCute.home_4_line,
                    isSelected: currentIdx == 0,
                    onTap: () {
                      Navigator.pop(context);
                      navigationShell.goBranch(0);
                    },
                  ),
                  _buildDrawerItem(
                    label: l10n.navLibrary,
                    icon: currentIdx == 1 ? MingCute.book_5_fill : MingCute.book_5_line,
                    isSelected: currentIdx == 1,
                    onTap: () {
                      Navigator.pop(context);
                      navigationShell.goBranch(1);
                    },
                  ),
                  _buildDrawerItem(
                    label: l10n.navSearch,
                    icon: currentIdx == 2 ? MingCute.search_2_fill : MingCute.search_2_line,
                    isSelected: currentIdx == 2,
                    onTap: () {
                      Navigator.pop(context);
                      navigationShell.goBranch(2);
                    },
                  ),
                  _buildDrawerItem(
                    label: l10n.navLocal,
                    icon: currentIdx == 3 ? MingCute.music_2_fill : MingCute.music_2_line,
                    isSelected: currentIdx == 3,
                    onTap: () {
                      Navigator.pop(context);
                      navigationShell.goBranch(3);
                    },
                  ),
                  _buildDrawerItem(
                    label: l10n.navOffline,
                    icon: currentIdx == 4 ? MingCute.folder_download_fill : MingCute.folder_download_line,
                    isSelected: currentIdx == 4,
                    showDot: true,
                    onTap: () {
                      Navigator.pop(context);
                      navigationShell.goBranch(4);
                    },
                  ),

                  const SizedBox(height: 16),
                  // --- FITUR SECTION ---
                  _buildSectionTitle('FITUR'),
                  _buildDrawerItem(
                    label: 'Sleep Timer',
                    icon: MingCute.stopwatch_line,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TimerView()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    label: 'Equalizer',
                    icon: Icons.equalizer_rounded,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EqualizerView()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    label: 'Tema',
                    icon: MingCute.palette_line,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AppUISettings()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    label: 'Statistik',
                    icon: Icons.bar_chart_rounded,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StatisticsView()),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  // --- LAINNYA SECTION ---
                  _buildSectionTitle('LAINNYA'),
                  _buildDrawerItem(
                    label: 'Tentang Aplikasi',
                    icon: Icons.info_outline_rounded,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const About()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    label: 'Kirim Umpan Balik',
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {
                      Navigator.pop(context);
                      _showFeedbackDialog(context);
                    },
                  ),
                  _buildDrawerItem(
                    label: 'Bantuan',
                    icon: Icons.help_outline_rounded,
                    onTap: () {
                      Navigator.pop(context);
                      _showHelpDialog(context);
                    },
                  ),
                  _buildDrawerItem(
                    label: 'Bagikan Aplikasi',
                    icon: Icons.share_rounded,
                    onTap: () {
                      Navigator.pop(context);
                      _shareApp();
                    },
                  ),
                ],
              ),
            ),

            // Muted divider
            Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),

            // Footer Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Exit (Keluar) Button
                  GestureDetector(
                    onTap: () {
                      SystemNavigator.pop();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.15),
                          width: 0.8,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(MingCute.exit_line, color: Colors.redAccent, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Keluar',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Version text
                  Text(
                    'DuskCipher v3.2.1+2',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 12, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.35),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isSelected = false,
    bool showDot = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.06) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: showDot
            ? Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF9C27B0),
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }
}
