set :stage, :production
server '18.136.64.117', user: 'deployer', roles: %w{app web db}
