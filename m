From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 1/2] crypto/s390_aes: access .cip instead of .blk in cipher
 mode
Date: Thu, 7 Jan 2010 22:16:18 +0100
Message-ID: <20100107211618.GA20258@Chamillionaire.breakpoint.cc>
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
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59685 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620Ab0AGVQY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Jan 2010 16:16:24 -0500
Content-Disposition: inline
In-Reply-To: <20100107005028.GA32421@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From aff6860829e06f8f7ba5f4a8160a6612e1a6eca7 Mon Sep 17 00:00:00 2001
From: Roel Kluin <roel.kluin@gmail.com>
Date: Thu, 7 Jan 2010 21:55:50 +0100

The fallback code in cipher mode touch the union fallback.blk instead
of fallback.cip. This is wrong because we use the cipher and not the
blockcipher. This did not show any side effects yet because both types /
structs contain the same element right now.

[bigeasy@breakpoint: different commit message, split the patch in two and
                     rebase ]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/s390/crypto/aes_s390.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 6be4503..58f4673 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -78,14 +78,14 @@ static int setkey_fallback_cip(struct crypto_tfm *tfm, const u8 *in_key,
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 	int ret;
 
-	sctx->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	sctx->fallback.blk->base.crt_flags |= (tfm->crt_flags &
+	sctx->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	sctx->fallback.cip->base.crt_flags |= (tfm->crt_flags &
 			CRYPTO_TFM_REQ_MASK);
 
 	ret = crypto_cipher_setkey(sctx->fallback.cip, in_key, key_len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (sctx->fallback.blk->base.crt_flags &
+		tfm->crt_flags |= (sctx->fallback.cip->base.crt_flags &
 				CRYPTO_TFM_RES_MASK);
 	}
 	return ret;
-- 
1.6.6

