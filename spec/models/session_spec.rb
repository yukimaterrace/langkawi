# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session, type: :model do
  let(:uuid) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }

  describe '.put' do
    context 'when session does not exist' do
      before { described_class.put(uuid, user_id) }

      it 'creates a new session' do
        expect(described_class.find_by(user_id:)).to be_present
      end

      it 'sets the correct uuid' do
        session = described_class.find_by(user_id:)
        expect(session.uuid).to eq(uuid)
      end

      it 'sets the correct expiration' do
        session = described_class.find_by(user_id:)
        expect(session.expiration).to be > Time.current
      end
    end

    context 'when session already exists' do
      let(:new_uuid) { SecureRandom.uuid }

      before do
        described_class.create(uuid:, user_id:, expiration: described_class.expiration)
        described_class.put(new_uuid, user_id)
      end

      it 'does not create a new session' do
        expect(described_class.where(user_id:).count).to eq(1)
      end

      it 'updates the uuid of the existing session' do
        session = described_class.find_by(user_id:)
        expect(session.uuid).to eq(new_uuid)
      end
    end
  end

  describe '.get' do
    context 'when session is not expired' do
      before do
        described_class.create(uuid:, user_id:, expiration: described_class.expiration)
      end

      it 'returns the user_id' do
        expect(described_class.get(uuid)).to eq(user_id)
      end
    end

    context 'when session is expired' do
      before do
        described_class.create(uuid:, user_id:, expiration: 1.day.ago)
      end

      it 'returns nil' do
        expect(described_class.get(uuid)).to be_nil
      end
    end
  end
end
