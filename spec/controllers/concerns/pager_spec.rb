# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pager' do
  let(:dummy_controller) do
    Class.new do
      include Pager

      attr_accessor :params, :page, :page_size

      def initialize(params)
        @params = params
      end
    end
  end

  describe '#set_pager_params' do
    it 'sets the page and page_size instance variables based on the given params' do
      params = ActionController::Parameters.new({ page: '2', page_size: '10' })
      controller = dummy_controller.new(params)

      controller.set_pager_params

      expect([controller.page, controller.page_size]).to match_array([2, 10])
    end
  end

  describe '#pager_response' do
    let(:controller) { dummy_controller.new({}) }
    let(:condition) { instance_double 'Condition' }
    let(:limited_list) { instance_double 'LimitedList' }
    let(:paginated_list) { [1, 2, 3] }

    before do
      stub_const('Condition', Class.new)
      stub_const('LimitedList', Class.new)

      controller.page = 1
      controller.page_size = 3

      allow(condition).to receive(:limit).and_return(limited_list)
      allow(limited_list).to receive(:offset).and_return(paginated_list)
      allow(condition).to receive(:count).and_return(10)
      allow(paginated_list).to receive(:count).and_return(3)
    end

    it 'returns the paginated response' do
      customizer = ->(item) { item * 2 }
      allow(paginated_list).to receive(:map).and_return(paginated_list.map(&customizer))

      result = controller.pager_response(condition, &customizer)
      expect(result).to eq(list: [2, 4, 6], page_size: 3, count: 3, total: 10)
    end
  end
end
