require "querifier/version"
require "querifier/config"
require "querifier/queries/base"
require "querifier/queries/where"
require "querifier/queries/order"
require "querifier/queries/default"

# TODO: Add greather than
# TODO: Add lower than
# TODO: Add equal than
module Querifier
  def self.configure
    yield Config
  end
end
