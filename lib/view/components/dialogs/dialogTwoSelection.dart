import 'package:flutter/material.dart';
import '../../../constant/ui.dart';

class DialogTwoSelection extends StatefulWidget {
  final String title, descriptions, textConfirm, textCancel;
  final BuildContext dialogContext;
  const DialogTwoSelection({
    Key? key,
    required this.title,
    required this.descriptions,
    required this.textConfirm,required this.textCancel,
    required this.dialogContext
  }) : super(key: key);

  @override
  State<DialogTwoSelection> createState() => _DialogCancelLoadState();
}

class _DialogCancelLoadState extends State<DialogTwoSelection> {
  String? errorText;
  @override
  Widget build(BuildContext context) {
    widget.title.trimRight();
    widget.title.trimLeft();
    return Dialog (
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: const Color.fromARGB(0, 58, 44, 44),
      child: contentBox(context),
    );
  }

  contentBox(context){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: dSpace_8, right: dSpace_8*3,bottom: 0,top: 18),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  SizedBox(height:18,),
                  SizedBox(height:18,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //shadow of Image button on top
  BoxShadow kDefaultShadow = const BoxShadow(
      offset: Offset(0, 5), blurRadius: 10, color: Colors.black12);

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
