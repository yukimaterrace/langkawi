# frozen_string_literal: true

require 'rails_helper'

module ApiErrors
  RSpec.describe 'ApiErrors' do
    shared_examples 'has the correct error code and message' do |error_code, error_message|
      it "has the correct error code: #{error_code}" do
        expect(subject.error).to eq(error_code)
      end

      it "has the correct error message: '#{error_message}'" do
        expect(subject.exception).to eq(error_message)
      end
    end

    describe 'UnauthorizedError' do
      subject { UnauthorizedError.new }
      it_behaves_like 'has the correct error code and message', :unauthorized, 'ログインが必要です。'
    end

    describe 'AdminRequiredError' do
      subject { AdminRequiredError.new }
      it_behaves_like 'has the correct error code and message', :forbidden, '管理者権限が必要です。'
    end

    describe 'OwnerRequiredError' do
      subject { OwnerRequiredError.new }
      it_behaves_like 'has the correct error code and message', :forbidden, '本人であることが必要です。'
    end

    describe 'OwnersRequiredError' do
      subject { OwnersRequiredError.new }
      it_behaves_like 'has the correct error code and message', :forbidden, '本人たちであることが必要です。'
    end

    describe 'ParamsValidationError' do
      let(:invalid_keys) { %w[key1 key2 key3] }

      subject { ParamsValidationError.new(invalid_keys) }
      it_behaves_like 'has the correct error code and message', :forbidden, '不正なキー: ["key1", "key2", "key3"]'
    end

    describe 'IdenticalUserError' do
      subject { IdenticalUserError.new }
      it_behaves_like 'has the correct error code and message', :forbidden, '同一ユーザーは禁止されています。'
    end

    describe 'CounterRelationExistError' do
      subject { CounterRelationExistError.new }
      it_behaves_like 'has the correct error code and message', :forbidden, '逆の関係が既に存在します。'
    end

    describe 'AcceptedStatusError' do
      subject { AcceptedStatusError.new }
      it_behaves_like 'has the correct error code and message', :forbidden, '交際中であることが必要です。'
    end

    describe 'EnabledStatusError' do
      subject { EnabledStatusError.new }
      it_behaves_like 'has the correct error code and message', :forbidden, '有効状態であることが必要です。'
    end
  end
end
