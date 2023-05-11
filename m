Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22854C7EE22
	for <linux-crypto@archiver.kernel.org>; Thu, 11 May 2023 04:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjEKE3o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 May 2023 00:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbjEKE3n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 May 2023 00:29:43 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6345F2708
        for <linux-crypto@vger.kernel.org>; Wed, 10 May 2023 21:29:41 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pwxvr-007ZSC-G8; Thu, 11 May 2023 12:29:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 May 2023 12:29:36 +0800
Date:   Thu, 11 May 2023 12:29:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: lib/sha256 - Remove redundant and unused
 sha224_update
Message-ID: <ZFxvMLICNQi8TMdl@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function sha224_update is exactly the same as sha256_update.
Moreover it's not even used in the kernel so it can be removed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/sha2.h |    2 +-
 lib/crypto/sha256.c   |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index 2838f529f31e..b9e9281d76c9 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -128,7 +128,7 @@ static inline void sha224_init(struct sha256_state *sctx)
 	sctx->state[7] = SHA224_H7;
 	sctx->count = 0;
 }
-void sha224_update(struct sha256_state *sctx, const u8 *data, unsigned int len);
+/* Simply use sha256_update as it is equivalent to sha224_update. */
 void sha224_final(struct sha256_state *sctx, u8 *out);
 
 #endif /* _CRYPTO_SHA2_H */
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 72a4b0b1df28..b32b6cc016a8 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -151,12 +151,6 @@ void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 }
 EXPORT_SYMBOL(sha256_update);
 
-void sha224_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
-{
-	sha256_update(sctx, data, len);
-}
-EXPORT_SYMBOL(sha224_update);
-
 static void __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
 {
 	__be32 *dst = (__be32 *)out;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
