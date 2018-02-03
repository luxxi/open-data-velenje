every :hour do
  Organization.find_each do |o|
    runner "ApiWorker.perform_async(o.id)"
  end
end
