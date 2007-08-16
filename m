From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 02/10] crypto: retrieve private ctx aligned
Date: Thu, 16 Aug 2007 22:01:07 +0200
Message-ID: <20070816200135.088528000@ml.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60611 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbXHPUFz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:55 -0400
Content-Disposition: inline; filename=crypto_ctx_alignment.diff
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

-- 
