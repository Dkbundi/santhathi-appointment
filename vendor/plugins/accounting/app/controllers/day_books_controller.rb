class DayBooksController < ApplicationController
  layout 'accounting'

  def show
    @date_for = current_day.for_date
    @account_transactions = user_default_branch.current_accounting_period.account_transaction_items.find_by_sql("SELECT a2.transaction_type, case when account_transaction_items.transaction_type = 'C' then a2.account_id else account_transaction_items.account_id end as 'account_id', SUM(account_transaction_items.amount) as 'amount', account_transaction_items.category, account_transaction_items.account_transaction_id, account_transaction_items.transaction_date as 'transaction_date' FROM `account_transaction_items` inner join account_transaction_items a2 on account_transaction_items.parent_id = a2.id WHERE (account_transaction_items.category = 'Credit' and account_transaction_items.transaction_type != 'C') and account_transaction_items.branch_id = #{user_default_branch.id} and account_transaction_items.accounting_period_id = #{current_accounting_period.id} GROUP BY transaction_date, account_id, a2.transaction_type
UNION
SELECT a2.transaction_type, case when account_transaction_items.transaction_type = 'C' then a2.account_id else account_transaction_items.account_id end as 'account_id', SUM(a2.amount) as 'amount', account_transaction_items.category, account_transaction_items.account_transaction_id, account_transaction_items.transaction_date as 'transaction_date' FROM `account_transaction_items` inner join account_transaction_items a2 on account_transaction_items.id = a2.parent_id WHERE (account_transaction_items.category = 'Credit' and account_transaction_items.parent_id = -1 and account_transaction_items.transaction_type = 'G') and account_transaction_items.branch_id = #{user_default_branch.id} and account_transaction_items.accounting_period_id = #{current_accounting_period.id} GROUP BY transaction_date, account_id, a2.transaction_type 
UNION
SELECT a2.transaction_type, case when account_transaction_items.transaction_type = 'C' then a2.account_id else account_transaction_items.account_id end as 'account_id', SUM(account_transaction_items.amount) as 'amount', account_transaction_items.category, account_transaction_items.account_transaction_id, account_transaction_items.transaction_date as 'transaction_date' FROM `account_transaction_items` inner join account_transaction_items a2 on account_transaction_items.parent_id = a2.id WHERE (account_transaction_items.category = 'Debit' and account_transaction_items.transaction_type != 'C') and account_transaction_items.branch_id = #{user_default_branch.id} and account_transaction_items.accounting_period_id = #{current_accounting_period.id} GROUP BY transaction_date, account_id, a2.transaction_type
UNION
SELECT a2.transaction_type, case when account_transaction_items.transaction_type = 'C' then a2.account_id else account_transaction_items.account_id end as 'account_id', SUM(a2.amount) as 'amount', account_transaction_items.category, account_transaction_items.account_transaction_id, account_transaction_items.transaction_date as 'transaction_date' FROM `account_transaction_items` inner join account_transaction_items a2 on account_transaction_items.id = a2.parent_id WHERE (account_transaction_items.category = 'Debit' and account_transaction_items.parent_id = -1 and account_transaction_items.transaction_type = 'G') and account_transaction_items.branch_id = #{user_default_branch.id} and account_transaction_items.accounting_period_id = #{current_accounting_period.id} GROUP BY transaction_date, account_id, a2.transaction_type ORDER BY transaction_date, category")
   
  end
end