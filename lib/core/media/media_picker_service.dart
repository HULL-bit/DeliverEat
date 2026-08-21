import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:image_picker/image_picker.dart';

/// Source d'où choisir une image (galerie, appareil photo, ou sélecteur de
/// fichier sur desktop).
enum MediaSource { gallery, camera }

/// Service d'accès aux médias, conscient de la plateforme.
///
/// Centralise le seul point de l'app qui teste `Platform.isX` : les
/// écrans ne font jamais ce test eux-mêmes, ils interrogent
/// [isCameraSupported] et appellent [pickAvatar].
///
/// - Android / iOS : galerie et appareil photo via `image_picker`.
/// - Linux desktop : sélection de fichier via `file_selector` (pas de
///   caméra disponible).
class MediaPickerService {
  MediaPickerService({ImagePicker? imagePicker}) : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  static const _extensions = ['jpg', 'jpeg', 'png', 'webp'];

  /// Le bouton "Appareil photo" ne doit être affiché que si cette valeur
  /// est vraie (Android/iOS uniquement).
  bool get isCameraSupported => !_isDesktop && (Platform.isAndroid || Platform.isIOS);

  bool get _isDesktop => Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  /// Sélectionne une image adaptée à la plateforme courante.
  /// Retourne `null` si l'utilisateur annule.
  Future<XFile?> pickAvatar({MediaSource source = MediaSource.gallery}) {
    if (_isDesktop) return _pickViaFileSelector();
    return _imagePicker.pickImage(
      source: source == MediaSource.camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
  }

  Future<XFile?> _pickViaFileSelector() async {
    const typeGroup = XTypeGroup(label: 'images', extensions: _extensions);
    return openFile(acceptedTypeGroups: const [typeGroup]);
  }

  Future<int> fileSizeBytes(XFile file) => file.length();
}
