module VisualizeRuby
  class Parser
    class If
      def initialize(ast)
        @ast = ast
      end

      # @return [Array<VisualizeRuby::Node>, Array<VisualizeRuby::Edge>]
      def parse
        break_ast

        condition_nodes               = set_conditions(condition)
        on_true_node, on_true_edges   = branch(on_true)
        on_false_node, on_false_edges = branch(on_false) if on_false

        condition_nodes.each do |condition_node|
          edges << Edge.new(name: "true", nodes: [condition_node, on_true_node])
          edges << Edge.new(name: "false", nodes: [condition_node, on_false_node]) if on_false
        end
        edges.concat(on_false_edges) if on_false
        edges.concat(on_true_edges)
        return [nodes, edges]
      end

      def branch(on_bool)
        on_bool_nodes, on_bool_edges = Parser.new(ast: on_bool).parse
        on_bool_node                 = on_bool_nodes.first
        nodes.concat(on_bool_nodes)
        return on_bool_node, on_bool_edges
      end

      private

      def set_conditions(condition)
        condition_nodes, condition_edges = Parser.new(ast: condition).parse
        condition_nodes.first.type       = :decision
        nodes.concat(condition_nodes)
        edges.concat(condition_edges)
        condition_nodes
      end

      attr_reader :condition, :on_true, :on_false

      def break_ast
        @condition, @on_true, @on_false = @ast.children.to_a
      end

      def nodes
        @nodes ||= []
      end

      def edges
        @edges ||= []
      end
    end
  end
end
