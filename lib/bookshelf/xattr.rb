require 'shellwords'
module Bookshelf
  # The XAttr module allows us to check flagged status on files.
  module XAttr
    class << self
      # Find all flagged files in a particular directory
      def in directory
        `mdfind -onlyin #{directory.shellescape} "kMDItemFSLabel == 6"`.split("\n")
      end

      # Retrieves the flag status for a given file using `xattr`.
      def [] file
        code = `xattr -p com.apple.FinderInfo #{file.shellescape} 2>&1`.split(/\s+/m)
        if code.size == 32
          code
        else
          ['00']*32
        end
      end

      # Sets the flag statys for a given file using `xattr`.
      def []= file, new_code
        new_code_string = new_code[0,16] * ' ' + "\n" + new_code[16,16] * ' '
        `xattr -wx com.apple.FinderInfo #{new_code_string.shellescape} #{file.shellescape}` unless DRYRUN
      end

      # Is a given file flagged?
      def flagged? file
        self[file][9] == '0C'
      end

      # Remove flagged status from a file.
      def unflag! file
        vputs "Unflagging #{file}"
        code = self[file]
        code[9] = '00'
        self[file] = code
      end
    end
  end
end