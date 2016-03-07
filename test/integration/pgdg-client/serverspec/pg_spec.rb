require 'serverspec'

set :backend, :exec

describe package('postgresql95') do
  it { should be_installed }
end
