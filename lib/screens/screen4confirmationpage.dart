import 'package:flutter/material.dart';
class Screen4ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 360,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 16,
                top: 672,
                child: Container(
                  width: 329,
                  height: 60,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 107,
                        top: 21,
                        child: Text(
                          'I want to donate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 564,
                child: SizedBox(
                  width: 304,
                  height: 13,
                  child: Text(
                    'St. Thomas Hospital Chethipuzzha',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 586,
                child: SizedBox(
                  width: 312,
                  height: 32,
                  child: Opacity(
                    opacity: 0.50,
                    child: Text(
                      'Chethipuzha Kurussummoodu P O, Changanassery, Kerala 686104',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 146,
                top: 526,
                child: SizedBox(
                  width: 59,
                  height: 11,
                  child: Text(
                    'Emergency',
                    style: TextStyle(
                      color: Color(0xFFD93035),
                      fontSize: 12,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 92,
                child: Text(
                  'Confirmation',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 53,
                top: 56,
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 53,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/26x26"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 19,
                top: 190,
                child: Container(
                  width: 323,
                  height: 316,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/323x316"),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0xFFCE688F),
                        blurRadius: 250,
                        offset: Offset(0, 0),
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}