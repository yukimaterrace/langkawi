# frozen_string_literal: true

require 'rails_helper'

module ApiErrors
  RSpec.describe 'ApiErrors' do
    describe 'UnauthorizedError' do
      subject { UnauthorizedError.new }

      it 'has the correct error code and message' do
        expect(subject.error).to eq(:unauthorized)
        expect(subject.exception).to eq('ログインが必要です。')
      end
    end

    describe 'AdminRequiredError' do
      subject { AdminRequiredError.new }

      it 'has the correct error code and message' do
        expect(subject.error).to eq(:forbidden)
        expect(subject.exception).to eq('管理者権限が必要です。')
      end
    end

    describe 'OwnerRequiredError' do
      subject { OwnerRequiredError.new }

      it 'has the correct error code and message' do
        expect(subject.error).to eq(:forbidden)
        expect(subject.exception).to eq('本人であることが必要です。')
      end
    end

    describe 'OwnersRequiredError' do
      subject { OwnersRequiredError.new }

      it 'has the correct error code and message' do
        expect(subject.error).to eq(:forbidden)
        expect(subject.exception).to eq('本人たちであることが必要です。')
      end
    end

    describe 'ParamsValidationError' do
      let(:invalid_keys) { %w[key1 key2 key3] }
      subject { ParamsValidationError.new(invalid_keys) }

      it 'has the correct error code and message' do
        expect(subject.error).to eq(:forbidden)
        expect(subject.exception).to eq('不正なキー: ["key1", "key2", "key3"]')
      end
    end

    describe 'IdenticalUserError' do
      subject { IdenticalUserError.new }

      it 'has the correct error code and message' do
        expect(subject.error).to eq(:forbidden)
        expect(subject.exception).to eq('同一ユーザーは禁止されています。')
      end
    end

    describe 'CounterRelationExistError' do
      subject { CounterRelationExistError.new }

      it 'has the correct error code and message' do
        expect(subject.error).to eq(:forbidden)
        expect(subject.exception).to eq('逆の関係が既に存在します。')
      end
    end

    describe 'AcceptedStatusError' do
      subject { AcceptedStatusError.new }

      it 'has the correct error code and message' do
        expect(subject.error).to eq(:forbidden)
        expect(subject.exception).to eq('交際中であることが必要です。')
      end
    end

    describe 'EnabledStatusError' do
      subject { EnabledStatusError.new }

      it 'has the correct error code and message' do
        expect(subject.error).to eq(:forbidden)
        expect(subject.exception).to eq('有効状態であることが必要です。')
      end
    end
  end
end
