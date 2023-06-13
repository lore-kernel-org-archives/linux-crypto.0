Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A97CBC7EE29
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Jun 2023 08:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241816AbjFMIts (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Jun 2023 04:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241759AbjFMItc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2023 04:49:32 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF18013A
        for <linux-crypto@vger.kernel.org>; Tue, 13 Jun 2023 01:49:30 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q8ziO-002KWP-RX; Tue, 13 Jun 2023 16:49:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Jun 2023 16:49:24 +0800
Date:   Tue, 13 Jun 2023 16:49:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: algboss - Add missing dependency on RNG2
Message-ID: <ZIgtlD0VjQXT/ZU7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The testmgr code uses crypto_rng without depending on it.  Add
an explicit dependency to Kconfig.

Also sort the MANAGER2 dependencies alphabetically.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index fdf3742f1106..44292989d070 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -143,12 +143,13 @@ config CRYPTO_MANAGER
 
 config CRYPTO_MANAGER2
 	def_tristate CRYPTO_MANAGER || (CRYPTO_MANAGER!=n && CRYPTO_ALGAPI=y)
+	select CRYPTO_ACOMP2
 	select CRYPTO_AEAD2
-	select CRYPTO_HASH2
-	select CRYPTO_SKCIPHER2
 	select CRYPTO_AKCIPHER2
+	select CRYPTO_HASH2
 	select CRYPTO_KPP2
-	select CRYPTO_ACOMP2
+	select CRYPTO_RNG2
+	select CRYPTO_SKCIPHER2
 
 config CRYPTO_USER
 	tristate "Userspace cryptographic algorithm configuration"
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
