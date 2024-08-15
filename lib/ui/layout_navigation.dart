import 'package:finalproject_sanber/logic/order_bloc/order_bloc.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:finalproject_sanber/ui/pages/order_page.dart';
import 'package:finalproject_sanber/ui/pages/inventory_page.dart';
import 'package:finalproject_sanber/ui/pages/profile_page.dart';
import 'package:finalproject_sanber/ui/pages/report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutNavigation extends StatefulWidget {
  const LayoutNavigation({super.key});

  @override
  State<LayoutNavigation> createState() => _LayoutNavigationState();
}

class _LayoutNavigationState extends State<LayoutNavigation> {
  int currentIndex = 0;
  List<Widget> page = [
    const InventoryPage(),
    const OrderPage(),
    ReportPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // context.read<UserBloc>().add(UserGetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[currentIndex],
      backgroundColor: whiteColor,
      bottomNavigationBar: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return BottomNavigationBar(
            backgroundColor: blueColor,
            fixedColor: whiteColor,
            unselectedItemColor: whiteColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                label: 'Order',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.report_outlined),
                label: 'Report',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.people_outline_outlined),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}