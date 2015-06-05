require 'spec_helper'

describe Isic::Entity do

  describe '#classify' do

    context 'in english' do

      let(:class_classification) { Isic::Entity.new("0891").classify }
      let(:group_classification) { Isic::Entity.new("089").classify }
      let(:division_classification) { Isic::Entity.new("08").classify }
      let(:section_classification) { Isic::Entity.new("B").classify }

      it "class is classified with section, division, group and class" do
        expect(class_classification).to eq({
                                             :class => {:code => "0891", :description => "Mining of chemical and fertilizer minerals"},
                                             :group => {:code => "089", :description => "Mining and quarrying n.e.c."},
                                             :division => {:code => "08", :description => "Other mining and quarrying"},
                                             :section => {:code => "B", :description => "Mining and quarrying"}
                                           })
      end

      it "group is classified with section, division and group" do
        expect(group_classification).to eq({
                                             :group => {:code => "089", :description => "Mining and quarrying n.e.c."},
                                             :division => {:code => "08", :description => "Other mining and quarrying"},
                                             :section => {:code => "B", :description => "Mining and quarrying"}
                                           })
      end

      it "division is classified with section and division" do
        expect(division_classification).to eq({
                                                :division => {:code => "08", :description => "Other mining and quarrying"},
                                                :section => {:code => "B", :description => "Mining and quarrying"}
                                              })
      end

      it "section is classified with section" do
        expect(section_classification).to eq({
                                               :section => {:code => "B", :description => "Mining and quarrying"}
                                             })
      end
      
    end

    context 'in spanish' do

      let(:class_classification) { Isic::Entity.new("0891").classify(translation: :es) }

      it "classifies with section, division, group and class" do
        expect(class_classification).to eq({
                                             :class => {:code => "0891", :description => "Extracción de minerales para la fabricación de abonos y productos químicos"},
                                             :group => {:code => "089", :description => "Explotación de minas y canteras n.c.p."},
                                             :division => {:code => "08", :description => "Explotación de otras minas y canteras"},
                                             :section => {:code => "B", :description => "Explotación de minas y canteras"}
                                           })
      end

    end

    context 'in french' do

      let(:class_classification) { Isic::Entity.new("0891").classify(translation: :fr) }

      it "classifies with section, division, group and class" do
        expect(class_classification).to eq({
                                             :class => {:code => "0891", :description => "Extraction de minerais pour l'industrie chimique et d'engrais naturels"},
                                             :group => {:code => "089", :description => "Activités extractives, n.c.a."},
                                             :division => {:code => "08", :description => "Autres activités extractives"},
                                             :section => {:code => "B", :description => "Activités extractives"}
                                           })
      end

    end

  end
  
  describe '#level' do
    let(:new_group) { Isic::Entity.new('089') }
    let(:nil_entity) { Isic::Entity.new(nil) }
    let(:all_classes_of_new_group) { [
      Isic::Entity.new("0891").classify,
      Isic::Entity.new("0892").classify,
      Isic::Entity.new("0893").classify,
      Isic::Entity.new("0899").classify
    ] }

    it "type gives the hierarchical level" do
      expect(new_group.level).to eq :group
      expect(nil_entity.level).to eq :none
    end
  end
  
  describe '#subcategories' do
    let(:new_group) { Isic::Entity.new('089') }
    let(:nil_entity) { Isic::Entity.new(nil) }
    #let(:all_classes_of_new_group) { [
    #  Isic::Entity.new("0891"),
    #  Isic::Entity.new("0892"),
    #  Isic::Entity.new("0893"),
    #  Isic::Entity.new("0899")
    #] }
    #let(:new_section) { Isic::Entity.new('U') }
    #let(:all_divisions_of_new_section) { [ Isic::Entity.new('99') ] }
    #let(:new_division) { Isic::Entity.new('99') }
    #let(:all_groups_of_new_division) { [ Isic::Entity.new('990') ] }

    let(:all_classes_of_new_group) {
      [ {:code=>"0891", :description=>"Mining of chemical and fertilizer minerals"},
        {:code=>"0892", :description=>"Extraction of peat"},
        {:code=>"0893", :description=>"Extraction of salt"},
        {:code=>"0899", :description=>"Other mining and quarrying n.e.c."}
      ]
    }
    let(:new_section) { Isic::Entity.new('U') }
    let(:all_divisions_of_new_section) {
      [{:code=>"99", :description=>"Activities of extraterritorial organizations and bodies"}]
    }
    let(:new_division) { Isic::Entity.new('99') }
    let(:all_groups_of_new_division) {
      [{:code=>"990", :description=>"Activities of extraterritorial organizations and bodies"}]
    }
    
    #context 'in English' do
      
      it "can list all subcategories of the current level" do
        expect(new_group.subcategories).to eq all_classes_of_new_group
        expect(new_section.subcategories).to eq all_divisions_of_new_section
        expect(new_division.subcategories).to eq all_groups_of_new_division
        expect(nil_entity.subcategories).to eq Isic::sections
      end
      
    #end
  end
  
  describe '#==' do
    let(:new_group) { Isic::Entity.new('089') }
    let(:the_same_new_group) { Isic::Entity.new('089') }

    it "can determine if two entities share the same code" do
      expect(new_group).to eq the_same_new_group
    end
  end
  
  describe '#exists?' do
    real = Isic::Entity.new('089')
    fake = Isic::Entity.new('995')
    
    it "can tell whether the given code exists in the ISIC definition" do
      expect(real.exists?).to eq true
      expect(fake.exists?).to eq false
    end
  end
  
  describe '#description' do
    let(:klass)    { Isic::Entity.new("0891") }
    let(:group)    { Isic::Entity.new("089") }
    let(:division) { Isic::Entity.new("08") }
    let(:section)  { Isic::Entity.new("B") }
    let(:nil_entity)  { Isic::Entity.new(nil) }
    
    context 'in English' do
      it "provides the lowest level description of an Entity" do
        expect(section.description).to eq  "Mining and quarrying"
        expect(division.description).to eq "Other mining and quarrying"
        expect(group.description).to eq    "Mining and quarrying n.e.c."
        expect(klass.description).to eq    "Mining of chemical and fertilizer minerals"
        expect(nil_entity.description).to eq ""
      end
    end
  end
end