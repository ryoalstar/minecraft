class FaqController < ApplicationController

  def index

    @questions = Rails.cache.fetch("faq_key")

    if !@questions.nil?
      @questions = JSON.load(@questions)
      response.headers['CACHE'] = 'redis_hit'
    else
      @questions = Faq.all.to_json
      Rails.cache.write("faq_key", @questions, expires_in: 86400.seconds)
      @questions = JSON.load(@questions)
      response.headers['CACHE'] = 'redis_miss'
    end
  end

end
