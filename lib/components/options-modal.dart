import 'package:flutter/material.dart';
import 'package:pwts_app/abstracts.dart';

class OptionsModal extends StatefulWidget {
  WingChunStyle style;
  bool enableThemeSong;
  String lang;
  final Function updateOptions;

  OptionsModal(
      {this.enableThemeSong, this.style, this.lang, this.updateOptions});

  @override
  OptionsModalState createState() {
    return OptionsModalState();
  }
}

class OptionsModalState extends State<OptionsModal> {
  void _enableThemeOpts(bool value) async {
    setState(() {
      widget.enableThemeSong = value;
    });
    widget.updateOptions(
        style: widget.style,
        enableThemeSong: widget.enableThemeSong,
        audioStyle: widget.lang);
  }

  void changeWCStyle(WingChunStyle value) {
    setState(() {
      widget.style = value;
    });
    widget.updateOptions(
        style: widget.style,
        enableThemeSong: widget.enableThemeSong,
        audioStyle: widget.lang);
  }

  void changeAudioStyle(String value) {
    setState(() {
      widget.lang = value;
    });
    widget.updateOptions(
        style: widget.style,
        enableThemeSong: widget.enableThemeSong,
        audioStyle: widget.lang);
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
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Style de réactions',
                  style: TextStyle(
                      fontFamily: familyMain, color: mainRed, fontSize: 16.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Sifu Style', style: TextStyle(fontFamily: familyMain)),
                  Radio<WingChunStyle>(
                    value: WingChunStyle.sifu,
                    groupValue: widget.style,
                    activeColor: mainRed,
                    onChanged: changeWCStyle,
                  ),
                  Text('Dai Sihing Style',
                      style: TextStyle(fontFamily: familyMain)),
                  Radio<WingChunStyle>(
                    value: WingChunStyle.daisihing,
                    groupValue: widget.style,
                    activeColor: mainRed,
                    onChanged: changeWCStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Style Audio',
                  style: TextStyle(
                      fontFamily: familyMain, color: mainRed, fontSize: 16.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Français', style: TextStyle(fontFamily: familyMain)),
                  Radio<String>(
                    value: 'french',
                    groupValue: widget.lang,
                    activeColor: mainRed,
                    onChanged: changeAudioStyle,
                  ),
                  Text('Cantonais', style: TextStyle(fontFamily: familyMain)),
                  Radio<String>(
                    value: 'cantonese',
                    groupValue: widget.lang,
                    activeColor: mainRed,
                    onChanged: changeAudioStyle,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
