import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/homeViewModel/homeViewModel.dart';

//this class is using in both of (Edit Profile in home) & (Login Page)
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState(); // new change
}

class _MainPageState extends State<MainPage> {
  String? birthCheck;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: Consumer<HomeViewModel>(
          builder: (context, homeVm, child) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            height: 56,
                            decoration: const BoxDecoration(color: Colors.blue),
                            child: InkWell(
                              onTap: ()async {
                                print("tap");
                                homeVm.sendInputData("data");
                              },
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blueGrey),
                              child: const Center(
                                  child: Text(
                                "send Data",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        )
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
