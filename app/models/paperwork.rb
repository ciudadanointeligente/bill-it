class Paperwork
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill

  before_save :save_bill_uid, :index_paperwork, :define_timeline_status

  field :session, :type => String
  field :date, :type => DateTime
  field :description, :type => String
  field :stage, :type => String
  field :chamber, :type => String
  field :bill_uid, :type => String
  field :timeline_status, :type => String

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

  # The order in which these appear matters. The latter override the previous.
  def timeline_status_hash
    {
      'Descartado' => ['retira', 'retirado'],
      'Rechazado' => ['rechazado', 'rechazo'],
      'Votación' => ['discusión'],
      'Ingreso' => ['ingreso', 'iniciativa'],
      'Inasistencia' => ['insistencia'],
      'Indicaciones' => ['indicaciones', 'indicación'],
      'Informe' => ['informe'],
      'Avanza' => ['pasa a', 'a cámara'],
      'Tramitación Terminada' => ['al ejecutivo'],
      'Urgencia' => ['hace presente la urgencia'],
      'Retiro de Urgencia' => ['retira la urgencia']
    }
  end

  def icon_event
    case self.timeline_status
    when "Ingreso"
      return "introduced.png"
    when "Avanza"
      return "go-forward.png"
    when "Indicaciones"
      return "directives.png"
    when "Votación"
      return "vote.png"
    when "Urgencia"
      return "priority.png"
    when "Rechazado"
      return "rejected.png"
    when "Insistencia"
      return "insistence.png"
    when "Descartado"
      return "discarded.png"
    when "Informe"
      return "report.png"
    when "Retiro de Urgencia"
      return "priority-withdrawal.png"
    when "Tramitación Terminada"
      return "published.png"
    else
      return "paperwork.png"
    end
  end
end