require 'ostruct'

module MyApp

  class TransactionScript
    def self.run(inputs)
      self.new.run(inputs)
    end

    def failure(error_sym, data={})
      OpenStruct.new(data.merge(error: error_sym, success?: false))
    end

    def success(data={})
      OpenStruct.new(data.merge(success?: true))
    end
  end
end
