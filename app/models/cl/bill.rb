class Cl::Bill < Bill
  include Mongoid::Document
  include Mongoid::Timestamps
  
  after_save :set_current_priority

  has_many :paperworks, autosave: true, class_name: "Cl::Paperwork"
  has_many :priorities, autosave: true, class_name: "Cl::Priority"
  has_many :reports, autosave: true, class_name: "Cl::Report"
  has_many :documents, autosave: true, class_name: "Cl::Document"
  has_many :directives, autosave: true, class_name: "Cl::Directive"
  has_many :remarks, autosave: true, class_name: "Cl::Remark"
  embeds_many :revisions, class_name: "Cl::Revision"

  field :source, type: String
  field :initial_chamber, type: String
  field :current_priority, type: String
  field :stage, type: String
  field :sub_stage, type: String
  field :merged_bills, type: String
  field :subject_areas, type: Array

  include Sunspot::Mongoid2
  searchable do
    text :short_uid
    text :source
    text :initial_chamber
    text :current_priority
    text :stage
    text :sub_stage
    text :subject_areas
    time :updated_at
    #attachment type has to be a uri (local or remote)
    #if it's a string it will not get indexed
    attachment :law_text

    text :uid
    text :title
    text :abstract
    text :status
    text :authors
    time :creation_date
    time :publish_date
    text :tags
    time :updated_at
    #attachment type has to be a uri (local or remote)
    #if it's a string it will not get indexed
    attachment :bill_draft
  end

  def get_current_priority
    return "Sin urgencia" if priorities.blank?

    latest_priority = priorities.desc(:entry_date).first
    return "Sin urgencia" if latest_priority.type == "Sin urgencia"
    
    days_in_force = case latest_priority.type
      when "Discusión inmediata"
        2
      when "Suma"
        5
      when "Simple"
        10
      else
        return "Sin urgencia"
    end

    if (days_in_force.business_days.after latest_priority.entry_date) >= Date.today
      latest_priority.type
    else
      "Sin urgencia"
    end
  end

  def set_current_priority
    self.current_priority = get_current_priority
  end

  def law_id
    self.resulting_document.gsub(/Ley[^\d]*(\d+)\.?(\d*)/, '\1\2') if resulting_document =~ /Ley[^\d]*(\d+)\.?(\d*)/
  end

  def law_xml_link
    if !self.law_id.blank?
      "http://www.leychile.cl/Consulta/obtxml?opt=7&idLey=" + law_id
    end
  end

  def law_web_link
    if !self.law_id.blank?
      "http://www.leychile.cl/Navegar?idLey=" + law_id
    end
  end

  def short_uid
    self.uid.split("-")[0]
  end

  # The method below only exist so the query field has a nicer name
  def law_text
    law_xml_link
  end

  def icon
    if ! self.status.blank?
      case self.status.strip
      when "Archivado"
        return 'filed.png'
      when "Publicado"
        return 'published.png'
      when "En tramitación"
        return 'paperwork.png' #icono pendiente 
      when "Rechazado"
        return 'rejected.png' 
      when "Retirado"
        return 'discarded.png' 
      else
        return 'paperwork.png'
      end
    end
    return 'paperwork.png'
  end
end