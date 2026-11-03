import '../lib/core/api/api_client.dart';
import '../lib/core/api/api_config.dart';

void main() async {
  print('=== VERIFYING API CONNECTION TO ${ApiConfig.baseUrl} ===');

  final client = ApiClient();

  print('\n[1] Testing GET /rates/live...');
  final rates = await client.get<Map<String, dynamic>>('/rates/live');
  print('  -> Success: ${rates.success}');
  print('  -> Message: ${rates.message}');
  if (rates.data != null) {
    print('  -> Gold Buy: ${rates.data!['gold']?['buyPricePerGram']}');
    print('  -> Silver Buy: ${rates.data!['silver']?['buyPricePerGram']}');
  }

  print('\n[2] Testing POST /auth/send-otp...');
  final otpRes = await client.post<Map<String, dynamic>>(
    '/auth/send-otp',
    body: {
      'phoneNumber': '9876543210',
      'countryCode': '+91',
    },
  );
  print('  -> Success: ${otpRes.success}');
  print('  -> Message: ${otpRes.message}');

  print('\n=== LIVE API VERIFICATION COMPLETE ===\n');
}
