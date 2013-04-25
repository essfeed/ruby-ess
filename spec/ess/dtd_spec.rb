require 'spec_helper'

module ESS
  describe DTD do
    describe "ESS_ATTRIBUTES" do

      let(:ess_attributes) { DTD::ESS_ATTRIBUTES }

      it 'should say the xmlns attribute is available' do ess_attributes.xmlns.should be_available end
      it 'should say the version attribute is available' do ess_attributes.version.should be_available end
      it 'should say the lang attribute is available' do ess_attributes.lang.should be_available end

      it 'should say the xmlns attribute is mandatory' do ess_attributes.xmlns.should be_mandatory end
      it 'should say the version attribute is mandatory' do ess_attributes.version.should be_mandatory end
      it 'should say the lang attribute is mandatory' do ess_attributes.lang.should be_mandatory end

      it 'should say an invalid parameter is not available' do ess_attributes.invalid.should_not be_available end
      it 'should say an invalid parameter is not mandatory' do ess_attributes.invalid.should_not be_mandatory end
    end

    describe "CHANNEL" do

      let(:channel) { DTD::CHANNEL }

      it 'should say the title element is available' do channel.title.should be_available end
      it 'should say the link element is available' do channel.link.should be_available end
      it 'should say the id element is available' do channel.id.should be_available end
      it 'should say the published element is available' do channel.published.should be_available end
      it 'should say the updated element is available' do channel.updated.should be_available end
      it 'should say the generator element is available' do channel.generator.should be_available end
      it 'should say the rights element is available' do channel.rights.should be_available end
      it 'should say the feed element is available' do channel.feed.should be_available end

      it 'should say the title element is mandatory' do channel.title.should be_mandatory end
      it 'should say the link element is mandatory' do channel.link.should be_mandatory end
      it 'should say the id element is mandatory' do channel.id.should be_mandatory end
      it 'should say the published element is mandatory' do channel.published.should be_mandatory end
      it 'should say the updated element is not mandatory' do channel.updated.should_not be_mandatory end
      it 'should say the generator element is not mandatory' do channel.generator.should_not be_mandatory end
      it 'should say the rights element is not mandatory' do channel.rights.should_not be_mandatory end
      it 'should say the feed element is mandatory' do channel.feed.should be_mandatory end

      it 'should say an invalid parameter is not available' do channel.invalid.should_not be_available end
      it 'should say an invalid parameter is not mandatory' do channel.invalid.should_not be_mandatory end

    end
  end
end

