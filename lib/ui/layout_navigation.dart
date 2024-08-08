import 'package:badges/badges.dart' as badges; // Import badges package
import 'package:finalproject_sanber/logic/cart_bloc/cart_bloc.dart';
import 'package:finalproject_sanber/logic/order_bloc/order_bloc.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:finalproject_sanber/ui/pages/order_page.dart';
import 'package:finalproject_sanber/ui/pages/inventory_page.dart';
import 'package:finalproject_sanber/ui/pages/profile_page.dart';
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
    const ProfilePage()
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
          final orderCount = state is OrderSuccess ? state.totalOrders : 0;
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/ic_menu_home.png'),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: badges.Badge(
                  badgeContent: Text(
                    orderCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  // ignore: prefer_const_constructors
                  badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
                  child: Image.asset('assets/icons/ic_menu_pesanan.png'),
                ),
                label: 'Order',
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
