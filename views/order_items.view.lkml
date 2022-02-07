# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: demo_db.order_items ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }
  measure: profit_last_year{
    type: sum
    sql: ${sale_price} ;;
    # link: {
    #   label: "targetdash"
    #   url: "/dashboards-next/366?User+ID={{ order_items.user_id._value }}"
    # }
    filters: {
      field: orders.created_year
      value: "last year"
    } filters: {
      field: orders.status
      value: "Cancelled"
    }
    drill_fields: [users.first_name, users.state, orders.created_date]

    value_format_name: usd_0
  }

  measure: profit_this_year{
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: orders.created_year
      value: "this year"
    }
    value_format_name: usd_0
#     html:
#         ENTER CODE HERE
#     ;;
  }

  measure: delta {
    hidden: yes
    type: number
    sql: (${profit_this_year}/${profit_last_year}) - 1 ;;
    value_format_name: percent_0
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      month_name
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }
  # dimension: history_button {
  #   sql: ${TABLE}.id ;;
  #   html: <a href=
  #       "/explore/lexi_thelook/order_items?fields=order_items.order_id,order_items.count,order_items.created_date,inventory_items.product_id,inventory_items.cost&f[users.id]={{ value }}"
  #       ><button>Order History</button></a>;;
  # }
  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }
}
