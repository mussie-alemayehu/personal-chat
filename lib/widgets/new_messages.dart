import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
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
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {},
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
                await actions.Actions.sendMessges(
                  chatId: widget.chatId,
                  message: message,
                  sentBy: widget.senderId,
                );
              },
            ),
        ],
      ),
    );
  }
}
