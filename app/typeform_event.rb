class TypeformEvent

  def initialize(data)
    @data = data
  end

  def response?
    event_type == 'form_response'
  end

  def answer_for_field(id)
    answer = answers.find { |answer| answer['field']['id'] == id }
    answer && answer.fetch('text')
  end

  private

  def event_type
    @data['event_type']
  end

  def answers
    @data['form_response']['answers']
  end

end
