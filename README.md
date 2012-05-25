use scotty framework

create dsl for routes, write once, generate client and server side libs

SURF means _method=SURF (with GET real verb),
this will mean send the metadata for this url instead of the whole html rendered

alias   pattern             methods
-----------------------------------------------
post    /posts/:name        GET SURF PUT DELETE
posts   /posts              POST
foobar  /foo/bar/:car/:dar  GET


needs to generate a list of javascript regexps to match on clientside and figure out which route it matches...

also needs to be able to call the route by name w/ arguments to render it for anchors

for example, i can call (in coffeescript):

# by key
uri.post.render({name: 'bob'}) => '/posts/bob'
# positionally
uri.post.render('bob') => '/posts/bob'

no args
uri.posts.render() => '/posts'

# by key
uri.foobar.render({car: '1', dar: '2'}) => '/foo/bar/1/2'
# positionally
uri.foobar.render('1','2') => '/foo/bar/1/2'


# on haskell serverside in scotty, i just define routes like so (or something like it):


$(defineHandler "foobar") $ \params -> do
  let car = (params `lookup` "car")
      dar = (params `lookup` "dar")
  text (car ++ "," ++ dar)
  
# hopefully compiler will catch non-exhaustive pattern match (or something else) when the user has
# not defined handlers for all the routes

# will have to delve into TH a little bit to learn how to grab metadata from dsl to create scotty routes

# need to create parser for dsl of routes

