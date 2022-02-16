class TypeformResponse

  def initialize(data)
    @data = data
  end

  def response?
    event_type == 'form_response'
  end

  def answer_for_field(id)
    answer = answers.find { |answer| answer['field']['id'] == id }
    return unless answer
    return answer.fetch('text') if answer['type'] == 'text'
    return answer.fetch('email') if answer['type'] == 'email'
  end

  def form_id
    @data['form_response']['form_id']
  end

  def response_token
    @data['form_response']['token']
  end

  private

  def event_type
    @data['event_type']
  end

  def answers
    @data['form_response']['answers']
  end
end
