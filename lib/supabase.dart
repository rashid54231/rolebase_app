import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // 1️⃣ Initialize Supabase
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://wfczreizzherxoduirxv.supabase.co',  // <-- Yahan apna Supabase URL dalna
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmY3pyZWl6emhlcnhvZHVpcnh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcyNTk5NDQsImV4cCI6MjA4MjgzNTk0NH0.W8HCz3kHWdp1xQqg93gjz2-E6Jhtc-EGaBLX8rYVyiY',                   // <-- Yahan apna anon key dalna
    );
  }

  // 2️⃣ Supabase client use karne ke liye
  static SupabaseClient get client => Supabase.instance.client;
}
