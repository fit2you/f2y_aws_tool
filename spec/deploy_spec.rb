require 'f2y_aws_tool'

describe F2yAwsTool::Deploy do

  let(:options) {
    {
        wait: false,
        region: 'region',
        migrate: true,
        stack_id: "stack_id",
        app_id: "app_id",
        log_level: 'ERROR',
        log_aws: false
    }
  }
  let(:credentials){
    {
        access_key_id: "access_key_id",
        secret_access_key: "secret_access_key"
    }
  }

  before(:all) do
    Aws.config[:stub_responses] = {
        create_deployment: {deployment_id: 'deployment_id'},
        describe_deployments: {deployments: [{status: 'running', deployment_id: 'deployment_id'}]}
    }
  end

  it "should return a deployment id" do
    expect(F2yAwsTool::Deploy.new(options.merge(credentials)).run).to eq(deployment_id: "deployment_id", status: :running)
  end

  it "should raise a key error without ENV credentials" do
    expect{F2yAwsTool::Deploy.new(options).run}.to raise_error(KeyError, 'key not found: "AWS_ACCESS_KEY_ID"')
  end

  it "should use ENV credentials if missing access_key_id and secret_access_key" do
    ENV['AWS_ACCESS_KEY_ID'] = credentials.fetch(:access_key_id)
    ENV['AWS_SECRET_ACCESS_KEY'] = credentials.fetch(:secret_access_key)
    expect(F2yAwsTool::Deploy.new(options).run).to eq(deployment_id: "deployment_id", status: :running)
  end

  it "should wait until deploy successful" do
    deploy = F2yAwsTool::Deploy.new(options.merge(credentials).merge(wait: true))
    deploy.client.stub_responses(:describe_deployments, {deployments: [
        {status: 'successful', deployment_id: 'deployment_id', duration: 130}]})
    expect(deploy.run).to eq(deployment_id: "deployment_id", status: :successful)
  end

end