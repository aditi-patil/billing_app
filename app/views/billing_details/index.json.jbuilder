json.array!(@billing_details) do |billing_detail|
  json.extract! billing_detail, :id, :event, :paid_date, :location, :amount
  json.url billing_detail_url(billing_detail, format: :json)
end
