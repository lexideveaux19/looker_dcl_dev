# The name of this view in Looker is "Orders"
view: orders {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Status" in Explore.

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }


  dimension: status_with_link {
    type: string
    sql: ${TABLE}.status ;;
    link: {
      label: "Brands Dashboard"
      url: "/dashboards-next/2024?Status={{ value }}&State={{ _filters['users.state'] | url_encode }}&City={{ _filters['users.city'] | url_encode }}"
    }
  }


  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  measure: 30_day_repeat_purchase_rate {
    label: "30 Day Repeat Purchase Rate"
    group_label: "Repeat Purchase Metrics"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_with_repeat_purchase_within_30d} / NULLIF(${count},0) ;;
    description: "Number of ordered items with repeat purchase / count of all orderes"
  }
  measure: count_with_repeat_purchase_within_30d {
    label: "Count With Repeat Purchase Within 30d"
    group_label: "Repeat Purchase Metrics"
    type: count_distinct
    sql: ${id} ;;
    description: "Number of ordered items with repeat purchases from same user within 30 days"
  }
  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      billion_orders.count,
      fakeorders.count,
      hundred_million_orders.count,
      hundred_million_orders_wide.count,
      order_items.count,
      ten_million_orders.count
    ]
  }
}
