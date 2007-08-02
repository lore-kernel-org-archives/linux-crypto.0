From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [patch] crypto: retrieve private ctx aligned
Date: Thu, 2 Aug 2007 09:47:58 +0200
Message-ID: <20070802074758.GB22601@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52381 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902AbXHBHr7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 03:47:59 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is function does the same thing for ablkcipher that is done for
blkcipher by crypto_blkcipher_ctx_aligned(): it returns an aligned
address of the private ctx.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -160,6 +160,11 @@ static inline void *crypto_ablkcipher_ct
 	return crypto_tfm_ctx(&tfm->base);
 }
 
+static inline void *crypto_ablkcipher_ctx_aligned(struct crypto_ablkcipher *tfm)
+{
+	return crypto_tfm_ctx_aligned(&tfm->base);
+}
+
 static inline struct crypto_blkcipher *crypto_spawn_blkcipher(
 	struct crypto_spawn *spawn)
 {
