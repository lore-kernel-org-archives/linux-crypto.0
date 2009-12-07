From: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] geode: PTR_ERR return of wrong pointer in fallback_init_cip()
Date: Mon, 07 Dec 2009 15:14:33 +0100
Message-ID: <4B1D0DC9.5000908@gmail.com>
References: <4B1D02F7.2020505@gmail.com> <20091207134012.GA21388@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sergey Mironov <ierton@gmail.com>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59568 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935156AbZLGONZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2009 09:13:25 -0500
In-Reply-To: <20091207134012.GA21388@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
> This is correct however you missed one spot a few lines above that one.
> Sergey Mironov sent a patch a while ago unfortunatelly a mangled one and
> he hasn't resent it yet.
> Could you please look at [0] for the missing spot? If you had fun fixing
> that one, I've a made a similar mistake in s390's driver [1]. If not
> please say so.

Yes, I found that one too, although I sent a patch in a seperate thread.
You can ignore that and ack this if you like it.
I did not find the additional mistakes, though, so a new patch below.

> [0] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03883.html
> [1] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03888.html
> 
> Sebastian

Thanks,

Roel

 arch/s390/crypto/aes_s390.c |    8 ++++----
 drivers/crypto/geode-aes.c  |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 6118890..58f4673 100644
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
@@ -174,7 +174,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 	if (IS_ERR(sctx->fallback.cip)) {
 		pr_err("Allocating AES fallback algorithm %s failed\n",
 		       name);
-		return PTR_ERR(sctx->fallback.blk);
+		return PTR_ERR(sctx->fallback.cip);
 	}
 
 	return 0;
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
