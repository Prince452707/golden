import 'package:flutter/material.dart';
import 'buy_screen.dart';

class DiscoverArticle {
  final String id;
  final String title;
  final String authorName;
  final String authorRole;
  final String readTime;
  final String date;
  final String imageAsset;
  final String category;
  final String description;
  final List<String> takeaways;

  const DiscoverArticle({
    required this.id,
    required this.title,
    required this.authorName,
    required this.authorRole,
    required this.readTime,
    required this.date,
    required this.imageAsset,
    required this.category,
    required this.description,
    required this.takeaways,
  });
}

class DiscoverData {
  static const List<DiscoverArticle> articles = [
    DiscoverArticle(
      id: 'article_1',
      title: 'Why Gold is a\nSmart Investment?',
      authorName: 'Aryan Sharma',
      authorRole: 'Bullion Market Strategist',
      readTime: '3 min read',
      date: '12 Oct 2026',
      imageAsset: 'assets/discover_gold_smart.png',
      category: 'INVESTMENT INSIGHTS',
      description:
          'Gold has historically served as the ultimate hedge against inflation and economic uncertainty. Unlike fiat currencies that lose purchasing power over time, physical and digital 24K gold retain their intrinsic worth across generations.\n\nThroughout economic recessions and currency devaluations, central banks continually increase their sovereign gold reserves. For retail investors, maintaining 10% to 15% of your net worth in 24K pure bullion provides an unshakeable safety net while delivering steady long-term appreciation.\n\nKey advantages of digital gold:\n• Zero Storage Burden: Stored in high-security, insured bank-grade vaults.\n• Instant Liquidity: Sell or convert back to cash 24/7 with instant UPI transfer.\n• Transparent Pricing: Real-time market rates directly linked to wholesale bullion exchanges.',
      takeaways: [
        'Ultimate hedge against inflation and currency depreciation.',
        'Zero credit risk with physically backed 24K vaulted gold.',
        'High liquidity with instant UPI bank withdrawals 24/7.',
      ],
    ),
    DiscoverArticle(
      id: 'article_2',
      title: 'How to Start\nSaving in Gold',
      authorName: 'Priya Patel',
      authorRole: 'Personal Finance Guide',
      readTime: '2 min read',
      date: '5 Oct 2026',
      imageAsset: 'assets/discover_start_saving.png',
      category: 'BEGINNER GUIDE',
      description:
          'You no longer need large sums of capital to own 24K 99.9% pure gold. With digital gold micro-savings, you can start building your bullion wealth with as little as ₹10 per day.\n\nBy utilizing rupee-cost averaging, your savings automatically buy more gold when prices dip and less when prices peak, smoothing out market volatility without the stress of timing the market.\n\nEvery milligram accumulated is 100% physically backed and stored in secure institutional vaults. When your savings reach your target, you can easily request doorstep delivery of BIS-hallmarked gold coins.',
      takeaways: [
        'Start with micro-savings from as little as ₹10.',
        'Rupee-cost averaging removes the stress of timing market peaks and troughs.',
        'Fully backed by physical gold with doorstep delivery anytime.',
      ],
    ),
    DiscoverArticle(
      id: 'article_3',
      title: 'Gold vs Silver:\nWhich is Better?',
      authorName: 'Karan Malhotra',
      authorRole: 'Commodities Analyst',
      readTime: '4 min read',
      date: '28 Sep 2026',
      imageAsset: 'assets/discover_gold_vs_silver.png',
      category: 'ASSET COMPARISON',
      description:
          'Both precious metals hold essential roles in a well-diversified portfolio, but they behave very differently across economic cycles.\n\nGold is primarily a monetary asset and store of value with lower volatility, making it ideal for wealth preservation and risk protection.\n\nSilver, by contrast, is both a precious metal and a vital industrial element in solar panels, electric vehicles, and semiconductors. Because silver has a smaller market capitalization and high industrial demand, it often delivers explosive upside during economic expansions.\n\nA balanced allocation of 70% Gold for stability and 30% Silver for accelerated growth potential provides optimal risk-adjusted returns.',
      takeaways: [
        'Gold offers steady capital preservation and lower market volatility.',
        'Silver provides high growth potential driven by clean tech industrial demand.',
        'Recommended allocation: 70% Gold and 30% Silver for balanced growth.',
      ],
    ),
    DiscoverArticle(
      id: 'article_4',
      title: '5 Tips to Grow\nYour Gold...',
      authorName: 'Wealth Academy',
      authorRole: 'Certified Financial Planners',
      readTime: '3 min read',
      date: '20 Sep 2026',
      imageAsset: 'assets/discover_grow_gold.png',
      category: 'GROWTH STRATEGY',
      description:
          'Maximizing your precious metals returns requires discipline and smart timing rather than speculation:\n\n1. Automate Daily Savings: Rupee-cost averaging ensures you buy more gold when prices dip and less when prices peak.\n2. Leverage Price Drops: Use price alerts and add extra lumpsum during market corrections.\n3. Reinvest Cashbacks & Windfalls: Convert bonuses directly into bullion savings.\n4. Set Target-Based Goals: Tie your gold savings to milestones like weddings, emergencies, or real estate down payments.\n5. Think Long Term: Maintain at least a 3 to 5-year investment horizon for compounded gains.',
      takeaways: [
        'Set up automated daily deposits for effortless habit formation.',
        'Use market dip notifications to accumulate extra grams at discounts.',
        'Maintain a 3 to 5-year investment horizon for compounded wealth.',
      ],
    ),
  ];
}

/// Full Page Discover & Learn Hub Screen
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Beginner Guide',
    'Investment Insights',
    'Asset Comparison',
    'Growth Strategy',
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All'
        ? DiscoverData.articles
        : DiscoverData.articles.where((a) {
            if (_selectedCategory == 'Beginner Guide') {
              return a.category.contains('BEGINNER');
            }
            if (_selectedCategory == 'Investment Insights') {
              return a.category.contains('INVESTMENT');
            }
            if (_selectedCategory == 'Asset Comparison') {
              return a.category.contains('COMPARISON');
            }
            if (_selectedCategory == 'Growth Strategy') {
              return a.category.contains('STRATEGY');
            }
            return true;
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Discover & Learn',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter Pills
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final cat = _categories[idx];
                  final isSelected = _selectedCategory == cat;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF00796B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // Featured Article Card (First item)
            if (filtered.isNotEmpty) ...[
              const Text(
                'Featured Guide',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),
              _buildFeaturedCard(context, filtered.first),
              const SizedBox(height: 22),
            ],

            // All Articles Header
            const Text(
              'All Guides & Insights',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // Vertical list of articles
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final article = filtered[index];
                return _buildArticleListItem(context, article);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, DiscoverArticle article) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DiscoverDetailScreen(article: article),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Image Thumbnail
              SizedBox(
                height: 170,
                width: double.infinity,
                child: Image.asset(
                  article.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF99F6E4)),
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D9488),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title.replaceAll('\n', ' '),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          article.authorName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('•', style: TextStyle(color: Color(0xFF94A3B8))),
                        const SizedBox(width: 6),
                        Text(
                          article.readTime,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('•', style: TextStyle(color: Color(0xFF94A3B8))),
                        const SizedBox(width: 6),
                        Text(
                          article.date,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleListItem(BuildContext context, DiscoverArticle article) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DiscoverDetailScreen(article: article),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 95,
                height: 70,
                child: Image.asset(
                  article.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title.replaceAll('\n', ' '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${article.authorName} • ${article.readTime}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    article.date,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full Page Dedicated Article Detail Screen with High-Res Image & Description
class DiscoverDetailScreen extends StatelessWidget {
  final DiscoverArticle article;

  const DiscoverDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Guide Detail',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 20, color: Color(0xFF475569)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Article link copied to clipboard!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Width Image Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.asset(
                          article.imageAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Content Body
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Pill & Read Time
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDFA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF99F6E4)),
                              ),
                              child: Text(
                                article.category,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D9488),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 4),
                            Text(
                              article.readTime,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: Color(0xFF94A3B8))),
                            const SizedBox(width: 8),
                            Text(
                              article.date,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Title
                        Text(
                          article.title.replaceAll('\n', ' '),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            height: 1.25,
                            letterSpacing: -0.4,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Author Profile Row
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFFFEF3C7),
                                child: Text(
                                  article.authorName[0],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.authorName,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      article.authorRole,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // In-Depth Description
                        const Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.description,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF334155),
                            height: 1.55,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Key Takeaways
                        const Text(
                          'Key Takeaways',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Column(
                            children: article.takeaways.map((tip) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('💡 ', style: TextStyle(fontSize: 13)),
                                    Expanded(
                                      child: Text(
                                        tip,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF78350F),
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Read Next Section
                        const Text(
                          'Read Next',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...DiscoverData.articles
                            .where((a) => a.id != article.id)
                            .map((nextArticle) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => DiscoverDetailScreen(article: nextArticle),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFF1F5F9)),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: SizedBox(
                                              width: 70,
                                              height: 50,
                                              child: Image.asset(
                                                nextArticle.imageAsset,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  nextArticle.title.replaceAll('\n', ' '),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF0F172A),
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  '${nextArticle.authorName} • ${nextArticle.readTime}',
                                                  style: const TextStyle(
                                                    fontSize: 10.5,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right_rounded,
                                            size: 20,
                                            color: Color(0xFF94A3B8),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom CTA Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const BuyScreen(initialIsGold: true),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Start Saving in Gold (from ₹10)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

