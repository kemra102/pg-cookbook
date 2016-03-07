require 'serverspec'

set :backend, :exec

describe package('postgresql') do
  it { should be_installed }
end
