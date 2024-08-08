import 'package:finalproject_sanber/logic/cart_bloc/cart_bloc.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:finalproject_sanber/ui/pages/cart_page.dart';
import 'package:finalproject_sanber/ui/pages/inventory_page.dart';
import 'package:finalproject_sanber/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';


class LayoutNavigation extends StatefulWidget {
  const LayoutNavigation({super.key});

  @override
  State<LayoutNavigation> createState() => _LayoutNavigationState();
}

class _LayoutNavigationState extends State<LayoutNavigation> {
  int currentIndex = 0;
  List<Widget> page = [
    const InventoryPage(),
    const CartPage(),
    const ProfilePage()
  ];
  @override
  void initState() {
    super.initState();
    // context.read<UserBloc>().add(UserGetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final countCart = context.watch<CartBloc>();
    return Scaffold(
      body: page[currentIndex],
      backgroundColor: whiteColor,
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Badge(
              label: Text(countCart.state.cartItems.length.toString()),
              child: Image.asset('assets/icons/ic_menu_pesanan.png'),
            ),
            label: 'Order',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_outlined),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
