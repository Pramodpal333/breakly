import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  String _version = '';
  String _buildNumber = '';

  Future<void> init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
  }

  String get appVersion => 'v$_version';
  String get fullVersion => 'v$_version+$_buildNumber';
}
