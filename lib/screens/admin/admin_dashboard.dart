import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/admin_auth_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Consumer<AdminAuthProvider>(
      builder: (context, adminProvider, _) {
        if (!adminProvider.isAuthenticated) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('GumballZ Admin Dashboard'),
            backgroundColor: primaryColor,
            elevation: 0,
            actions: [
              // Admin Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        adminProvider.adminUser?.email ?? 'Admin',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        adminProvider.adminRole ?? 'admin',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Logout Button
              PopupMenuButton(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Logout'),
                    onTap: () async {
                      await adminProvider.logoutAdmin();
                      if (mounted) {
                        Navigator.of(context)
                            .pushReplacementNamed('admin_login');
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Row(
            children: [
              // Sidebar
              if (!isMobile)
                _buildSidebar(adminProvider)
              else
                SizedBox.fromSize(),

              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Mobile Navigation Bar
                    if (isMobile)
                      _buildMobileNavBar()
                    else
                      const SizedBox.shrink(),

                    // Content Area
                    Expanded(
                      child: _buildMainContent(_selectedIndex),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isMobile
              ? BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: primaryColor,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_bag),
                      label: 'Products',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.category),
                      label: 'Categories',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.receipt),
                      label: 'Orders',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.local_offer),
                      label: 'Promos',
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  Widget _buildSidebar(AdminAuthProvider adminProvider) {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
      },
      labelType: NavigationRailLabelType.all,
      backgroundColor: Colors.grey[100],
      elevation: 1,
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        if (adminProvider.hasPermission('manage_products'))
          const NavigationRailDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: Text('Products'),
          ),
        if (adminProvider.hasPermission('manage_categories'))
          const NavigationRailDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: Text('Categories'),
          ),
        if (adminProvider.hasPermission('manage_orders'))
          const NavigationRailDestination(
            icon: Icon(Icons.receipt_outlined),
            selectedIcon: Icon(Icons.receipt),
            label: Text('Orders'),
          ),
        if (adminProvider.hasPermission('manage_promos'))
          const NavigationRailDestination(
            icon: Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(Icons.local_offer),
            label: Text('Promo Codes'),
          ),
      ],
    );
  }

  Widget _buildMobileNavBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[100],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildNavButton(Icons.dashboard, 'Dashboard', 0),
            _buildNavButton(Icons.shopping_bag, 'Products', 1),
            _buildNavButton(Icons.category, 'Categories', 2),
            _buildNavButton(Icons.receipt, 'Orders', 3),
            _buildNavButton(Icons.local_offer, 'Promos', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Chip(
        avatar: Icon(icon),
        label: Text(label),
        backgroundColor:
            _selectedIndex == index ? primaryColor : Colors.grey[300],
        labelStyle: TextStyle(
          color: _selectedIndex == index ? Colors.white : Colors.black,
        ),
        onPressed: () {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  Widget _buildMainContent(int index) {
    switch (index) {
      case 0:
        return _buildDashboardHome();
      case 1:
        return _buildAdminProductsPlaceholder();
      case 2:
        return _buildAdminCategoriesPlaceholder();
      case 3:
        return _buildAdminOrdersPlaceholder();
      case 4:
        return _buildAdminPromosPlaceholder();
      default:
        return _buildDashboardHome();
    }
  }

  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Overview',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard('Total Products', '0', Icons.shopping_bag),
              _buildStatCard('Total Orders', '0', Icons.receipt),
              _buildStatCard('Pending Orders', '0', Icons.hourglass_empty),
              _buildStatCard('Active Promos', '0', Icons.local_offer),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ElevatedButton.icon(
                onPressed: () => setState(() => _selectedIndex = 1),
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _selectedIndex = 2),
                icon: const Icon(Icons.add),
                label: const Text('Add Category'),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _selectedIndex = 4),
                icon: const Icon(Icons.add),
                label: const Text('Add Promo Code'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                Icon(icon, color: primaryColor, size: 24),
              ],
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to GumballZ Admin Dashboard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'This is your central hub for managing the GumballZ Shop. Use the navigation menu to:',
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Manage Products - Add, edit, delete products'),
                  Text('• Manage Categories - Organize products by category'),
                  Text('• Manage Orders - Track and fulfill customer orders'),
                  Text('• Manage Promo Codes - Create and manage discounts'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminProductsPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Products Management'),
          const SizedBox(height: 8),
          const Text(
            'Coming Soon - Admin Product Management',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCategoriesPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Categories Management'),
          const SizedBox(height: 8),
          const Text(
            'Coming Soon - Admin Category Management',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminOrdersPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Orders Management'),
          const SizedBox(height: 8),
          const Text(
            'Coming Soon - Admin Order Management',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminPromosPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_offer, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Promo Codes Management'),
          const SizedBox(height: 8),
          const Text(
            'Coming Soon - Admin Promo Management',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
