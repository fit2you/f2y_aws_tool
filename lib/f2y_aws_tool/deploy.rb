module F2yAwsTool
  class Deploy

    def initialize(options)
      @options = options
    end

    def run
      deploy_id = create_deployment.deployment_id
      deployed_app = describe_deployment(deploy_id)
      log.info(sprintf("ID: %s, STATUS: %s", deploy_id, deployed_app.status))
      if wait?
        client.wait_until(:deployment_successful, deployment_ids: [deploy_id])
        deployed_app = describe_deployment(deploy_id)
        log.info(sprintf("ID: %s, STATUS: %s, DURATION: %s", deploy_id, deployed_app.status, Time.at(deployed_app.duration).utc.strftime("%H:%M:%S")))
      end
      return {deployment_id: deploy_id, status: deployed_app.status.to_sym}
    end

    def client
      @client ||= Aws::OpsWorks::Client.new(
          region: region,
          access_key_id: access_key_id,
          secret_access_key: secret_access_key,
          logger: aws_logger,
          log_level: aws_log_level
      )
    end

    private

    def describe_deployment(deploy_id)
      client.describe_deployments({deployment_ids: [deploy_id]}).deployments.first
    end


    def access_key_id
      @access_key_id ||= @options.fetch(:access_key_id){ENV.fetch('AWS_ACCESS_KEY_ID')}
    end

    def secret_access_key
      @secret_access_key ||= @options.fetch(:secret_access_key){ENV.fetch('AWS_SECRET_ACCESS_KEY')}
    end

    def stack_id
      @stack_id ||= config.fetch(:stack_id)
    end

    def app_id
      @app_id ||= config.fetch(:app_id)
    end

    def region
      @region ||= config.fetch(:region){ENV.fetch('AWS_REGION')}
    end

    def migrate?
      @migrate ||= @options.fetch(:migrate)
    end

    def wait?
      @wait ||= @options.fetch(:wait)
    end

    def log_level
      @log_level ||= @options.fetch(:log_level)
    end

    def comment
      @comment ||= @options.fetch(:comment)
    end

    def aws_logger
      @log_aws ||= @options.fetch(:log_aws) ? log : nil
    end

    def aws_log_level
      @aws_log_level ||= log_level.downcase.to_sym
    end

    def log
      @log ||= F2yAwsTool.log(log_level)
    end

    def create_deployment
      client.create_deployment(
          {
              stack_id: stack_id,
              app_id: app_id,
              command: {
                  name: "deploy",
                  args: {"migrate" => ["#{migrate?}"]},
              },
              comment: comment
          }
      )
    end

    def target
      @target ||= HashWithIndifferentAccess.new(@options.fetch(:target))
    end

    def config
      @config ||= begin
        HashWithIndifferentAccess.new(YAML.load(File.read(target.fetch(:file))))
      rescue KeyError
        target
      end
    end



  end

end
