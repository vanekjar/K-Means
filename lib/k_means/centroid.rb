class Centroid
  
  class << self
  
    # initial centroid positions are randomly chosen from within
    # a bounding box that encloses all the nodes
    def create_centroids(amount, nodes)
      ranges = create_ranges(nodes, nodes[0].position.size)
      (1..amount).map do
        position = ranges.inject([]) do |array, range|
          array << rand_between(range[0], range[1])
        end
        new(position)
      end
    end
    
    private
    
    # find centroid ranges as a bounding box for all nodes
    def create_ranges(nodes, dimensions)
      ranges = Array.new(dimensions) {[Float::NAN, Float::NAN]}
      nodes.each do |node|
        node.position.each_with_index do |position, index|
          # Bottom range
          ranges[index][0] = position if ranges[index][0].nan? || position < ranges[index][0]
          # Top range
          ranges[index][1] = position if ranges[index][1].nan? || position > ranges[index][1]
        end
      end
      ranges
    end
  end
  
  attr_accessor :position
  
  def initialize(position)
    @position = position
  end
  
  # Finds the average distance of all the nodes assigned to
  # the centroid and then moves the centroid to that position
  def reposition(nodes, centroids)
    return if nodes.empty?
    averages = [0.0] * nodes[0].position.size
    nodes.each do |node|
      node.position.each_with_index do |position, index|
        averages[index] += position
      end
    end
    @position = averages.map {|x| x / nodes.size}
  end
  
end
