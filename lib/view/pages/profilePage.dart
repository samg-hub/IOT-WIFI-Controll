import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/homeViewModel/homeViewModel.dart';

//this class is using in both of (Edit Profile in home) & (Login Page)
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? birthCheck;
  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, homeVm, child){
          return Scaffold(
            backgroundColor: Colors.white,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,right: 0,top: 0,bottom: 0,
                      child: Column(
                        children: [
                          SizedBox(
                          width: size.width,
                          height: size.height/5,
                        ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        },
      )
    );
  }
}