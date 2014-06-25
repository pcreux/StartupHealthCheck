require 'spec_helper'

describe Search do
  let!(:brewhouse) { FactoryGirl.create(:organization, name: "brewhouse") }
  let!(:fullstack) { FactoryGirl.create(:organization, name: "fullstack") }
  let!(:caliper)   { FactoryGirl.create(:organization, name: "caliper")   }
  let!(:gastownlabs) { FactoryGirl.create(:organization, name: "gastownlabs") }

  let!(:boris) { FactoryGirl.create(:user, name: "boris") }
  let!(:kalv) { FactoryGirl.create(:user, name: "kalv") }
  let!(:jenn) { FactoryGirl.create(:user, name: "jenn") }

  let!(:startup) { Type.create!(name: "Startup") }

  before do
    brewhouse.tag_list.add(%w(agency rails software))
    fullstack.tag_list.add(%w(incubator))
    caliper.tag_list.add(%w(rails js software))
    gastownlabs.tag_list.add(%w(agency rails))

    boris.tag_list.add(%w(software))
    kalv.tag_list.add(%w(software developer rails js))
    jenn.tag_list.add(%w(software developer rails))

    brewhouse.types << startup
    caliper.types << startup

    brewhouse.save!
    fullstack.save!
    caliper.save!
    gastownlabs.save!
    boris.save!
    kalv.save!
    jenn.save!

    Organization.reindex
    User.reindex

    # Ensure things are properly setup

    brewhouse.reload
    boris.reload
    expect(brewhouse.tag_list).to include "agency"
    expect(brewhouse.tag_list).to include "rails"

    expect(boris.tag_list).to include "software"
  end

  describe "#call" do
    it "returns brewhouse when I search for brewhouse" do
      r = Search.call(query: "brewhouse")
      expect(r).to eq([brewhouse])
    end

    it "returns nothing when I search for tesla" do
      r = Search.call(query: "tesla")
      expect(r).to be_empty
    end

    it "returns fullstack for the tag incubator" do
      r = Search.call(tags: ["incubator"])
      expect(r).to eq([fullstack])
    end

    it "returns caliper and kalv for the tag rails" do
      r = Search.call(tags: ["js"])
      expect(r).to eq([caliper, kalv])
    end

    it "returns brewhouse for type Startup" do
      r = Search.call(types: [startup.id])
      expect(r).to eq([brewhouse, caliper])
    end

    it "returns brewhouse for type Startup and the tag agency" do
      r = Search.call(tags: ["agency"], types: [startup.id])
      expect(r).to eq([brewhouse])
    end
  end
end
