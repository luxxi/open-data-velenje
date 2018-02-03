every :minute do
  runner "Organization.each(&:update_payload)"
end
