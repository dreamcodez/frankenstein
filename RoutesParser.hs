module RoutesParser where

import Control.Applicative ((<$>))
import Data.Stream
import Text.ParserCombinators.Parsec hiding (parse)
import qualified Text.ParserCombinators.Parsec as Parsec

data Route
  = Route
    { alias    :: String
    , pattern  :: String
    , methods  :: [String]
    }
  deriving (Show)

spacesOrTabs :: Parser ()
spacesOrTabs =
  skipMany1 (oneOf " \t")

parseMethod :: Parser String
parseMethod =
  choice
    [ try $ string "GET"
    , try $ string "POST"
    , try $ string "PUT"
    , try $ string "DELETE"
    , try $ string "SURF"
    ]

parseRoute :: Parser Route
parseRoute = do
  -- alias mandatory, no leading spaces
  alias <- many1 letter
  spacesOrTabs

  -- pattern mandatory
  pattern <- many1 (choice [alphaNum, oneOf "/:"])
  spacesOrTabs

  -- must be at least one method defined for a route
  methods <- parseMethod `sepBy1` spacesOrTabs

  optional spacesOrTabs

  return (Route alias pattern methods)

start :: Parser [Route]
start = do
  -- parse all route lines
  routes <- parseRoute `sepEndBy` eol

  spaces

  return routes

  where eol = do
          _ <- optional (char '\r')
          _ <- char '\n'
          return ()

{-
alias   pattern             methods
-----------------------------------------------
post    /posts/:name        GET SURF PUT DELETE
posts   /posts              POST
foobar  /foo/bar/:car/:dar  GET
-}
parse = Parsec.parse start "RoutesParser"

main = do
  -- input <- readLn
  -- print input
  let input = "post    /posts/:name        GET SURF PUT DELETE\nposts   /posts              POST"
  print (parse input)

