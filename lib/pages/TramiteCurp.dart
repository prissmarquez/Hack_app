import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Tramitecurp extends StatefulWidget {
  const Tramitecurp({super.key});

  @override
  State<Tramitecurp> createState() => _TramitecurpState();
}

class _TramitecurpState extends State<Tramitecurp> {
  late final YoutubePlayerController _yt;
  late final WebViewController _web;

  final Uri curpUrl = Uri.parse('https://www.gob.mx/curp/');

  @override
  void initState() {
    super.initState();

    _yt = YoutubePlayerController.fromVideoId(
      videoId: 'V0VNy-zStMI',
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );

    _web = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            debugPrint("Web error: ${error.description}");
          },
        ),
      )
      ..loadRequest(curpUrl);
  }

  @override
  void dispose() {
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trámite: CURP'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.ondemand_video), text: 'Video'),
              Tab(icon: Icon(Icons.public), text: 'Página'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: Video
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text(
                    'Tutorial para consultar/imprimir tu CURP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(
                      controller: _yt,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tip: Ten a la mano tu nombre completo, fecha de nacimiento y entidad.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // TAB 2: Página oficial
            WebViewWidget(controller: _web),
          ],
        ),
      ),
    );
  }
}