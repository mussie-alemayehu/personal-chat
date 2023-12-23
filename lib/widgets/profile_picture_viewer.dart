import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePictureViewer extends StatefulWidget {
  final File? pickedImage;
  final Function imagePicker;
  const ProfilePictureViewer({
    this.pickedImage,
    required this.imagePicker,
    super.key,
  });

  @override
  State<ProfilePictureViewer> createState() => _ProfilePictureViewerState();
}

class _ProfilePictureViewerState extends State<ProfilePictureViewer> {
  @override
  Widget build(BuildContext context) {
    const containerDimension = 80.0;
    const borderRadius = BorderRadius.only(
      bottomRight: Radius.circular(containerDimension / 2),
      bottomLeft: Radius.circular(containerDimension / 2),
      topRight: Radius.circular(containerDimension / 2),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: containerDimension,
          width: containerDimension,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: widget.pickedImage == null
                ? null
                : Image.file(
                    widget.pickedImage!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(width: 10),
        TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          icon: const Icon(Icons.camera),
          label: const Text('Pick Image'),
          onPressed: () async {
            await widget.imagePicker();
          },
        ),
      ],
    );
  }
}
