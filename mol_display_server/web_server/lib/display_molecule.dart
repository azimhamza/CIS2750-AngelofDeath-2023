import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_server/constants.dart';

class RotateImage extends StatefulWidget {
  final String? svgUrl;

  const RotateImage({Key? key, this.svgUrl}) : super(key: key);

  @override
  _RotateImageState createState() => _RotateImageState();
}

class _RotateImageState extends State<RotateImage> {
  double _angle = 0;

  void _rotateImage() {
    setState(() {
      _angle += 45;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
            child: Text(
              "< Click on Molecule to Rotate it >",
              style: TextStyle(color: primaryGrey, fontSize: 20),
            ),
          ),
          Center(
            child: Transform.rotate(
              angle: _angle * 3.14 / 180,
              child: GestureDetector(
                onTap: _rotateImage,
                child: widget.svgUrl != null
                    ? SvgPicture.network(
                        widget.svgUrl!,
                        height: MediaQuery.of(context).size.height - 100,
                        width: MediaQuery.of(context).size.width * 0.7,
                      )
                    : SvgPicture.asset(
                        'assets/images/test_image.svg',
                        height: MediaQuery.of(context).size.height - 100,
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}