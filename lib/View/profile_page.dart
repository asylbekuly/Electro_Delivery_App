import 'package:flutter/material.dart';
import 'edit_profile_page.dart'; // не забудь импорт, если в отдельной папке

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Rabat Karabek';
  String email = 'rabat@email.com';

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
            GestureDetector(
              onTap: _navigateToEditProfile,
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'assets/food-delivery(foodel)/me2024.jpg',
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _navigateToEditProfile,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
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

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          initialName: name,
          initialEmail: email,
        ),
      ),
    );
    if (result is Map) {
      setState(() {
        name = result['name'] ?? name;
        email = result['email'] ?? email;
      });
    }
  }
}
