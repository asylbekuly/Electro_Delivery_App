import 'package:flutter/material.dart';
import 'package:food_delivery_app/consts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: canPop
            ? IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Theme.of(context).iconTheme.color),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: Text(
          "Profile",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/food-delivery(foodel)/profile_avatar.png',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Rabat Karabek",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "rabat@email.com",
              style: TextStyle(
                fontSize: 16,
                color: textColor?.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.settings, color: textColor),
              title: Text("Settings", style: TextStyle(color: textColor)),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16, color: textColor?.withOpacity(0.6)),
              onTap: () {},
            ),
            Divider(color: Theme.of(context).dividerColor),
            ListTile(
              leading: Icon(Icons.info, color: textColor),
              title: Text("About", style: TextStyle(color: textColor)),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16, color: textColor?.withOpacity(0.6)),
              onTap: () {},
            ),
            Divider(color: Theme.of(context).dividerColor),
            ListTile(
              leading: Icon(Icons.favorite, color: textColor),
              title: Text("Favorites", style: TextStyle(color: textColor)),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16, color: textColor?.withOpacity(0.6)),
              onTap: () {
                Navigator.pushNamed(context, '/favorites');
              },
            ),
            Divider(color: Theme.of(context).dividerColor),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout",
                  style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
