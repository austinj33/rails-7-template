class OptimizationsController < ApplicationController
  def create
    assets_params = params[:assets].values
    correlations_params = params[:correlations].to_unsafe_h

    @correlations = correlations_params.map { |_, row_data| row_data.values.map(&:to_f) }
    Rails.logger.debug "Parsed Correlations: #{@correlations.inspect}"
    Rails.logger.debug "Correlation params: #{correlations_params.inspect}"



  
    # Process the asset data
    @assets = assets_params.map do |asset_data|
      {
        name: asset_data[:name],
        expected_return: asset_data[:expected_return].to_f,
        expected_volatility: asset_data[:expected_volatility].to_f,
        min_weight: asset_data[:min_weight].to_f,
        max_weight: asset_data[:max_weight].to_f
      }
    end
  
    # Process the correlation matrix
    @correlations = correlations_params.map { |_, row_data| row_data.values.map(&:to_f) }
  
    # Calculate the efficient frontier
    optimizer = MvoOptimizer.new(@assets, @correlations)
    @frontier = optimizer.efficient_frontier
  
    # Render the show template directly
    render :show
  end
  

  def show
    # @frontier will already be set by the create action
  end
end  
