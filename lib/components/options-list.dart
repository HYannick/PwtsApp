import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OptionsList extends StatefulWidget {
  static Color mainBrown = Color.fromRGBO(41, 23, 34, 1.0);
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

  TextStyle titleStyle = TextStyle(
      color: OptionsList.mainBrown, fontSize: 20.0, fontFamily: 'CN Rocks');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 70.0),
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
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedItem = index;
                      });
                      widget.onSelectedItem(
                          _selectedItem, widget.list, widget.field);
                    },
                    child: Container(
                        width: 130.0,
                        height: 130.0,
                        margin: EdgeInsets.only(left: index == 0 ? 70.0 : 0.0),
                        child: Stack(children: <Widget>[
                          Positioned.fill(
                              child: SvgPicture.asset(
                            'assets/splash_brush.svg',
                            fit: BoxFit.cover,
                            color: _selectedItem == index
                                ? Colors.redAccent
                                : OptionsList.mainBrown,
                          )),
                          Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            child: Center(
                                child: Text('${widget.list[index]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontFamily: 'CN Rocks',
                                        fontWeight: FontWeight.bold))),
                          )
                        ])),
                  );
                })),
      ],
    );
  }
}
