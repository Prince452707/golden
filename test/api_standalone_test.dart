import '../lib/core/api/api_client.dart';
import '../lib/core/api/api_config.dart';

void main() async {
  print('=== VERIFYING REAL NGROK API CONFIGURATION ===');
  print('Target Base URL: ${ApiConfig.baseUrl}');

  final client = ApiClient();

  print('\n[1] Testing Real Network Call to /rates/live on ngrok...');
  final rates = await client.get<Map<String, dynamic>>('/rates/live');
  print('  -> Result: success=${rates.success}, message="${rates.message}"');

  print('\n[2] Testing Real Network Call to /auth/send-otp on ngrok...');
  final sendOtp = await client.post<Map<String, dynamic>>(
    '/auth/send-otp',
    body: {'phoneNumber': '9876543210', 'countryCode': '+91'},
  );
  print('  -> Result: success=${sendOtp.success}, message="${sendOtp.message}"');

  print('\n=== NGROK API VERIFICATION COMPLETE ===\n');
}
