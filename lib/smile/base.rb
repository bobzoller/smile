# 
#  base.rb
#  smile
#  
#  Created by Zac Kleinpeter on 2009-04-28.
#  Copyright 2009 Cajun Country. All rights reserved.
# 
module Smile
  class Base < OpenStruct
    BASE = 'http://api.smugmug.com/hack/json/1.2.0/'
    BASE_SECURE = 'https://api.smugmug.com/hack/json/1.2.0/'
    API = 'HSoqGCJ8ilF42BeThMGDZqqqOgj1eXqN'
    UPLOAD = "http://upload.smugmug.com/"

    VERSION = '1.2.0'
    
    class << self
      attr_accessor :api_key, :logger_on  
      attr_reader :log
      
      def configure
        yield( self ) 
      end

      def session
        @session ||= Session.instance
      end

      def api_key
        @api_key || 'HSoqGCJ8ilF42BeThMGDZqqqOgj1eXqN'
      end

      def logger
        @log ||= Logger.new( STDOUT )
      end

      def logger_on?
        @logger_on
      end

      def clear_config!
        @api_key, @log, @logger_on = nil,nil,nil
      end
      
      # This will be included in every request once you have logged in
      def default_params
        @base ||= { :APIKey => API }
        @base.merge!( :SessionID => session.id ) if( session.id )
        @base
      end
      
      def upper_hash_to_lower_hash( upper )
        if( Hash === upper )
          lower ={}
          upper.each_pair do |key, value|
            lower[key.downcase] = upper_hash_to_lower_hash( value )
          end
          lower
        else
          upper
        end
      end
      
    end
    

    def session
      self.class.session
    end

    def default_params
      self.class.default_params
    end

    def upper_hash_to_lower_hash( hash )
      self.class.upper_hash_to_lower_hash( hash )
    end
  end
end
