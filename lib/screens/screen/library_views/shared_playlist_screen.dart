import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Bloomee/core/theme/app_theme.dart';
import 'package:Bloomee/services/supabase_playlist_service.dart';
import 'package:Bloomee/core/models/exported.dart' hide MediaItem;
import 'package:Bloomee/screens/widgets/song_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Bloomee/blocs/media_player/bloomee_player_cubit.dart';
import 'package:Bloomee/main.dart'; // for bloomeePlayerCubit
import 'package:iconsx_plus/iconsx_plus.dart';

class SharedPlaylistScreen extends StatelessWidget {
  final String playlistCode;
  final String playlistTitle;
  
  const SharedPlaylistScreen({
    Key? key,
    required this.playlistCode,
    this.playlistTitle = 'Playlist Bersama',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Default_Theme.themeColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Default_Theme.primaryColor1),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              playlistTitle,
              style: const TextStyle(
                color: Default_Theme.primaryColor1,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Kode: $playlistCode',
              style: TextStyle(
                color: Default_Theme.primaryColor2.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(MingCute.play_fill, color: Default_Theme.accentColor2),
            onPressed: () {
              // We'll implement "Play All" logic here later
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: SupabasePlaylistService.streamPlaylist(playlistCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Default_Theme.accentColor2));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan.', style: TextStyle(color: Default_Theme.primaryColor2)),
            );
          }
          
          final rawSongs = snapshot.data ?? [];
          final tracks = rawSongs.map((s) => mapToTrack(s)).toList();

          if (tracks.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada lagu di playlist ini.\nTambahkan lagu pertama Anda!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return SongCardWidget(
                song: track,
                onTap: () {
                  context.read<BloomeePlayerCubit>().bloomeePlayer.updateQueueTracks(tracks, doPlay: true, startIndex: index);
                },
              );
            },
          );
        },
      ),
    );
  }
}
