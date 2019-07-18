json.<%=plural_table_name%> @<%= plural_table_name %> do |<%= singular_table_name %>|
    json.extract! <%= singular_table_name %>, <%= full_attributes_list %>
end
json.totalCount @<%=plural_table_name%>.total_count