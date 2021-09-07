
import 'package:flutter/material.dart';
import 'package:project/pages/home_page.dart';


class ProfilePageOther extends StatefulWidget {
  static const String route = '/ProfilePage';
 
  const ProfilePageOther({
    Key? key,
 
  }) : super(key: key);

  @override
  _ProfilePageOtherState createState() => _ProfilePageOtherState();
}

class _ProfilePageOtherState extends State<ProfilePageOther> {
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
            IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          ],
        ),
      );
    }

    Container _createProfilePic(double width, double height) {
      return Container(
        width: width,
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
                radius: height / 2,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1594524952992-0cddcede63dd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y29ja2F0b298ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80')),
            SizedBox(width: width/10,),
            TextButton(
              onPressed: () {},
              child: Text(
                'Follow',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                primary:Color(0xfff2f0e4),
              ),
            ),
            SizedBox(width: width/10,),
            TextButton(
              onPressed: () {},
              child: Text(
                '+',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                primary: Color(0xfff2f0e4),
              ),
            )
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
              'Bird',
              style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.bold),
            ),
            Text(
              '@BirdRocks',
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
            Text('This is my bio. Caw caw.'),
            Row(
              children: [
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.message),
                    label: Text(
                      'BirdMan',
                      style: TextStyle(fontSize: fontsize),
                    )),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.message),
                    label: Text(
                      '@BirdMan',
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
