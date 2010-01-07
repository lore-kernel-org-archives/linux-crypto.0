From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 2/2] crypto/geode_aes: access .cip instead of .blk in
 cipher mode
Date: Thu, 7 Jan 2010 22:17:02 +0100
Message-ID: <20100107211702.GB20258@Chamillionaire.breakpoint.cc>
References: <4B1D02F7.2020505@gmail.com>
 <20091207134012.GA21388@Chamillionaire.breakpoint.cc>
 <4B1D0DC9.5000908@gmail.com>
 <20091211150349.GA736@gondor.apana.org.au>
 <20100106180736.GA9625@Chamillionaire.breakpoint.cc>
 <20100107005028.GA32421@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	Roel Kluin <roel.kluin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sergey Mironov <ierton@gmail.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59692 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753719Ab0AGVRG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Jan 2010 16:17:06 -0500
Content-Disposition: inline
In-Reply-To: <20100107005028.GA32421@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From caa5c9a662be92aa79b2ef1d14a509391cfa9254 Mon Sep 17 00:00:00 2001
From: Roel Kluin <roel.kluin@gmail.com>
Date: Thu, 7 Jan 2010 22:00:26 +0100

The fallback code in cipher mode touch the union fallback.blk instead
of fallback.cip. This is wrong because we use the cipher and not the
blockcipher. This did not show any side effects yet because both types /
structs contain the same element right now.

[bigeasy@breakpoint: different commit message, split the patch in two]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 4801162..03e71b1 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -135,8 +135,8 @@ static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
+	op->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	op->fallback.cip->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
 
 	ret = crypto_cipher_setkey(op->fallback.cip, key, len);
 	if (ret) {
@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 
 	if (IS_ERR(op->fallback.cip)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(op->fallback.blk);
+		return PTR_ERR(op->fallback.cip);
 	}
 
 	return 0;
-- 
1.6.6

