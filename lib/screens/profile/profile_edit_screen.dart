import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/media/media_picker_service.dart';
import '../../core/network/api_exception.dart';
import '../../core/utils/error_messages.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/network_image_x.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _submitting = false;
  bool _uploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _submitting = true);
    try {
      await context.read<AuthProvider>().updateProfile(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
          );
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorMessages.from(context, e))));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _pickAvatar(MediaSource source) async {
    final mediaPicker = context.read<MediaPickerService>();
    final file = await mediaPicker.pickAvatar(source: source);
    if (file == null || !mounted) return;

    final size = await mediaPicker.fileSizeBytes(file);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    if (size > AppSizes.maxAvatarSizeBytes) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorFileTooLarge)));
      return;
    }

    setState(() => _uploadingAvatar = true);
    try {
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      await context.read<AuthProvider>().uploadAvatar(
            bytes: bytes,
            filename: file.name,
            mimeSubtype: _mimeSubtype(file.name),
          );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorMessages.from(context, e))));
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  String _mimeSubtype(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return switch (ext) {
      'png' => 'png',
      'webp' => 'webp',
      _ => 'jpeg',
    };
  }

  void _showPhotoSheet() {
    final mediaPicker = context.read<MediaPickerService>();
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(mediaPicker.isCameraSupported ? l10n.profileChoosePhotoGallery : l10n.profileChoosePhotoFile),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _pickAvatar(MediaSource.gallery);
              },
            ),
            if (mediaPicker.isCameraSupported)
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.profileChoosePhotoCamera),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickAvatar(MediaSource.camera);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileEditTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                NetworkImageX(url: user?.avatarUrl, width: 96, height: 96, borderRadius: BorderRadius.circular(48)),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Semantics(
                    button: true,
                    label: AppLocalizations.of(context).profileChangePhoto,
                    child: GestureDetector(
                      onTap: _uploadingAvatar ? null : _showPhotoSheet,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: _uploadingAvatar
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: _uploadingAvatar ? null : _showPhotoSheet, child: Text(l10n.profileChangePhoto)),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.profileName, prefixIcon: const Icon(Icons.person_outline_rounded)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: l10n.profilePhone, prefixIcon: const Icon(Icons.phone_outlined)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user?.email,
              enabled: false,
              decoration: InputDecoration(labelText: l10n.profileEmail, prefixIcon: const Icon(Icons.alternate_email_rounded)),
            ),
            const SizedBox(height: 24),
            AppButton(label: l10n.commonSave, onPressed: _save, loading: _submitting),
          ],
        ),
      ),
    );
  }
}
