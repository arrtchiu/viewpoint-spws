module Viewpoint
  module Sharepoint
    class ListBuilder
      def initialize(node, opts, &block)
        @node, @opts = node, opts
        instance_eval(&block) if block_given?
      end

      def list_name!(title)
        @node.add('spsoap:listName',title)
      end

      def since!(date)
        @node.add('spsoap:since',date)
      end

      def updates!(batch)
        @node.add('spsoap:updates') do |updates|
          batchbuilder = ListBuilder.new(updates, {}) do
            batch!(batch)
          end
=begin
          updates.add('Batch') do |batch|
            batch.set_attr('OnError','Continue')
            batch.add('Method') do |meth|
              meth.set_attr('ID','0,TestNew')
              meth.set_attr('Cmd','New')
              meth.add('Field', 'Test List Item') do |field|
                field.set_attr('Name','Title')
              end
            end
          end
=end
        end
      end

      def batch!(batch)
        @node.add('Batch') do |b|
          batch.each_pair do |k,v|
            b.add('Method') do |meth|
              meth.set_attr('ID', k)
              meth.set_attr('Cmd',v[:Cmd])
              v[:fields].each_pair do |fk,fv|
                meth.add('Field',fv) do |field|
                  field.set_attr('Name',fk.to_s)
                end
              end
            end
            #     meth_id1 => {:Cmd => 'New', :fields => {:Title => 'My test title'}}
          end
        end
      end
    end # ListBuilder
  end # Sharepoint
end # Viewpoint
