#!/usr/bin/env ruby

require 'fileutils'


PREFIX  = '/Volumes'
OUTPUT  = '/Users/Psy/.trees/'
VOLUMES = {
  'Ouroboros' => ['Anime'],
  'Core'      => ['Shows'],
}


# Get the full path of the volume
def location(volume)
  File.join(PREFIX, volume)
end


# Check if a volume is mounted
def mounted?(volume)
  mount = `mount | grep #{location(volume)}`
  !mount.empty?
end


# Get the full tree of a path
# (Command prints characters as-is)
# Consider using json/html tree output
def tree(path)
  `tree -N #{path}`
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
  VOLUMES.keys.map { |v| fork_volume_check(v) }.map(&:join)
end


# Execute Script
main()