import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/messages.dart';
import '../components/actions.dart' as actions;

class NewMessageSender extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String chatId;
  const NewMessageSender({
    super.key,
    required this.receiverId,
    required this.senderId,
    required this.chatId,
  });

  @override
  State<NewMessageSender> createState() => _NewMessageSenderState();
}

class _NewMessageSenderState extends State<NewMessageSender> {
  final _controller = TextEditingController();
  var _isSendable = false;
  late ScaffoldMessengerState scaffoldMessenger;
  late ThemeData theme;

  Future<File?> _getImage() async {
    final pickedXImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (pickedXImage == null) {
      return null;
    }
    final pickedImage = File(pickedXImage.path);
    return pickedImage;
  }

  Future<bool?> _confirmMessage(File image) async {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    var answer = await showDialog(
      context: context,
      builder: (ctx) {
        final navigator = Navigator.of(ctx);
        return SingleChildScrollView(
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(3),
            iconPadding: const EdgeInsets.all(3),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            icon: Container(
              color: Colors.transparent,
              constraints: BoxConstraints(
                maxHeight: mediaQuery.size.height * 0.7,
                maxWidth: mediaQuery.size.width * 0.8,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                child: Image.file(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            content: Material(
              child: TextFormField(
                controller: _controller,
                cursorColor: theme.primaryColor,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: theme.textTheme.bodyMedium,
                  enabledBorder: const UnderlineInputBorder(),
                  focusedBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    borderSide: BorderSide(
                      width: 5,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                onPressed: () {
                  navigator.pop(false);
                },
              ),
              TextButton(
                child: Text(
                  'Send',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                onPressed: () {
                  navigator.pop(true);
                },
              ),
            ],
          ),
        );
      },
    );
    answer = answer as bool? ?? false;
    return answer;
  }

  SnackBar _snackBarBuilder(String message) {
    return SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(
        message,
        style: theme.textTheme.bodySmall!.copyWith(color: Colors.white),
      ),
      backgroundColor: theme.colorScheme.error,
    );
  }

  Future<void> _sendImage() async {
    String url;
    String? message;
    final image = await _getImage();

    if (image != null) {
      final send = await _confirmMessage(image);
      message = _controller.text;
      _controller.text = '';
      if (send != null && send) {
        final imageName =
            '${widget.senderId}_${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
        final ref = FirebaseStorage.instance
            .ref('chats_files/${widget.chatId}/$imageName');
        try {
          await ref.putFile(image).timeout(
                const Duration(seconds: 10),
              );
        } catch (error) {
          scaffoldMessenger.showSnackBar(
            _snackBarBuilder('Error while uploading file.'),
          );
          return;
        }
        try {
          url = await ref.getDownloadURL();
        } catch (error) {
          scaffoldMessenger.showSnackBar(
            _snackBarBuilder('Error while fetching download url.'),
          );
          return;
        }
        try {
          await actions.Actions.sendMessages(
            Message(
              sentBy: widget.senderId,
              time: DateTime.now(),
              image: url,
              text: message,
            ),
            widget.chatId,
          );
        } catch (error) {
          scaffoldMessenger.showSnackBar(
            _snackBarBuilder('Error while sending message.'),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    theme = Theme.of(context);

    var inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      hintText: 'Message',
      hintStyle: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: Colors.white30),
      suffixIcon: _isSendable
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () async {
                    await _sendImage();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {},
                ),
              ],
            ),
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      border: InputBorder.none,
    );

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
              decoration: inputDecoration,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _isSendable = false;
                  });
                } else if (value.length == 1) {
                  setState(() {
                    _isSendable = true;
                  });
                }
              },
              minLines: 1,
              maxLines: 4,
            ),
          ),
          if (_isSendable)
            IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white54,
              onPressed: () async {
                final message = _controller.text;
                _controller.text = '';
                setState(() {
                  _isSendable = false;
                });
                await actions.Actions.sendMessages(
                  Message(
                    sentBy: widget.senderId,
                    time: DateTime.now(),
                    text: message,
                  ),
                  widget.chatId,
                );
              },
            ),
        ],
      ),
    );
  }
}
