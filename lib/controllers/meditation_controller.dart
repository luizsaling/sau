import '../services/youtube_service.dart';

class MeditationController {
  final YouTubeService youtubeService;

  MeditationController({required this.youtubeService});

  String getGuidedMeditationVideoUrl() {
    return youtubeService.videoUrl;
  }
}
