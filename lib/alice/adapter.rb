module Alice
  class Adapter
    def call(request)
      raise NotImplementedError, 'Adapters must implement #call'
    end
  end
end
