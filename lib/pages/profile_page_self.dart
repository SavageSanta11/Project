

import 'package:flutter/material.dart';
import 'package:project/pages/home_page.dart';

class ProfilePageSelf extends StatefulWidget {
  static const String route = '/MyProfilePage';
  
  const ProfilePageSelf({Key? key,  }) : super(key: key);

  @override
  _ProfilePageSelfState createState() => _ProfilePageSelfState();
}

class _ProfilePageSelfState extends State<ProfilePageSelf> {
  @override
  Widget build(BuildContext context) {
    Container _createnavBar(double width, double height) {
      return Container(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {
              Navigator.of(context).pushNamed(HomePage.route);
            }, icon: Icon(Icons.arrow_back_ios)),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.alternate_email)),
                IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.settings_outlined))
              ],
            ),
          ],
        ),
      );
    }

    Container _createProfilePic(double width, double height) {
      return Container(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: height / 2,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    'https://i.natgeofe.com/n/6490d605-b11a-4919-963e-f1e6f3c0d4b6/sumatran-tiger-thumbnail-nationalgeographic_1456276.jpg')),
          ],
        ),
      );
    }

    Container _createUserDetails(double width, double height) {
      double fontsize = height / 8;
      return Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tiger',
              style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.bold),
            ),
            Text(
              '@TigerRocks',
              style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  '0 followers',
                  style: TextStyle(
                      fontSize: fontsize, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: width / 4,
                ),
                Text(
                  '0 following',
                  style: TextStyle(
                      fontSize: fontsize, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: height / 4,
            )
          ],
        ),
      );
    }

    Container _createAddOptions(double width, double height) {
      double fontsize = height / 10;
      return Container(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: Text(
                'Add a bio',
                style: TextStyle(fontSize: fontsize),
              ),
              onPressed: () {},
            ),
            Row(
              children: [
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.message),
                    label: Text(
                      'Add Twitter',
                      style: TextStyle(fontSize: fontsize),
                    )),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.message),
                    label: Text(
                      'Add Instagram',
                      style: TextStyle(fontSize: fontsize),
                    )),
              ],
            ),
            Text('Joined 5 September 2021'),
          ],
        ),
      );
    }

    Container _createMemberOf(double width, double height) {
      double fontsize = height / 10;
      return Container(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height / 5,
            ),
            Text('Member Of'),
            SizedBox(
              height: height / 8,
            ),
            TextButton(
              onPressed: () {},
              child: Text('+'),
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(60.0)),
                primary: Colors.grey,
              ),
            )
          ],
        ),
      );
    }

    Widget _buildMobileView(double width, double height) {
      return Material(
        child: Container(
          color: Color(0xfff2f0e4),
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _createnavBar(width, height * 0.1),
                _createProfilePic(width, height * 0.2),
                _createUserDetails(width, height * 0.2),
                _createAddOptions(width, height * 0.2),
                _createMemberOf(width, height * 0.3)
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildDesktopView(double width, double height) {
      return Material(
        child: Container(
          color: Color(0xfff2f0e4),
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: [
                _createnavBar(width, height * 0.1),
                _createProfilePic(width, height * 0.2),
                _createUserDetails(width, height * 0.2),
                _createAddOptions(width, height * 0.2),
                _createMemberOf(width, height * 0.30)
              ],
            ),
          ),
        ),
      );
    }

    Widget profile;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double aspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

    if (aspectRatio >= 1.5) {
      profile = _buildDesktopView(width, height);
    } else {
      profile = _buildMobileView(width, height);
    }

    return Container(
      width: width,
      height: height,
      child: profile,
      
    );
  }
}
