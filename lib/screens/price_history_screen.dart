import 'package:flutter/material.dart';
import '../widgets/gold_3d_widgets.dart';

class PriceHistoryScreen extends StatefulWidget {
  const PriceHistoryScreen({super.key});

  @override
  State<PriceHistoryScreen> createState() => _PriceHistoryScreenState();
}

class _PriceHistoryScreenState extends State<PriceHistoryScreen> {
  String _selectedRange = '6M';

  // Points representing the 6-month historical trajectory matching screenshot
  // High ~15,500, dip to ~12,860 at point 3 (15 Aug 2026), rising to ~14,370
  final List<double> _historyPoints = [
    13800, 14950, 15500, 13400, 12860, 13600, 14200, 15100, 14700, 14370.20
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar: Back Arrow + "Gold Price History"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          size: 28,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Gold Price History',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Summary: 3D Ingot + Price + Change
                    _buildHeaderSummary(),

                    const SizedBox(height: 16),

                    // Time Filters: 1D, 1W, 1M, 6M (active), 1Y, ALL
                    TimeFilterPillsRow(
                      options: const ['1D', '1W', '1M', '6M', '1Y', 'ALL'],
                      selected: _selectedRange,
                      onSelected: (val) {
                        setState(() {
                          _selectedRange = val;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // Big Detailed Interactive Chart with Y-Axis & Tooltip
                    _buildDetailedHistoryChart(),

                    const SizedBox(height: 24),

                    // Price Details (6 Months)
                    const Text(
                      'Price Details (6 Months)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildPriceDetailsTable(),

                    const SizedBox(height: 20),

                    // Footer Info Note
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF94A3B8), width: 1.2),
                          ),
                          child: const Icon(
                            Icons.info_outline_rounded,
                            size: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Prices are live and include applicable GST.\nHistorical rates may vary based on market conditions.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildHeaderSummary() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const GoldBar3DWidget(width: 54, height: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gold (24K)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: const [
                    Text(
                      '₹14,370.20',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      ' / gm',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: const [
                    Icon(Icons.arrow_drop_up_rounded, size: 16, color: Color(0xFF10B981)),
                    Text(
                      '+0.8%',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedHistoryChart() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(10, 16, 16, 12),
      child: CustomPaint(
        painter: _HistoryChartWithAxisPainter(
          points: _historyPoints,
          yLabels: const ['16,000', '15,000', '14,000', '13,000', '12,000'],
          tooltipIndex: 4, // pointing at ₹12,860 on 15 Aug 2026
          tooltipPrice: '₹12,860',
          tooltipDate: '15 Aug 2026',
        ),
      ),
    );
  }

  Widget _buildPriceDetailsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _buildRow('Highest Price', '₹15,720.40'),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),
          _buildRow('Lowest Price', '₹12,480.30'),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),
          _buildRow('Average Price', '₹13,984.60'),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

class _HistoryChartWithAxisPainter extends CustomPainter {
  final List<double> points;
  final List<String> yLabels;
  final int tooltipIndex;
  final String tooltipPrice;
  final String tooltipDate;

  _HistoryChartWithAxisPainter({
    required this.points,
    required this.yLabels,
    required this.tooltipIndex,
    required this.tooltipPrice,
    required this.tooltipDate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 48.0;
    const topMargin = 20.0;
    const bottomMargin = 16.0;

    final chartWidth = size.width - leftMargin;
    final chartHeight = size.height - topMargin - bottomMargin;

    // Draw Y-Axis labels and dotted horizontal grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0).withValues(alpha: 0.7)
      ..strokeWidth = 1.0;

    final textStyle = const TextStyle(
      fontSize: 10,
      color: Color(0xFF94A3B8),
      fontWeight: FontWeight.w500,
    );

    for (int i = 0; i < yLabels.length; i++) {
      final y = topMargin + (i * (chartHeight / (yLabels.length - 1)));

      // Y-Axis text
      final tp = TextPainter(
        text: TextSpan(text: yLabels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftMargin - tp.width - 8, y - tp.height / 2));

      // Horizontal grid line
      canvas.drawLine(Offset(leftMargin, y), Offset(size.width, y), gridPaint);
    }

    // Chart curve mapping (12000 to 16000)
    const minVal = 12000.0;
    const maxVal = 16000.0;
    final range = maxVal - minVal;

    final offsets = <Offset>[];
    final dx = chartWidth / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      final norm = (points[i] - minVal) / range;
      final y = topMargin + chartHeight - (norm * chartHeight);
      offsets.add(Offset(leftMargin + (i * dx), y));
    }

    // Path
    final path = Path()..moveTo(offsets[0].dx, offsets[0].dy);
    final fillPath = Path()
      ..moveTo(offsets[0].dx, topMargin + chartHeight)
      ..lineTo(offsets[0].dx, offsets[0].dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final p0 = offsets[i];
      final p1 = offsets[i + 1];
      final cp1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final cp2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(offsets.last.dx, topMargin + chartHeight);
    fillPath.close();

    // Fill gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFDE68A).withValues(alpha: 0.45),
          const Color(0xFFFDE68A).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(leftMargin, topMargin, chartWidth, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    // Golden stroke
    final strokePaint = Paint()
      ..color = const Color(0xFFE5A83B)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);

    // Tooltip Marker & Callout Box
    if (tooltipIndex >= 0 && tooltipIndex < offsets.length) {
      final target = offsets[tooltipIndex];

      // Vertical marker line
      final indicatorPaint = Paint()
        ..color = const Color(0xFF0F172A).withValues(alpha: 0.4)
        ..strokeWidth = 1.0;
      canvas.drawLine(Offset(target.dx, target.dy - 32), target, indicatorPaint);

      // Tooltip Box (Dark Navy / Black)
      const boxWidth = 72.0;
      const boxHeight = 36.0;
      final boxRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(target.dx, target.dy - 36), width: boxWidth, height: boxHeight),
        const Radius.circular(8),
      );

      final boxPaint = Paint()
        ..color = const Color(0xFF0F172A)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(boxRect, boxPaint);

      // Text 1: Price
      final pricePainter = TextPainter(
        text: TextSpan(
          text: tooltipPrice,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      pricePainter.paint(
        canvas,
        Offset(boxRect.center.dx - pricePainter.width / 2, boxRect.top + 4),
      );

      // Text 2: Date
      final datePainter = TextPainter(
        text: TextSpan(
          text: tooltipDate,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      datePainter.paint(
        canvas,
        Offset(boxRect.center.dx - datePainter.width / 2, boxRect.top + 19),
      );

      // Marker Dot on line
      final dotPaint = Paint()..color = const Color(0xFF0F172A);
      final whitePaint = Paint()..color = Colors.white;
      canvas.drawCircle(target, 5.0, dotPaint);
      canvas.drawCircle(target, 3.0, whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

