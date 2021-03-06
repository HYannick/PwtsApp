import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pwts_app/abstracts.dart';

class OptionsList extends StatefulWidget {
  final String title;
  final String field;
  final List list;
  final Function onSelectedItem;

  OptionsList(
      {this.title, this.list, this.field, @required this.onSelectedItem});

  @override
  OptionsListState createState() {
    return new OptionsListState();
  }
}

class OptionsListState extends State<OptionsList> {
  int _selectedItem = 0;

  TextStyle titleStyle =
      TextStyle(color: mainBrown, fontSize: 20.0, fontFamily: familyMain);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 50.0),
          child: Text(
            widget.title,
            style: titleStyle,
          ),
        ),
        Container(
            height: 70.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final bool isSelected = _selectedItem == index;
                  String path = isSelected ? activeBtnSVG : inactiveBtnSVG;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedItem = index;
                      });
                      widget.onSelectedItem(
                          _selectedItem, widget.list, widget.field);
                    },
                    child: Container(
                        width: 120.0,
                        height: 130.0,
                        margin: EdgeInsets.only(left: index == 0 ? 50.0 : 0.0),
                        child: Stack(children: <Widget>[
                          Positioned.fill(
                              child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: cubicEase,
                            switchOutCurve: cubicEase,
                            child: SvgPicture.asset(
                              path,
                              fit: BoxFit.cover,
                              key: ValueKey<String>(path),
                              color: isSelected ? mainRed : mainBrown,
                            ),
                          )),
                          Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            child: Center(
                                child: Text('${widget.list[index]}',
                                    style: TextStyle(
                                        color: mainLight,
                                        fontSize: 20.0,
                                        fontFamily: familyMain,
                                        fontWeight: FontWeight.bold))),
                          )
                        ])),
                  );
                })),
      ],
    );
  }
}
