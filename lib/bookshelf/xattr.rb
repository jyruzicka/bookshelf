module Bookshelf
  module XAttr
    class << self
      REGEXP = Regexp.new(['([0-9A-F]{2})']*32*'\s','m')

      def [] file
        code = `xattr -p com.apple.FinderInfo '#{file}' 2>&1`.split(/\s+/m)
        if code.size == 32
          code
        else
          ['00']*32
        end
      end

      def []= file, new_code
        new_code_string = new_code[0,16] * ' ' + "\n" + new_code[16,16] * ' '
        `xattr -wx com.apple.FinderInfo '#{new_code_string}' '#{file}'`
      end

      def flagged? file
        self[file][9] == '0C'
      end

      def unflag! file
        code = self[file]
        code[9] = '00'
        self[file] = code
      end
    end
  end
end