--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
-- import           Hakyll.Contrib.LaTeX
import qualified Data.ByteString.Lazy.Char8
import qualified Text.Jasmine as Js

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  match "images/*" $ do
    route   idRoute
    compile copyFileCompiler
        
  match "css/*.css" $ do
    route   idRoute
    compile compressCssCompiler

  match "scripts/*.js" $ do
    route   idRoute
    compile compressJsCompiler

  match (fromList ["about.md", "contact.markdown"]) $ do
    route   $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

    -- match "pages/*.markdown" $ do
    --   route $ setExtension "html"
    --   compile $ pandocCompiler
    --       >>= loadAndApplyTemplate "templates/post.html"    postCtx
    --       >>= loadAndApplyTemplate "templates/default.html" postCtx
    --       >>= relativizeUrls

    -- match "pages/*.tex" $ do
    --   route $ setExtension "html"
    --   compile $ do
    --           -- renderFormulae <- initFormulaCompilerDataURI 1000 defaultEnv
    --           pandocCompilerWithTransformM defaultHakyllReaderOptions defaultHakyllWriterOptions $ (initFormulaCompilerDataURI 1000 defaultEnv) defaultPandocFormulaOptions
    --     -- >>= withItemBody (unixFilterLBS "rubber-pipe" ["-d"])
    --     -- >>= loadAndApplyTemplate "templates/post.html"    postCtx
    --     -- >>= loadAndApplyTemplate "templates/default.html" postCtx
    --     -- >>= relativizeUrls

    -- match "pages/*.tex" $ do
    --   route $ setExtension "pdf"
    --   compile $ getResourceLBS--pandocCompiler-- getResourceLBS
    --     >>= withItemBody (unixFilterLBS "rubber-pipe" ["-d"])
    --     -- >>= loadAndApplyTemplate "templates/post.html"    postCtx
    --     -- >>= loadAndApplyTemplate "templates/default.html" postCtx
    --     -- >>= relativizeUrls


    match "pubs/*" $ do
      route $ setExtension "html"
      compile $ pandocCompiler
        >>= loadAndApplyTemplate "templates/pub.html"    postCtx
        >>= loadAndApplyTemplate "templates/default.html" postCtx
        >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "pages/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    create ["pubs.html"] $ do
        route idRoute
        compile $ do
            pubs <- recentFirst =<< loadAll "pubs/*"
            let archiveCtx =
                    listField "pubs" postCtx (return pubs) `mappend`
                    constField "title" "Publication"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/pubs.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
          posts <- recentFirst =<< loadAll "posts/*"
          pubs <- recentFirst =<< loadAll "pubs/*"
          let pubIndexCtx =
                listField "posts" postCtx (return posts) `mappend`
                listField "pubs" postCtx (return pubs) `mappend`
                constField "title" "Home"                `mappend`
                defaultContext
            -- let pubIndexCtx =

            --         constField "title" "Home"            `mappend`
                    -- defaultContext
          getResourceBody
                >>= applyAsTemplate pubIndexCtx
                -- >>= applyAsTemplate postIndexCtx
                -- >>= loadAndApplyTemplate "templates/default.html" postIndexCtx
                >>= loadAndApplyTemplate "templates/default.html" pubIndexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

compressJsCompiler:: Compiler (Item String)
compressJsCompiler=  do
  let minifyJs= Data.ByteString.Lazy.Char8.unpack . Js.minify . Data.ByteString.Lazy.Char8.pack . itemBody
  s <- getResourceString
  return $ itemSetBody (minifyJs s) s
  
