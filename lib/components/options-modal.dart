import 'package:flutter/material.dart';
import 'package:pwts_app/abstracts.dart';

class OptionsModal extends StatefulWidget {
  WingChungStyle style;
  bool enableThemeSong;
  final Function updateOptions;

  OptionsModal({this.enableThemeSong, this.style, this.updateOptions});

  @override
  OptionsModalState createState() {
    return new OptionsModalState();
  }
}

class OptionsModalState extends State<OptionsModal> {
  void _enableThemeOpts(bool value) async {
    setState(() {
      widget.enableThemeSong = value;
    });
    widget.updateOptions(
        style: widget.style, enableThemeSong: widget.enableThemeSong);
  }

  void changeWCStyle(WingChungStyle value) {
    setState(() {
      widget.style = value;
    });
    widget.updateOptions(
        style: widget.style, enableThemeSong: widget.enableThemeSong);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SwitchListTile(
          title: const Text(
            'Musique de fond',
            style: TextStyle(fontFamily: familyMain),
          ),
          subtitle: const Text('S\'active lors de de l\'exercice',
              style: TextStyle(fontFamily: familyMain)),
          value: widget.enableThemeSong,
          activeColor: mainRed,
          onChanged: _enableThemeOpts,
          secondary: const Icon(Icons.music_note),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('Sifu Style', style: TextStyle(fontFamily: familyMain)),
              Radio<WingChungStyle>(
                value: WingChungStyle.sifu,
                groupValue: widget.style,
                onChanged: changeWCStyle,
              ),
              Text('Dai Sihing Style',
                  style: TextStyle(fontFamily: familyMain)),
              Radio<WingChungStyle>(
                value: WingChungStyle.daisihing,
                groupValue: widget.style,
                onChanged: changeWCStyle,
              ),
            ],
          ),
        )
      ],
    );
  }
}