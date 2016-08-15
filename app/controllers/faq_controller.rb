class FaqController < ApplicationController

  def index
    @questions = Faq.all
  end

end
