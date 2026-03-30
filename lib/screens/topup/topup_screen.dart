import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

// ─── Topup screen ─────────────────────────────────────────────────────────────
class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen>
    with SingleTickerProviderStateMixin {
  int    _step          = 0;
  int    _amount        = 200;
  String _paymentMethod = '';

  late AnimationController _animCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  final List<int> _presets    = [100, 200, 500, 1000, 2000, 5000];
  final String    _cardNo     = '**** 4582';
  final String    _cardHolder = 'JOHN DOE';

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
        begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    _animCtrl.forward(from: 0);
    setState(() => _step = step);
  }

  void _resetFlow() {
    _animCtrl.forward(from: 0);
    setState(() { _step = 0; _amount = 200; _paymentMethod = ''; });
  }

  void _showReceipt() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReceiptSheet(
        amount: _amount,
        cardNo: _cardNo,
        cardHolder: _cardHolder,
        paymentMethod: _paymentMethod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.bg(context),
        bottomNavigationBar: const AppBottomNav(currentIndex: 2),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryMid,
                    AppColors.bg(context),
                  ],
                  stops: const [0.0, 0.28, 0.65],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildStepBar(context),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.bg(context),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(32)),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                    begin: const Offset(0, 0.04),
                                    end: Offset.zero)
                                    .animate(anim),
                                child: child,
                              ),
                            ),
                            child: _step == 0
                                ? _TopUpStep(
                              key: const ValueKey(0),
                              amount: _amount,
                              cardNo: _cardNo,
                              cardHolder: _cardHolder,
                              presets: _presets,
                              onAmountChanged: (v) =>
                                  setState(() => _amount = v),
                              onNext: () => _goTo(1),
                            )
                                : _step == 1
                                ? _PaymentStep(
                              key: const ValueKey(1),
                              amount: _amount,
                              cardNo: _cardNo,
                              selectedMethod: _paymentMethod,
                              onMethodSelected: (m) =>
                                  setState(() => _paymentMethod = m),
                              onPay: () => _goTo(2),
                              onBack: () => _goTo(0),
                            )
                                : _SuccessStep(
                              key: const ValueKey(2),
                              amount: _amount,
                              cardNo: _cardNo,
                              onViewReceipt: _showReceipt,
                              onNewTopUp: _resetFlow,
                              onBackToHome: () =>
                                 Navigator.pushNamed(
                                  context, AppRouter.home),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
              const Text('Top Up Card',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(width: 42),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Add Value',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.1)),
          const SizedBox(height: 6),
          Text('Top up your metro card for seamless travel',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8), fontSize: 14)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStepBar(BuildContext context) {
    const labels = ['Top Up', 'Payment', 'Finish'];
    return Container(
      color: AppColors.surface(context),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = i ~/ 2 < _step;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: done
                      ? const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryMid])
                      : null,
                  color: done ? null : AppColors.borderOf(context),
                ),
              ),
            );
          }
          final idx    = i ~/ 2;
          final active = idx == _step;
          final done   = idx < _step;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40, height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: active || done
                      ? const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryMid])
                      : null,
                  color: active || done ? null : AppColors.surface(context),
                  border: Border.all(
                    color: active || done
                        ? Colors.transparent
                        : AppColors.borderOf(context),
                    width: 2,
                  ),
                  boxShadow: active
                      ? [BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4))]
                      : [],
                ),
                child: done
                    ? const Icon(Icons.check_rounded,
                    color: Colors.white, size: 20)
                    : Center(
                    child: Text('${idx + 1}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: active
                                ? Colors.white
                                : AppColors.textHintOf(context)))),
              ),
              const SizedBox(height: 6),
              Text(labels[idx],
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                      active ? FontWeight.w700 : FontWeight.w500,
                      color: active
                          ? AppColors.primary
                          : AppColors.textHintOf(context))),
            ],
          );
        }),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// STEP 1 — Top Up
// ══════════════════════════════════════════════════════════════════════════════
class _TopUpStep extends StatefulWidget {
  final int amount;
  final String cardNo, cardHolder;
  final List<int> presets;
  final ValueChanged<int> onAmountChanged;
  final VoidCallback onNext;

  const _TopUpStep({
    super.key,
    required this.amount,
    required this.cardNo,
    required this.cardHolder,
    required this.presets,
    required this.onAmountChanged,
    required this.onNext,
  });

  @override
  State<_TopUpStep> createState() => _TopUpStepState();
}

class _TopUpStepState extends State<_TopUpStep> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.amount.toString());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        children: [
          _CardWidget(
              cardNo: widget.cardNo,
              cardHolder: widget.cardHolder,
              amount: widget.amount),
          const SizedBox(height: 24),
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Amount',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryOf(context))),
                const SizedBox(height: 4),
                Text('Minimum top-up is KES50',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryOf(context))),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.borderOf(context), width: 1.5),
                    borderRadius: BorderRadius.circular(14),
                    color: AppColors.card(context),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('KES',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryOf(context)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter amount',
                            hintStyle: TextStyle(
                                color: AppColors.textHintOf(context),
                                fontSize: 16),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                          onChanged: (v) {
                            final n = int.tryParse(v);
                            if (n != null) widget.onAmountChanged(n);
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.backspace_outlined,
                            color: AppColors.textHintOf(context), size: 18),
                        onPressed: () {
                          _ctrl.clear();
                          widget.onAmountChanged(0);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.presets.map((amt) {
                    final sel = widget.amount == amt;
                    return GestureDetector(
                      onTap: () {
                        _ctrl.text = amt.toString();
                        widget.onAmountChanged(amt);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 11),
                        decoration: BoxDecoration(
                          gradient: sel
                              ? const LinearGradient(colors: [
                            AppColors.primary,
                            AppColors.primaryMid
                          ])
                              : null,
                          color: sel ? null : AppColors.chipBgOf(context),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: sel
                                ? Colors.transparent
                                : AppColors.borderOf(context),
                          ),
                          boxShadow: sel
                              ? [BoxShadow(
                              color: AppColors.primary.withOpacity(0.28),
                              blurRadius: 8,
                              offset: const Offset(0, 3))]
                              : [],
                        ),
                        child: Text('KES$amt',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: sel
                                    ? Colors.white
                                    : AppColors.primary)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _GradientButton(
            label: 'Proceed to Payment  →',
            onTap: widget.amount >= 50 ? widget.onNext : null,
          ),
          const SizedBox(height: 8),
          if (widget.amount > 0 && widget.amount < 50)
            const Text('Minimum amount is KES50',
                style: TextStyle(color: AppColors.delay, fontSize: 12)),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// STEP 2 — Payment
// ══════════════════════════════════════════════════════════════════════════════
class _PaymentStep extends StatelessWidget {
  final int amount;
  final String cardNo;
  final String selectedMethod;
  final ValueChanged<String> onMethodSelected;
  final VoidCallback onPay, onBack;

  const _PaymentStep({
    super.key,
    required this.amount,
    required this.cardNo,
    required this.selectedMethod,
    required this.onMethodSelected,
    required this.onPay,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.orange.withOpacity(0.3)),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.access_time_rounded,
                    color: AppColors.orange, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Complete payment within 25 minutes to avoid cancellation',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.orange,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Summary',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryOf(context))),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount',
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondaryOf(context))),
                    Text('KES$amount',
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary)),
                  ],
                ),
                Divider(height: 24, color: AppColors.borderOf(context)),
                _SummaryRow(label: 'Card Number', value: cardNo),
                const SizedBox(height: 6),
                _SummaryRow(label: 'Service Fee', value: 'KES0'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Select Payment Method',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryOf(context))),
          const SizedBox(height: 14),
          _PaymentOption(
              icon: Icons.account_balance_rounded,
              title: 'Bank Transfer',
              subtitle: 'Transfer via your bank',
              value: 'bank',
              selected: selectedMethod,
              onTap: () => onMethodSelected('bank')),
          const SizedBox(height: 10),
          _PaymentOption(
              icon: Icons.credit_card_rounded,
              title: 'Debit / Credit Card',
              subtitle: 'Pay with your card',
              value: 'card',
              selected: selectedMethod,
              onTap: () => onMethodSelected('card')),
          const SizedBox(height: 10),
          _PaymentOption(
              icon: Icons.qr_code_scanner_rounded,
              title: 'QR Code',
              subtitle: 'Scan to pay instantly',
              value: 'qr',
              selected: selectedMethod,
              onTap: () => onMethodSelected('qr')),
          const SizedBox(height: 10),
          _PaymentOption(
              icon: Icons.smartphone_rounded,
              title: 'Mobile Money',
              subtitle: 'Pay with mobile wallet',
              value: 'mobile',
              selected: selectedMethod,
              onTap: () => onMethodSelected('mobile')),
          const SizedBox(height: 28),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.borderOf(context)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Back',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _GradientButton(
                label: 'Pay Now',
                onTap: selectedMethod.isNotEmpty ? onPay : null,
              ),
            ),
          ]),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryOf(context))),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryOf(context))),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, value, selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = value == selected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: sel ? AppColors.primary : AppColors.borderOf(context),
            width: sel ? 2 : 1,
          ),
          boxShadow: sel
              ? [BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: sel
                  ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryMid])
                  : null,
              color: sel ? null : AppColors.chipBgOf(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: sel ? Colors.white : AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: sel
                            ? AppColors.primary
                            : AppColors.textPrimaryOf(context))),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryOf(context))),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 22, height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: sel ? AppColors.primary : AppColors.borderOf(context),
                width: 2,
              ),
            ),
            child: sel
                ? Center(
                child: Container(
                  width: 10, height: 10,
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle),
                ))
                : null,
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// STEP 3 — Success
// ══════════════════════════════════════════════════════════════════════════════
class _SuccessStep extends StatelessWidget {
  final int amount;
  final String cardNo;
  final VoidCallback onViewReceipt, onNewTopUp, onBackToHome;

  const _SuccessStep({
    super.key,
    required this.amount,
    required this.cardNo,
    required this.onViewReceipt,
    required this.onNewTopUp,
    required this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ SingleChildScrollView prevents overflow on small screens
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Animated checkmark — slightly smaller to save vertical space
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.elasticOut,
            builder: (_, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryMid]),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8))],
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 52),
            ),
          ),
          const SizedBox(height: 20),

          Text('Payment Successful!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryOf(context))),
          const SizedBox(height: 8),

          Text('KES$amount has been added to\n$cardNo',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondaryOf(context),
                  height: 1.6)),
          const SizedBox(height: 20),

          // Celebration banner
          Container(
            padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.accentLight.withOpacity(
                  Theme.of(context).brightness == Brightness.dark
                      ? 0.15
                      : 1),
              borderRadius: BorderRadius.circular(14),
              border:
              Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.celebration_rounded,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                const Text('Your metro card is topped up!',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _GradientButton(label: 'View Receipt', onTap: onViewReceipt),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onNewTopUp,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side:
                const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('New Top Up',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
            ),
          ),
          const SizedBox(height: 4),

          TextButton(
            onPressed: onBackToHome,
            child: Text('Back to Home',
                style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Receipt bottom sheet
// ══════════════════════════════════════════════════════════════════════════════
class _ReceiptSheet extends StatelessWidget {
  final int amount;
  final String cardNo, cardHolder, paymentMethod;

  const _ReceiptSheet({
    required this.amount,
    required this.cardNo,
    required this.cardHolder,
    required this.paymentMethod,
  });

  String _methodName() {
    switch (paymentMethod) {
      case 'bank':   return 'Bank Transfer';
      case 'card':   return 'Debit / Credit Card';
      case 'qr':     return 'QR Code';
      case 'mobile': return 'Mobile Money';
      default:       return '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: AppColors.borderOf(context),
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          Text('Transaction Receipt',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryOf(context))),
          const SizedBox(height: 4),
          Text('Keep this for your records',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondaryOf(context))),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(children: [
                _ReceiptRow(
                    label: 'Transaction ID',
                    value:
                    'TRX${DateTime.now().millisecondsSinceEpoch % 1000000}'),
                const SizedBox(height: 10),
                _ReceiptRow(
                    label: 'Date & Time',
                    value: _fmtDate(DateTime.now())),
                const SizedBox(height: 10),
                _ReceiptRow(label: 'Card Number', value: cardNo),
                const SizedBox(height: 10),
                _ReceiptRow(label: 'Card Holder', value: cardHolder),
                const SizedBox(height: 10),
                _ReceiptRow(
                    label: 'Payment Method', value: _methodName()),
                Divider(
                    height: 24, color: AppColors.borderOf(context)),
                _ReceiptRow(
                    label: 'Amount Credited',
                    value: 'KES$amount',
                    bold: true,
                    valueColor: AppColors.primary),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _GradientButton(
                label: 'Close',
                onTap: () => Navigator.pop(context)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class _ReceiptRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  final Color? valueColor;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryOf(context),
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimaryOf(context))),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Shared sub-widgets
// ══════════════════════════════════════════════════════════════════════════════
class _CardWidget extends StatelessWidget {
  final String cardNo, cardHolder;
  final int amount;

  const _CardWidget(
      {required this.cardNo,
        required this.cardHolder,
        required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
            color: AppColors.primary.withOpacity(0.32),
            blurRadius: 22,
            offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Plateau Metro Card',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5)),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.credit_card_rounded,
                  color: Colors.white, size: 20),
            ),
          ]),
          const SizedBox(height: 22),
          Text(cardNo,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3)),
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Card Holder',
                  style: TextStyle(color: Colors.white60, fontSize: 10)),
              const SizedBox(height: 3),
              Text(cardHolder,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text('Top Up Amount',
                  style: TextStyle(color: Colors.white60, fontSize: 10)),
              const SizedBox(height: 3),
              Text('KES$amount',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
            ]),
          ]),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(
                Theme.of(context).brightness == Brightness.dark
                    ? 0.3
                    : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _GradientButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)
              : null,
          color: enabled ? null : AppColors.borderOf(context),
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6))]
              : [],
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: enabled
                      ? Colors.white
                      : AppColors.textHintOf(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4)),
        ),
      ),
    );
  }
}