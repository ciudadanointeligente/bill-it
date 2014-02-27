class Paperwork
# class Papperwork
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill

  before_save :save_bill_uid, :index_paperwork, :define_timeline_status, :set_document_link

  field :session, :type => String
  field :date, :type => DateTime
  field :description, :type => String
  field :stage, :type => String
  field :chamber, :type => String
  field :bill_uid, :type => String
  field :timeline_status, :type => String
  field :document_link, :type => String

  include Sunspot::Mongoid2
  searchable do
    text :session
    time :date
    text :description
    text :stage
    text :chamber
  end

  def save_bill_uid
    bill = Bill.find(self.bill_id)
    self.bill_uid = bill.uid
  end

  def index_paperwork
    Sunspot.index!(self)
  end

  def define_timeline_status
    timeline_status_value = 'Estado por Defecto'
    timeline_status_hash.values.each do |match_strings|
      match_strings.each do |match_string|
        if self.description =~ /(?imx:#{Regexp.quote(match_string)})/
          timeline_status_value = timeline_status_hash.key match_strings
        end
      end
    end
    self.timeline_status = timeline_status_value
  end

  def timeline_status_hash
    {
      'Ingreso' => ['ingreso', 'iniciativa'],
      'Avanza' => ['pasa a'],
      'Indicaciones' => ['indicaciones', 'indicación'],
      'Votación' => ['discusión'],
      'Urgencia' => ['hace presente la urgencia'],
      'Rechazado' => ['rechazado', 'rechazo'],
      'Inasistencia' => ['insistencia'],
      'Descartado' => ['retira', 'retirado'],
      'Informe' => ['informe'],
      'Retiro de Urgencia' => ['retira la urgencia']
    }
  end

  def set_document_link
    documents = Bill.find(self.bill_id).documents
    documents.each do |document|
      stage_match = (clean_string document.stage) == (clean_string self.stage)
      description_match = (clean_string document.step) == (clean_string self.description)
      if document.date == self.date && stage_match && description_match
        self.document_link = document.link
      end
    end
  end

  def clean_string messy_string
    clean_string = messy_string.strip.chomp('.').strip
    clean_string = I18n.transliterate(clean_string, locale: :transliterate_special).downcase
  end

end