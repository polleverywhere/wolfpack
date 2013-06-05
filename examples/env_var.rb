# Sets the WOLFPACK_TEST_INSTANCE env var.
after_fork do |n|
  # puts "Setting variable #{n}"
  ENV['NTH_WOLF'] = "Wolf #{n}"
end