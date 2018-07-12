#!/usr/bin/env ruby

require 'fileutils'


COMMAND = '/usr/local/bin/tree'
PREFIX  = '/Volumes'
OUTPUT  = '/Users/Psy/.trees/'

VOLUMES = {
  'Macintosh HD'  => [],
  'Ouroboros'     => ['Anime'],
  'Core'          => ['Shows'],
}

FLAGS = [
  '--dirsfirst',    # Print directories first
  '--du',           # Print directory/file sizes
  '-h',             # Print them in human-readable format
  '-N',             # Print special characters as-is
  '-F',             # Append symbols for appropriate filetypes
].join(' ')



# Get the full path of the volume
def location(volume)
  File.join(PREFIX, volume)
end


# Check if a volume is mounted
def mounted?(volume)
  if (volume == 'Macintosh HD')
    return true
  else
    not (`mount | grep '#{location(volume)}'`).empty?
  end
end


# Get the full tree of a path
# Consider using json/html tree output
def tree(path)
  `#{COMMAND} #{FLAGS} '#{path}'`
end



# Save the tree of a path
def write_tree(path, name)
  out  = File.join(OUTPUT, "#{name}.txt")
  dir  = File.dirname(out)

  FileUtils.mkdir_p(dir)
  File.write(out, tree(path))
end


# Log a message
def log(tag = 'MAIN', message)
  puts "[#{Time.now}][#{tag}] #{message}"
end


# Fork volume check
def fork_volume_check(v)
  Thread.new do
    if mounted?(v)
      log("Volume '#{v}' mounted.")
      VOLUMES[v].map { |d| fork_tree_write(v,d) }
    else
      log("Volume '#{v}' not mounted. Doing nothing.")
    end
  end
end


# Fork a new process to write
# This is actually blocking - on purpose
def fork_tree_write(volume, dir)
  Thread.new do
    log(volume, "Saving tree for path '#{dir}'.")

    name = File.join(volume, dir)
    path = location(name)

    write_tree(path, name)
    log(volume, "Done! Tree saved for path '#{dir}'.")
  end.join
end


# Main Code
def main
  log('=================== START ===================')
  VOLUMES.keys.map { |v| fork_volume_check(v) }.map(&:join)
  log('==================== END ====================')
rescue => ex
  log('=============== !! CRASHED !! ===============')
  raise ex
end


# Execute Script
main()
