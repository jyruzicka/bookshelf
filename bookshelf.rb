#!/usr/bin/env ruby

require 'notify'

# Our notification device
HUB = Notify::NotificationHub.new('bookshelf')

require 'trollop'

# Select global options
opts = Trollop::options do
  opt :verbose, 'Output lots of stuff to stdout'
  opt :dryrun, 'Don\'t copy files'
  opt :log, 'Log errors to notify'
end

# Should we be logging errors? Set from command-line options
LOG_ERRORS = opts[:log]

begin
  # Should we be outputting lots of info to $stdout? From command-line
  VERBOSE = opts[:verbose]

  # Should we be ignoring file system movements? From command-line
  DRYRUN = opts[:dryrun]

  # Require files
  ROOT = File.dirname(File.realpath(__FILE__))
  require "#{ROOT}/lib/bookshelf"

  # This is a running total of books added, pushed, pulled.
  notify_log = {added: 0, pull: 0, push: 0}

  # vputs only outputs if we're verbose.
  vputs "Checking for flagged books..."
  Bookshelf::LocalBook.flagged.each do |lb|
    vputs "  Flagged: #{lb.name}. Copying to remote..."
    lb.copy_to_remote!
    lb.unflag!
    notify_log[:added] += 1
  end

  vputs "Checking remote books to sync..."
  Bookshelf::RemoteBook.all.each do |rb|
    vprint("  Syncing #{rb.relative_path}...")
    result = rb.sync!
    case result
    when :push
      notify_log[:push] += 1
      vputs("local newest.")
    when :pull
      notify_log[:pull] += 1
      vputs("remote newest.")
    else
      vputs("no change.")
    end
  end

  # Run notify if required
  notify_arr = {added: '+', pull: '<', push: '>'}.reduce([]) do |arr, (sym,char)|
    arr << "#{char}#{notify_log[sym]}" if notify_log[sym] > 0; arr
  end

  unless notify_arr.empty?
    HUB.info notify_arr.join(' ')
  end
rescue
  if LOG_ERRORS
    HUB.error $!.message
    exit 1
  else
    raise $!
  end
end