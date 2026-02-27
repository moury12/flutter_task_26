import 'package:task28_02/app_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final Map<int, double> _tabScrollOffsets = {0: 0.0, 1: 0.0, 2: 0.0};
  late final List<ProductBloc> _productBlocs;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.tabLabels.length,
      vsync: this,
    );

    _productBlocs = List.generate(
      AppConstants.tabCategories.length,
      (_) => ProductBloc(getIt<ProductRepository>()),
    );

    for (int i = 0; i < AppConstants.tabCategories.length; i++) {
      _productBlocs[i]
          .add(FetchProducts(category: AppConstants.tabCategories[i]));
    }

    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;

    final int oldIndex = _currentTabIndex;
    final int newIndex = _tabController.index;

    _tabScrollOffsets[oldIndex] = _scrollController.offset;

    setState(() {
      _currentTabIndex = newIndex;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedOffset = _tabScrollOffsets[newIndex] ?? 0.0;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          savedOffset.clamp(
            _scrollController.position.minScrollExtent,
            _scrollController.position.maxScrollExtent,
          ),
        );
      }
    });
  }

  Future<void> _onRefresh() async {
    final category = AppConstants.tabCategories[_currentTabIndex];
    _productBlocs[_currentTabIndex].add(RefreshProducts(category: category));
    await _productBlocs[_currentTabIndex]
        .stream
        .firstWhere((s) => s is ProductLoaded || s is ProductError);
  }

  void _navigateToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.dispose();
    for (final bloc in _productBlocs) {
      bloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productBlocs[0]),
        BlocProvider.value(value: _productBlocs[1]),
        BlocProvider.value(value: _productBlocs[2]),
      ],
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              final velocity = details.primaryVelocity ?? 0;
              if (velocity < -AppConstants.swipeVelocityThreshold) {
                final nextIndex = (_tabController.index + 1)
                    .clamp(0, AppConstants.tabLabels.length - 1);
                _tabController.animateTo(nextIndex);
              } else if (velocity > AppConstants.swipeVelocityThreshold) {
                final prevIndex = (_tabController.index - 1)
                    .clamp(0, AppConstants.tabLabels.length - 1);
                _tabController.animateTo(prevIndex);
              }
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickyTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      tabs: AppConstants.tabLabels
                          .map((label) => Tab(text: label))
                          .toList(),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(fontSize: 14),
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                // Tab content area (Reactive Slivers)
                BlocBuilder<ProductBloc, ProductState>(
                  bloc: _productBlocs[_currentTabIndex],
                  builder: (context, state) {
                    if (state is ProductLoading || state is ProductInitial) {
                      return const ShimmerGrid();
                    }
                    if (state is ProductError) {
                      return ErrorView(
                        message: state.message,
                        onRetry: () => _productBlocs[_currentTabIndex].add(
                          FetchProducts(
                            category:
                                AppConstants.tabCategories[_currentTabIndex],
                          ),
                        ),
                      );
                    }
                    if (state is ProductLoaded) {
                      return ProductGrid(products: state.products);
                    }
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
                // Extra space for the bottom
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      floating: true,
      expandedHeight: AppConstants.sliverAppBarExpandedHeight,
      backgroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding,
                  vertical: AppConstants.verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final greeting = state is AuthAuthenticated
                                ? 'Hello, ${state.user.name.firstname}! 👋'
                                : 'Hello! 👋';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  greeting,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Find what you need',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        InkWell(
                          onTap: _navigateToProfile,
                          borderRadius: BorderRadius.circular(20),
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(Icons.search,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search products...',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
