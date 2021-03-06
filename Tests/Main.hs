{-# LANGUAGE OverloadedStrings #-}

module Tests.Main where

import           Data.IORef
import           Data.List        (sort)

import           Test.HUnit

import           Main
import           Utils.HtmlParser
import           Utils.UrlParser

--------------------------------------------------------------------------------
-- URLPARSER TESTS

mainTests :: IO()
mainTests = do
  putStrLn ""
  putStrLn "** RUNNING TESTS FOR MAIN **"
  putStrLn ""
  putStrLn "* crawlSubdomain *"
  _ <- runTestTT crawlSubdomainTests
  putStrLn ""
  putStrLn "** COMPLETED TESTS FOR MAIN **"
  putStrLn ""

--------------------------------------------------------------------------------
-- HELPER FUNCTIONS for TESTING

wsort :: Webpage -> Webpage
wsort (Webpage u a l)
  = Webpage u (sort a) (sort l)

--------------------------------------------------------------------------------
-- TEST SUBDOMAINS

expectedWebpageList1 :: [Webpage]
expectedWebpageList1
  = sort [ wsort (Webpage (Url "http:" "qiangfeng.co.uk" "/") expectedAssets1
                          expectedLinks1)
         , wsort (Webpage (Url "http:" "qiangfeng.co.uk" "/CV.pdf") [] [])
         ]

expectedAssets1 :: [Url]
expectedAssets1
  = [ Url "http:" "qiangfeng.co.uk" "/img/flappy-bird.png"
    , Url "http:" "qiangfeng.co.uk" "/img/ethereum.svg"
    , Url "http:" "qiangfeng.co.uk" "/css/global.css"
    , Url "http:" "qiangfeng.co.uk" "/css/normalise.css"
    , Url "https:" "fonts.googleapis.com" "/css"
    ]

expectedLinks1 :: [Url]
expectedLinks1
  = [ Url "http:" "qiangfeng.co.uk" "/CV.pdf"
    , Url "http:" "qiangfeng.co.uk" "/"
    ]

expectedWebpageList2 :: [Webpage]
expectedWebpageList2
  = sort [wsort $ Webpage (Url "http:" "schuller.it" "/") expectedAssets2
                         expectedLinks2]

expectedAssets2 :: [Url]
expectedAssets2
  = [ Url "http:" "schuller.it" "/index-Dateien/C64ready_3.gif"
    , Url "http:" "www.schuller.it" "/index-Dateien/semaine.png"
    , Url "http:" "www.schuller.it" "/index-Dateien/ustar.jpg"
    , Url "http:" "www.schuller.it" "/index-Dateien/asc.png"
    , Url "http:" "www.schuller.it" "/index-Dateien/aria.jpg"
    , Url "http:" "www.schuller.it" "/index-Dateien/MixedEmotions-Logo-300x288.\
                                     \png"
    , Url "http:" "www.schuller.it" "/index-Dateien/sewa-logo.png"
    , Url "http:" "www.schuller.it" "/iHEARu-logo-small.png"
    , Url "http:" "www.schuller.it" "/vocemoapi.png"
    , Url "http:" "www.schuller.it" "/emotass.png"
    , Url "http:" "www.schuller.it" "/index-Dateien/book-stat-small.jpg"
    , Url "http:" "www.schuller.it" "/index-Dateien/book-CMADNL-small.jpg"
    , Url "http:" "www.schuller.it" "/index-Dateien/book-mme-small.jpg"
    , Url "http:" "www.schuller.it" "/index-Dateien/book-cp-small.jpg"
    , Url "http:" "www.schuller.it" "/index-Dateien/book-iaa-small.jpg"
    , Url "http:" "www.schuller.it" "/slide/image-001.jpg"
    , Url "http:" "www.schuller.it" "/index-Dateien/wle-bws-08-12-l-sm.JPG"
    , Url "http:" "www.schuller.it" "/index-Dateien/image002.jpg"
    , Url "http:" "schuller.it" "/style-sl.css"
    , Url "http:" "www.schuller.it" "/slideshow.js"
    ]

expectedLinks2 :: [Url]
expectedLinks2
  = [Url "http:" "schuller.it" "/"]

--------------------------------------------------------------------------------

crawlSubdomainTests :: Test
crawlSubdomainTests
  = test [ "qf" ~: do let currentUrl = parseUrl "qiangfeng.co.uk"
                      seenUrls <- newIORef [currentUrl]
                      actualWebpageList1 <- sort <$> crawlSubdomain currentUrl
                                                                    seenUrls
                      assertEqual "1" (map wsort actualWebpageList1)
                                       expectedWebpageList1
         , "bs" ~: do let currentUrl = parseUrl "schuller.it"
                      seenUrls <- newIORef [currentUrl]
                      actualWebpageList2 <- sort <$> crawlSubdomain currentUrl
                                                                    seenUrls
                      assertEqual "2" (map wsort actualWebpageList2)
                                       expectedWebpageList2
         , "na" ~: do let currentUrl = parseUrl "doesntexist.url"
                      seenUrls <- newIORef [currentUrl]
                      actualWebpageList3 <- sort <$> crawlSubdomain currentUrl
                                                                    seenUrls
                      assertEqual "3" actualWebpageList3 []
         ]
