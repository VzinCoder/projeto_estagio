import 'package:flutter/material.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  String downloadInfo = 'Carregando...';
  String uploadInfo = 'Carregando...';
  bool isInitialized = false;
  bool _isDownloading = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSyncStatus();
    });
  }

  Future<void> _initializeSyncStatus() async {
    if (!mounted) return;
    await _updateSyncPreviews();
    if (mounted) {
      setState(() => isInitialized = true);
    }
  }

  Future<void> _updateSyncPreviews() async {
    final downloadData = await _fetchDownloadUpdates();
    final uploadData = await _fetchPendingUploads();

    if (!mounted) return;

    setState(() {
      downloadInfo = _formatDownloadInfo(downloadData);
      uploadInfo = _formatUploadInfo(uploadData);
    });
  }

  Future<Map<String, int>> _fetchDownloadUpdates() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'animals': 2, 'events': 4, 'vaccines': 1};
  }

  Future<Map<String, int>> _fetchPendingUploads() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'animals': 3, 'events': 5, 'vaccines': 2};
  }

  String _formatDownloadInfo(Map<String, int> data) {
    if (data.isEmpty) return 'Nenhuma atualização disponível';
    return '${data['animals']} animais\n${data['events']} eventos\n${data['vaccines']} vacinas';
  }

  String _formatUploadInfo(Map<String, int> data) {
    if (data.isEmpty) return 'Todos os dados sincronizados';
    return '${data['animals']} animais\n${data['events']} eventos\n${data['vaccines']} vacinas';
  }

  Future<void> _startDownload() async {
    if (_isDownloading) return;

    setState(() => _isDownloading = true);
    _showLoadingDialog("Sincronizando dados do servidor...");

    try {
      await _performDownload();
      await _updateSyncPreviews();
      if (mounted) _showSnackBar('Dados sincronizados com sucesso!');
    } catch (e) {
      if (mounted) _showSnackBar('Erro na sincronização: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _performDownload() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _startUpload() async {
    if (_isUploading) return;

    setState(() => _isUploading = true);
    _showLoadingDialog("Enviando dados para o servidor...");

    try {
      await _performUpload();
      await _updateSyncPreviews();
      if (mounted) _showSnackBar('Dados enviados com sucesso!');
    } catch (e) {
      if (mounted) _showSnackBar('Erro no envio: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _performUpload() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(
                child: Text(message, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getInactiveColor(Color baseColor) {
    return Color.lerp(baseColor, Colors.grey, 0.4) ?? baseColor;
  }

  Widget _buildSyncCard({
    required IconData icon,
    required String title,
    required String info,
    required VoidCallback onTap,
    required Color color,
    required bool isActive,
  }) {

    final cardColor = isActive ? color : _getInactiveColor(color);
    final iconColor = isActive ? Colors.white : Colors.white70;
    return InkWell(
      onTap: isActive ? onTap : null,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 48, color: iconColor),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:  TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      info,
                      style:  TextStyle(fontSize: 16, color: iconColor),
                    ),
                  ],
                ),
              ),
               Icon(
                isActive ? Icons.refresh : Icons.check,
                color: iconColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sincronização",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isInitialized
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildSyncCard(
                    icon: Icons.download,
                    title: 'Baixar dados do servidor',
                    info: downloadInfo,
                    onTap: _startDownload,
                    color: Colors.blueAccent,
                    isActive: downloadInfo != 'Nenhuma atualização disponível',
                  ),
                  const SizedBox(height: 24),
                  _buildSyncCard(
                    icon: Icons.upload,
                    title: 'Enviar dados ao servidor',
                    info: uploadInfo,
                    onTap: _startUpload,
                    color: Colors.green,
                    isActive: uploadInfo != 'Todos os dados sincronizados',
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
