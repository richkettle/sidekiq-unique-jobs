# frozen_string_literal: true

RSpec.describe "Issue 676" do
  before do
    stub_const("MyWorker", Class.new do
      include Sidekiq::Worker
      sidekiq_options retry: 0, queue: :default, lock: :until_expired, lock_expiration: 11

      def perform
        puts "in perform"
      end
    end)
  end

  specify do
    expect(MyWorker.perform_async).not_to eq(nil)
    expect(MyWorker.perform_async).to eq(nil)

    sleep(10)
    expect(MyWorker.perform_async).not_to eq(nil)
  end
end
