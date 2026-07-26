import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Bloomee/core/models/exported.dart' hide MediaItem;

import 'package:Bloomee/core/models/exported.dart' hide MediaItem;

Map<String, dynamic> trackToMap(Track track) {
  return {
    'id': track.id,
    'title': track.title,
    'artist': track.artists.isNotEmpty ? track.artists.first.name : '',
    'thumbnailUrl': track.thumbnail.url,
    'durationMs': track.durationMs?.toInt(),
  };
}

Track mapToTrack(Map<String, dynamic> map) {
  return Track(
    id: map['id'] ?? '',
    title: map['title'] ?? '',
    artists: [ArtistSummary(id: '', name: map['artist'] ?? '')],
    thumbnail: Artwork(url: map['thumbnailUrl'] ?? '', layout: ImageLayout.square),
    durationMs: map['durationMs'] != null ? BigInt.from(map['durationMs']) : null,
    isExplicit: false,
  );
}

class SupabasePlaylistService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _table = 'shared_playlists';

  /// Create a new shared playlist and get its unique code
  static Future<String?> createSharedPlaylist(String title, List<Track> initialSongs) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Must be logged in');

    // Generate a simple 6-character alphanumeric code
    final code = _generateCode();
    
    final songsJson = initialSongs.map((t) => trackToMap(t)).toList();

    try {
      await _supabase.from(_table).insert({
        'code': code,
        'title': title,
        'owner_id': user.id,
        'members': [user.id],
        'songs': songsJson,
      });
      return code;
    } catch (e) {
      print('Error creating shared playlist: $e');
      rethrow;
    }
  }

  /// Join an existing shared playlist by code
  static Future<bool> joinPlaylist(String code) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Must be logged in');

    try {
      final response = await _supabase.from(_table).select().eq('code', code).maybeSingle();
      if (response == null) return false;

      List<dynamic> members = response['members'] ?? [];
      if (!members.contains(user.id)) {
        members.add(user.id);
        await _supabase.from(_table).update({'members': members}).eq('code', code);
      }
      return true;
    } catch (e) {
      print('Error joining playlist: $e');
      return false;
    }
  }

  /// Stream a shared playlist (Realtime updates!)
  static Stream<List<Map<String, dynamic>>> streamPlaylist(String code) {
    return _supabase
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('code', code)
        .map((maps) {
          if (maps.isEmpty) return [];
          final data = maps.first;
          final List<dynamic> rawSongs = data['songs'] ?? [];
          return rawSongs.cast<Map<String, dynamic>>();
        });
  }

  /// Add a song to the shared playlist
  static Future<void> addSongToPlaylist(String code, Track track) async {
    try {
      final response = await _supabase.from(_table).select().eq('code', code).maybeSingle();
      if (response == null) return;

      List<dynamic> currentSongs = response['songs'] ?? [];
      // Prevent exact duplicates based on videoId or id
      if (!currentSongs.any((s) => s['id'] == track.id)) {
        currentSongs.add(trackToMap(track));
        
        await _supabase.from(_table).update({'songs': currentSongs}).eq('code', code);
      }
    } catch (e) {
      print('Error adding song to playlist: $e');
    }
  }

  static String _generateCode() {
    return DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase().substring(3, 9);
  }
}
