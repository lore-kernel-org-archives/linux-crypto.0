Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0258FC88CB4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Jun 2023 09:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239834AbjFMJNo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Jun 2023 05:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbjFMJNn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2023 05:13:43 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61521A7
        for <linux-crypto@vger.kernel.org>; Tue, 13 Jun 2023 02:13:39 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q905n-002L0n-0y; Tue, 13 Jun 2023 17:13:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Jun 2023 17:13:35 +0800
Date:   Tue, 13 Jun 2023 17:13:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: geniv - Split geniv out of AEAD Kconfig option
Message-ID: <ZIgzP2kZyKJu8GuH@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Give geniv its own Kconfig option so that its dependencies are
distinct from that of the AEAD API code.  This also allows it
to be disabled if no IV generators (seqiv/echainiv) are enabled.

Remove the obsolete select on RNG2 by SKCIPHER2 as skcipher IV
generators disappeared long ago.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig  |   19 ++++++++-----------
 crypto/Makefile |    2 +-
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 44292989d070..8b8bb97d1d77 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -71,8 +71,6 @@ config CRYPTO_AEAD
 config CRYPTO_AEAD2
 	tristate
 	select CRYPTO_ALGAPI2
-	select CRYPTO_NULL2
-	select CRYPTO_RNG2
 
 config CRYPTO_SKCIPHER
 	tristate
@@ -82,7 +80,6 @@ config CRYPTO_SKCIPHER
 config CRYPTO_SKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
-	select CRYPTO_RNG2
 
 config CRYPTO_HASH
 	tristate
@@ -834,13 +831,16 @@ config CRYPTO_GCM
 
 	  This is required for IPSec ESP (XFRM_ESP).
 
-config CRYPTO_SEQIV
-	tristate "Sequence Number IV Generator"
+config CRYPTO_GENIV
+	tristate
 	select CRYPTO_AEAD
-	select CRYPTO_SKCIPHER
 	select CRYPTO_NULL
-	select CRYPTO_RNG_DEFAULT
 	select CRYPTO_MANAGER
+	select CRYPTO_RNG_DEFAULT
+
+config CRYPTO_SEQIV
+	tristate "Sequence Number IV Generator"
+	select CRYPTO_GENIV
 	help
 	  Sequence Number IV generator
 
@@ -851,10 +851,7 @@ config CRYPTO_SEQIV
 
 config CRYPTO_ECHAINIV
 	tristate "Encrypted Chain IV Generator"
-	select CRYPTO_AEAD
-	select CRYPTO_NULL
-	select CRYPTO_RNG_DEFAULT
-	select CRYPTO_MANAGER
+	select CRYPTO_GENIV
 	help
 	  Encrypted Chain IV generator
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 45dae478af2b..155ab671a1b4 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -14,7 +14,7 @@ crypto_algapi-y := algapi.o scatterwalk.o $(crypto_algapi-y)
 obj-$(CONFIG_CRYPTO_ALGAPI2) += crypto_algapi.o
 
 obj-$(CONFIG_CRYPTO_AEAD2) += aead.o
-obj-$(CONFIG_CRYPTO_AEAD2) += geniv.o
+obj-$(CONFIG_CRYPTO_GENIV) += geniv.o
 
 obj-$(CONFIG_CRYPTO_SKCIPHER2) += skcipher.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
