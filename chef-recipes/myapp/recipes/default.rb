
include_recipe "ghc"

# XXX will want to link nodejs up to zeromq as well...
include_recipe "nodejs"

# XXX this should perhaps go somewhere else, but for now, i like having this always
#package 'tmux'
#package 'vim'

# XXX may want to compile from source in future, but for now, meh
# package version is 2.1~ and latest stable is 2.2 and they already have an RC for 3.2
package 'libzmq-dev'

