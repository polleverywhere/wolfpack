# Sets the WOLFPACK_TEST_INSTANCE env var.
before_exec do |n|
  # puts "Setting variable #{n}"
  ENV['NTH_WOLF'] = "Wolf #{n}"
end