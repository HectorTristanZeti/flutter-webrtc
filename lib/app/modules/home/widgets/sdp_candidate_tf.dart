import 'package:flutter/material.dart';

class SdpcandidateTF extends StatelessWidget {
  const SdpcandidateTF({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sdpController = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: sdpController,
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        maxLength: TextField.noMaxLength,
      ),
    );
  }
}