import 'package:get_it/get_it.dart';
import 'package:project2/services/theme_service.dart';
import 'package:project2/themes/base_theme.dart';
import 'package:project2/utilities/stream_data.dart';

class SettingsDialogController {
  final ThemeService _themeService = GetIt.I.get<ThemeService>();

  ThemeStatus get themeStatus => _themeService.themeStatus;

  late final StreamData<ThemeColors> selectedColor;

  SettingsDialogController() {
    selectedColor = StreamData(initialValue: _themeService.themeColor);
  }

  void changeThemeStatus(int newValue) {
    _themeService.updateThemeStatus(ThemeStatus.values[newValue]);
  }

  void changeThemeColor(ThemeColors newColor) {
    selectedColor.add(newColor);
    _themeService.updateThemeColor(newColor);
  }

  void dispose() {
    selectedColor.close();
  }
}
