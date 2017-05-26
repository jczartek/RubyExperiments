# This module defines methods and operators for functional programming.

module Functional

  # Apply this function to each elements of the specified Enumerable,
  # returinig an array of results. This is the reverse of Enumerable.map

  # Use | as an operator alias. Read "|" as "over" or "applied over".
  def apply(enum)
    enum.map &self
  end
  alias | apply

  # Use this function to "reduce" an enumerable to a single quantity.
  # This is the inverse of Enumerable.inject
  # Use <= as an operator alias
  # Mnemonic: <= looks like a needle for injections
  def reduce(enum)
    enum.inject &self
  end

  # Return a new lambda that computes self[f[args]].
  # Use * as an operator alias for compose.
  # Examples, using the * alias for this method.
  def compose(f)
    if self.respond_to?(:arity) && self.arity == 1
      lambda { |*args| self[f[*args]] }
    else
      lambda { |*args| self[*f[*args]] }
    end
  end
  # * is the natural operator for function composition.
  alias * compose
end
# Add these functional programming methods to Proc and Method classed.
class Proc; include Functional; end
class Method; include Functional; end
