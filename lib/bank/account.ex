defmodule Bank.Account do
  require Record
  require Logger
  require Bank.Data

  Record.defrecord :state, [id: 0, date_created: nil, balance: 0, changes: []]

  @timeout 45000

  def new() do
    spawn fn -> init() end
  end

  ## API

  def create(pid, id) do
    send pid, {:attempt_command, {:create, id}}
  end

  def deposit(pid, amount) do
    send pid, {:attempt_command, {:deposit_money, amount}}
  end

  def withdraw_money(pid, amount) do
    send pid, {:attempt_command, {:withdraw_money, amount}}
  end

  def process_unsaved_changes(pid, saver) do
    send pid, {:process_unsaved_changes, saver}
  end

  def load_from_history(pid, events) do
    send pid, {:load_from_history, events}
  end

  def init() do
    state = state()
    loop(state)
  end

  def loop(state = state(id: id)) do
    receive do
      {:apply_event, event} ->
        new_state = apply_event(event, state)
        loop(new_state)

      {:attempt_command, command} ->
        new_state = attempt_command(command, state)
        loop(new_state)

      {:process_unsaved_changes, saver} ->
        id = state(:id)
        saver.(id, :lists.reverse(state(:changes)))
        new_state = state(changes: [])
        loop(new_state)

      {:load_from_history, events} ->
        new_state = apply_many_events(events, state())
        loop(new_state)

      unknown -> 
        Logger.error("Recieved unknown message: #{unknown}")
        loop(state)
    # after
    #   @timeout ->
    #     Bank.AccountRepo.remove_from_cache(id)
    #     exit(:normal)
    end
  end

  def attempt_command({:create, id}, state) do
    event = Bank.Data.account_created(
      id: id, 
      date_created: :calendar.local_time)
    apply_new_event(event, state)
  end

  def attempt_command({:deposit_money, amount}, state) do
    new_balance = state(balance: + amount)
    id = state(:id)
    event = Bank.Data.money_deposited(
      id: id,
      amount: amount,
      new_balance: new_balance,
      transaction_date: :calendar.local_time)
    apply_new_event(event, state)
    IO.puts "Deposit Money"
  end

  def apply_new_event(event, state) do
    IO.puts "Apply New Event"
  end

  def apply_event({:account_created, id: id, date_created: date_created}, state) do
    IO.puts "Apply Event"
  end

  def apply_many_events(event, state) do
    IO.puts "Apply Many Events"
  end
end