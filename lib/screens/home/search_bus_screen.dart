import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../app_router.dart';
import '../../widgets/common_widgets.dart';

class SearchBusScreen extends StatefulWidget {
  const SearchBusScreen({super.key});

  @override
  State<SearchBusScreen> createState() => _SearchBusScreenState();
}

class _SearchBusScreenState extends State<SearchBusScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Sample recent searches data
  List<Map<String, String>> _recentSearches = [
    {'from': 'Anglo Jos', 'to': 'Vom Junction'},
    {'from': 'British', 'to': 'Zawan Junction'},
    {'from': 'Termino', 'to': 'Gyel'},
    {'from': 'City Center', 'to': 'Jabi Lake'},
    {'from': 'Wuse Market', 'to': 'Garki Area 11'},
  ];

  // Sample suggested routes
  final List<Map<String, String>> _suggestedRoutes = [
    {'from': 'Old Airport', 'to': 'Central Station', 'time': '15 min', 'price': '₦200'},
    {'from': 'Zawan', 'to': 'Terminus', 'time': '25 min', 'price': '₦350'},
    {'from': 'Jabi', 'to': 'Wuse 2', 'time': '20 min', 'price': '₦300'},
    {'from': 'Garki', 'to': 'Area 1', 'time': '12 min', 'price': '₦150'},
  ];

  // Sample search suggestions
  final List<String> _searchSuggestions = [
    'Anglo Jos',
    'British',
    'Termino',
    'Gyel',
    'Vom Junction',
    'Zawan Junction',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();

    // Add listeners for real-time validation
    _fromController.addListener(_updateSearchButton);
    _toController.addListener(_updateSearchButton);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool _isFormValid = false;

  void _updateSearchButton() {
    setState(() {
      _isFormValid = _fromController.text.isNotEmpty &&
          _toController.text.isNotEmpty;
    });
  }

  void _onSearchChanged() {
    setState(() {});
  }

  void _performSearch() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Add to recent searches
      final newSearch = {
        'from': _fromController.text.trim(),
        'to': _toController.text.trim(),
      };

      setState(() {
        _recentSearches.insert(0, newSearch);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });

      // Navigate to route details
      Navigator.pushNamed(
        context,
        AppRouter.selectedRoute,
        arguments: newSearch,
      );
    }
  }

  void _swapLocations() {
    setState(() {
      final temp = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = temp;
    });
    _updateSearchButton();
  }

  void _selectRecentSearch(Map<String, String> search) {
    setState(() {
      _fromController.text = search['from']!;
      _toController.text = search['to']!;
    });
    _updateSearchButton();
    _performSearch();
  }

  void _selectSuggestion(String suggestion) {
    setState(() {
      if (_fromController.text.isEmpty) {
        _fromController.text = suggestion;
      } else if (_toController.text.isEmpty) {
        _toController.text = suggestion;
      }
    });
    _updateSearchButton();
  }

  void _clearRecentSearches() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Clear Recent Searches'),
        content: const Text(
          'Are you sure you want to clear all recent searches?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _recentSearches = [];
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Recent searches cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.delay)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSuggestions = _searchController.text.isNotEmpty
        ? _searchSuggestions
        .where((s) => s
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()))
        .toList()
        : _searchSuggestions;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with filter button
          GreenHeader(
            title: 'Search Bus Route',
            trailing: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 20),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // Location Input Card
                          _LocationInputCard(
                            fromController: _fromController,
                            toController: _toController,
                            onSwap: _swapLocations,
                            onSearch: _performSearch,
                            isLoading: _isLoading,
                            isValid: _isFormValid,
                          ),

                          // Search Suggestions
                          if (_searchController.text.isNotEmpty &&
                              filteredSuggestions.isNotEmpty)
                            _SearchSuggestions(
                              suggestions: filteredSuggestions,
                              onSelect: _selectSuggestion,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Recent Searches Section
                  if (_recentSearches.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Searches',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextButton(
                                onPressed: _clearRecentSearches,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 12, thickness: 1),
                          ..._recentSearches.map((search) => _RecentItem(
                            from: search['from']!,
                            to: search['to']!,
                            onTap: () => _selectRecentSearch(search),
                          )),
                        ],
                      ),
                    ),

                  // Suggested Routes Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Popular Routes 🔥',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Divider(height: 12, thickness: 1),
                        ..._suggestedRoutes.map((route) => _SuggestedRoute(
                          from: route['from']!,
                          to: route['to']!,
                          time: route['time']!,
                          price: route['price']!,
                          onTap: () {
                            setState(() {
                              _fromController.text = route['from']!;
                              _toController.text = route['to']!;
                            });
                            _updateSearchButton();
                            _performSearch();
                          },
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const AppBottomNav(currentIndex: 1),
        ],
      ),
    );
  }
}

class _LocationInputCard extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final VoidCallback onSwap;
  final VoidCallback onSearch;
  final bool isLoading;
  final bool isValid;

  const _LocationInputCard({
    required this.fromController,
    required this.toController,
    required this.onSwap,
    required this.onSearch,
    required this.isLoading,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // From Location
          _LocationField(
            controller: fromController,
            hint: 'From where?',
            icon: Icons.my_location_rounded,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),

          // Swap Button
          GestureDetector(
            onTap: onSwap,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.chipBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.swap_vert_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // To Location
          _LocationField(
            controller: toController,
            hint: 'Where to?',
            icon: Icons.location_on_rounded,
            color: AppColors.delay,
          ),
          const SizedBox(height: 24),

          // Search Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isValid && !isLoading ? onSearch : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid ? AppColors.primary : AppColors.textHint,
                disabledBackgroundColor: AppColors.textHint,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: isValid ? 2 : 0,
              ),
              child: isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Search Bus',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color color;

  const _LocationField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.textHint,
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            child: Icon(icon, color: color, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  final String from;
  final String to;
  final VoidCallback? onTap;

  const _RecentItem({
    required this.from,
    required this.to,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.history_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  children: [
                    TextSpan(text: from),
                    const TextSpan(
                      text: '  →  ',
                      style: TextStyle(color: AppColors.textHint),
                    ),
                    TextSpan(text: to),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SuggestedRoute extends StatelessWidget {
  final String from;
  final String to;
  final String time;
  final String price;
  final VoidCallback onTap;

  const _SuggestedRoute({
    required this.from,
    required this.to,
    required this.time,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, AppColors.chipBg],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.directions_bus_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        TextSpan(text: from),
                        const TextSpan(
                          text: ' → ',
                          style: TextStyle(color: AppColors.primary),
                        ),
                        TextSpan(text: to),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.attach_money_rounded,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSelect;

  const _SearchSuggestions({
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              return GestureDetector(
                onTap: () => onSelect(suggestion),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.chipBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}