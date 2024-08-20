import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoadingDialog extends StatefulWidget 
{
  String massagetext;



  LoadingDialog({
    super.key,required this.massagetext,});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.black45,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
          margin: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [


                const SizedBox(width: 7),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),


                const SizedBox(width: 8),


                Flexible(
                  child: Text(
                    widget.massagetext,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  ),
              ],
        ),
          ),
        ),
      ),
      );
  }
}
