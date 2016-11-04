require 'roo/font'
require 'roo/excelx/extractor'

module Roo
  class Excelx
    class Styles < Excelx::Extractor
      # convert internal excelx attribute to a format
      def style_format(style)
        id = num_fmt_ids[style.to_i]
        num_fmts[id] || Excelx::Format::STANDARD_FORMATS[id.to_i]
      end

      def definitions
        @definitions ||= extract_definitions
      end

      private

      def num_fmt_ids
        @num_fmt_ids ||= extract_num_fmt_ids
      end

      def num_fmts
        @num_fmts ||= extract_num_fmts
      end

      def fonts
        @fonts ||= extract_fonts
      end

      def extract_definitions
        doc.locate('styleSheet/cellXfs').flat_map do |xfs|
          xfs.nodes.map do |xf|
            fonts[xf['fontId'].to_i]
          end
        end
      end

      def extract_fonts
        doc.locate('styleSheet/fonts/font').map do |font_el|
          Font.new.tap do |font|
            font.bold = !font_el.locate('b').empty?
            font.italic = !font_el.locate('i').empty?
            font.underline = !font_el.locate('u').empty?
          end
        end
      end

      def extract_num_fmt_ids
        doc.locate('styleSheet/cellXfs').flat_map do |xfs|
          xfs.nodes.map do |xf|
            xf['numFmtId']
          end
        end
      end

      def extract_num_fmts
        Hash[doc.locate('styleSheet/numFmts/numFmt').map do |num_fmt|
          [num_fmt['numFmtId'], num_fmt['formatCode']]
        end]
      end
    end
  end
end
