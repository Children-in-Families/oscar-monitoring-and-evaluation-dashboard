set :stage, :production
server '3.1.66.2', user: 'deployer', roles: %w{app web db}
