json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :customer
  json.url invoice_url(invoice, format: :json)
end
