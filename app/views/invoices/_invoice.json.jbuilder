json.extract! invoice, :id, :bill_id, :payment_status, :payment_date, :comment, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
