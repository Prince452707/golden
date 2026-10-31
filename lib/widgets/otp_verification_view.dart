import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerificationView extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  final VoidCallback onEditNumber;
  final VoidCallback onVerificationSuccess;
  const OtpVerificationView({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
    required this.onEditNumber,
    required this.onVerificationSuccess,
  });

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  static const int _otpLength = 6;
  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  int _resendCountdown = 30;
  Timer? _timer;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _resendCountdown = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _verifyOtp() async {
    final otp = _currentOtp;
    if (otp.length < _otpLength) {
      setState(() {
        _errorMessage = 'Please enter all 6 digits';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 750));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    widget.onVerificationSuccess();
  }

  void _fillSampleOtp() {
    const sample = '123456';
    for (int i = 0; i < _otpLength; i++) {
      _controllers[i].text = sample[i];
    }
    setState(() {
      _errorMessage = null;
    });
    _verifyOtp();
  }

  @override
  Widget build(BuildContext context) {
    final isOtpFilled = _currentOtp.length == _otpLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF00AAA1),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      size: 9,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Verify OTP',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 20),
              onPressed: widget.onEditNumber,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Change number',
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Text(
              'Code sent to ${widget.countryCode} ${widget.phoneNumber}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.onEditNumber,
              child: const Text(
                'Edit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00AAA1),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 6 Pin Boxes with 50px height
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_otpLength, (index) {
            return SizedBox(
              width: 44,
              height: 50,
              child: Focus(
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.backspace &&
                      _controllers[index].text.isEmpty &&
                      index > 0) {
                    _focusNodes[index - 1].requestFocus();
                    _controllers[index - 1].clear();
                    setState(() {});
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_otpLength),
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _controllers[index].text.isNotEmpty
                            ? const Color(0xFF00AAA1)
                            : const Color(0xFFDEF1EF),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF00AAA1),
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length > 1) {
                      final digits = value.replaceAll(RegExp(r'\D'), '');
                      for (int i = 0; i < _otpLength && i < digits.length; i++) {
                        _controllers[i].text = digits[i];
                      }
                      final target = (digits.length - 1).clamp(0, _otpLength - 1);
                      _focusNodes[target].requestFocus();
                      setState(() {});
                      if (_currentOtp.length == _otpLength) {
                        _verifyOtp();
                      }
                      return;
                    }
                    setState(() {});
                    if (value.isNotEmpty && index < _otpLength - 1) {
                      _focusNodes[index + 1].requestFocus();
                    } else if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    }

                    if (_currentOtp.length == _otpLength) {
                      _verifyOtp();
                    }
                  },
                ),
              ),
            );
          }),
        ),

        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
        ],

        const SizedBox(height: 14),

        // Resend Timer Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: _fillSampleOtp,
              child: const Text(
                'Auto-fill Demo (123456)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ),
            _resendCountdown > 0
                ? Text(
                    'Resend in ${_resendCountdown}s',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      _startCountdown();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('A new OTP has been sent!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00AAA1),
                      ),
                    ),
                  ),
          ],
        ),

        const SizedBox(height: 20),

        // Confirm Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isOtpFilled && !_isLoading ? _verifyOtp : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00AAA1),
              disabledBackgroundColor: const Color(0xFFBCE7E4),
              foregroundColor: Colors.white,
              disabledForegroundColor: const Color(0xFF8FD8CD),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Verify & Proceed',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
