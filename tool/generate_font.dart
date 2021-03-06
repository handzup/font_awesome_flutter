import 'dart:convert';
import 'dart:io';

import 'package:recase/recase.dart';

void main(List<String> arguments) {
  var file = new File(arguments.first);

  if (!file.existsSync()) {
    print('Cannot find the file "${arguments.first}".');
  }

  var content = file.readAsStringSync();
  Map<String, dynamic> icons = json.decode(content);

  Map<String, String> iconDefinitions = {};
  Map<String, String> iconStringName = {};

  bool hasDuotone = false;

  for (String iconName in icons.keys) {
    var icon = icons[iconName];
    var unicode = icon['unicode'];
    List<String> styles = (icon['styles'] as List).cast<String>();

    if (styles.length > 1) {
      // if (styles.contains('regular')) {
      //   styles.remove('regular');
      //   var regName = 'far fa-$iconName';
      //   iconDefinitions[iconName] = generateIconDefinition(
      //     iconName,
      //     'regular',
      //     unicode,
      //   );
      //   iconStringName[regName] = generateIconString(regName);
      // }

      if (styles.contains('duotone')) {
        hasDuotone = true;
      }

      for (String style in styles) {
        String name = '${style}_$iconName';
        var regName;
        if (style == 'duotone') {
          regName = 'fad fa-$iconName';
        }
        if (style == 'regular') {
          regName = 'far fa-$iconName';
        }
        if (style == 'light') {
          regName = 'fal fa-$iconName';
        }
        if (style == 'solid') {
          regName = 'fas fa-$iconName';
        }
        if (style == 'brands') {
          regName = 'fab fa-$iconName';
        }

        iconStringName[name] = generateIconString(regName, name);

        iconDefinitions[name] = generateIconDefinition(
          name,
          style,
          unicode,
        );
      }
    } else {
      var regName;
      if (styles.first == 'duotone') {
        regName = 'fad fa-$iconName';
      }
      if (styles.first == 'regular') {
        regName = 'far fa-$iconName';
      }
      if (styles.first == 'light') {
        regName = 'fal fa-$iconName';
      }
      if (styles.first == 'solid') {
        regName = 'fas fa-$iconName';
      }
      if (styles.first == 'brands') {
        regName = 'fab fa-$iconName';
      }
      iconDefinitions[iconName] = generateIconDefinition(
        iconName,
        styles.first,
        unicode,
      );
      iconStringName[iconName] = generateIconString(regName, iconName);
    }
  }

  List<String> generatedOutput = [
    'library font_awesome_flutter;',
    '',
    "import 'package:flutter/widgets.dart';",
    "import 'package:font_awesome_flutter/src/icon_data.dart';",
    "export 'package:font_awesome_flutter/src/fa_icon.dart';",
    "export 'package:font_awesome_flutter/src/icon_data.dart';",
  ];

  if (hasDuotone) {
    generatedOutput
        .add("export 'package:font_awesome_flutter/src/fa_duotone_icon.dart';");
  }

  generatedOutput.addAll([
    '',
    '// THIS FILE IS AUTOMATICALLY GENERATED!',
    '',
    'class FontAwesomeIcons {',
  ]);
  generatedOutput.add('static const getIconString = {');

  generatedOutput.addAll(iconStringName.values);
  generatedOutput.add('};');
  generatedOutput.addAll(iconDefinitions.values);

  generatedOutput.add('}');

  File output = new File('lib/font_awesome_flutter.dart');
  output.writeAsStringSync(generatedOutput.join('\n'));
}

String generateIconString(String iconName, String secondName) {
  if (iconName == '500px') {
    iconName = 'fiveHundredPx';
  }

  secondName = new ReCase(secondName).camelCase;
  return "'$iconName':$secondName,";
}

String generateIconDefinition(String iconName, String style, String unicode) {
  style = '${style[0].toUpperCase()}${style.substring(1)}';

  String iconDataSource = 'IconData$style';

  if (iconName == '500px') {
    iconName = 'fiveHundredPx';
  }

  iconName = new ReCase(iconName).camelCase;

  return 'static const IconData $iconName = const $iconDataSource(0x$unicode);';
}
