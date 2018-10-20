Querifier.configure do |config|
  # This is used to identify the filter params, with this configuration the query should be:
  # ?filter[where][field_name]=something&filter[order][field_name]=desc
  config.where_param  = :where
  config.order_param  = :order
  config.filter_param = :filter
end
