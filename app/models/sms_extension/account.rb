module SmsExtension
  class Account
    include ActiveModel::MassAssignmentSecurity
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :phone_number, type: String
    field :field_name, type: String
    field :consume_phone_number, type: String
    
    NUM_ENTRIES = 4
    TWILIO_SMS_CHAR_PAGE_SIZE = 150
  
    validates :consume_phone_number, :uniqueness => true

    attr_accessible :phone_number, :field_name, :consume_phone_number
  
    has_many :menu_options, :class_name => "SmsExtension::MenuOption", :dependent => :destroy
    has_many :outgoing_text_options, :class_name => "SmsExtension::OutgoingTextOption", :dependent => :destroy
  
    # Builds the message options that is available for the account.
    # For example, #0 for menu screen
    #              #1 for information about objectA (e.g. outage)
    #              #2 for information about objectA
    def text_message_options
      # Get menu options
      menu_options = self.menu_options.where(:type => "MenuOption").all.order_by([:name, :desc])
      options = {}
      options["#0"] = ["menu",""]
    
      menu_options.each_with_index do |option, index|
        i = index+1
        options["#" + i.to_s] = [option.option_name, option.option_format]
      end
    
      options
    end

  private

  end
end
