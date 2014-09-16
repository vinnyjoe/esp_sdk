module EspSdk
  module EndPoints
    class CustomSignatures < Base
      def run(params={})
        submit(run_url, :Post, params)
      end

      private

        def run_url
          "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}/run"
        end

        def required_params
          [:id, :signature, :name, :risk_level]
        end
    end
  end
end