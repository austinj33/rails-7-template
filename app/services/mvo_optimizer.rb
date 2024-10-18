require 'matrix'

class MvoOptimizer
  def initialize(assets, correlations)
    @assets = assets
    @correlations = correlations
    @num_assets = assets.length
  end

  def efficient_frontier(num_portfolios = 100)
    # Initialize arrays for risk, return, and weights
    portfolios = []

    # Generate covariance matrix from correlation matrix
    covariance_matrix = build_covariance_matrix

    # Calculate mean returns and standard deviations (volatilities)
    returns = @assets.map { |a| a[:expected_return] }
    volatilities = @assets.map { |a| a[:expected_volatility] }

    # Generate random portfolios within constraints
    num_portfolios.times do
      weights = random_weights
      portfolio_return = calculate_portfolio_return(weights, returns)
      portfolio_risk = calculate_portfolio_risk(weights, covariance_matrix)
      
      portfolios << {
        risk: portfolio_risk,
        return: portfolio_return,
        weights: weights
      }
    end

    portfolios.sort_by { |portfolio| portfolio[:risk] } # Sort by risk
  end

  private

  # Function to randomly generate weights that sum to 1
  def random_weights
    weights = Array.new(@num_assets) { rand }
    total_weight = weights.sum
    weights.map { |w| w / total_weight }
  end

  # Calculate portfolio return as weighted sum of asset returns
  def calculate_portfolio_return(weights, returns)
    dot_product(weights, returns)
  end

  # Calculate portfolio risk using the covariance matrix
  def calculate_portfolio_risk(weights, covariance_matrix)
    result = matrix_multiply(matrix_multiply(weights, covariance_matrix), weights)
    Rails.logger.debug "Portfolio Risk Calculation: Weights: #{weights.inspect}, Covariance Matrix: #{covariance_matrix.inspect}, Result: #{result.inspect}"
    result
  end
  

  # Build the covariance matrix based on correlation and individual volatilities
  def build_covariance_matrix
    covariance_matrix = Array.new(@num_assets) { Array.new(@num_assets) }
    
    @num_assets.times do |i|
      @num_assets.times do |j|
        if i >= j
          covariance_matrix[i][j] = @correlations[i][j] * @assets[i][:expected_volatility] * @assets[j][:expected_volatility]
          covariance_matrix[j][i] = covariance_matrix[i][j]
        end
      end
    end
    
    Rails.logger.debug "Covariance Matrix: #{covariance_matrix.inspect}"
    covariance_matrix
  end
  
  

  def dot_product(vector1, vector2)
    vector1.zip(vector2).map { |x, y| x * y }.sum
  end

  def matrix_multiply(matrix, vector)
    Rails.logger.debug "Matrix Multiply: Matrix: #{matrix.inspect}, Vector: #{vector.inspect}"
    result = matrix.map { |row| dot_product(row, vector) }
    Rails.logger.debug "Matrix Multiply Result: #{result.inspect}"
    result
  end
  
end
