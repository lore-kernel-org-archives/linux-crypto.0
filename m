From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: Bug in geode-aes.c ?
Date: Fri, 20 Nov 2009 11:30:32 +0100
Message-ID: <20091120103032.GA16608@Chamillionaire.breakpoint.cc>
References: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com>
 <20091111220832.GC18452@Chamillionaire.breakpoint.cc>
 <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com>
 <20091112091807.GC22434@Chamillionaire.breakpoint.cc>
 <aa09d86e0911120218w3e1b640m91772d1859018ea9@mail.gmail.com>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Mironov <ierton@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36539 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbZKTKa1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Nov 2009 05:30:27 -0500
Content-Disposition: inline
In-Reply-To: <aa09d86e0911120218w3e1b640m91772d1859018ea9@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From 335b39e0c55a1dba13cda3e8222947f2cb4120ed Mon Sep 17 00:00:00 2001
>From: Sergey Mironov <ierton@gmail.com>
>Date: Thu, 12 Nov 2009 13:10:05 +0300
>Subject: [PATCH 2/2] aes_s390: access fallback.cip cipher fallback mode
>
>|The fallback code in cipher mode touch the union fallback.blk instead
>|of fallback.cip. This is wrong because we use the cipher and not the
>|blockcipher. This did not show any side effects yet because both types /
>|structs contain the same element right now.
>
>Signed-off-by: Sergey Mironov <ierton@gmail.com>

Looks good.

>---
> arch/s390/crypto/aes_s390.c |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
>index e33f32b..6f0f8b9 100644
>--- a/arch/s390/crypto/aes_s390.c
>+++ b/arch/s390/crypto/aes_s390.c
>@@ -75,14 +75,14 @@ static int setkey_fallback_cip(struct crypto_tfm
>*tfm, const u8 *in_key,
> 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
> 	int ret;
>
>-	sctx->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
>-	sctx->fallback.blk->base.crt_flags |= (tfm->crt_flags &
>+	sctx->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
>+	sctx->fallback.cip->base.crt_flags |= (tfm->crt_flags &
> 			CRYPTO_TFM_REQ_MASK);
>
> 	ret = crypto_cipher_setkey(sctx->fallback.cip, in_key, key_len);
> 	if (ret) {
> 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
>-		tfm->crt_flags |= (sctx->fallback.blk->base.crt_flags &
>+		tfm->crt_flags |= (sctx->fallback.cip->base.crt_flags &
> 				CRYPTO_TFM_RES_MASK);
> 	}
> 	return ret;
>@@ -170,7 +170,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
>
> 	if (IS_ERR(sctx->fallback.cip)) {
> 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
>-		return PTR_ERR(sctx->fallback.blk);
>+		return PTR_ERR(sctx->fallback.cip);
> 	}
>
> 	return 0;
>-- 
>1.6.4.4
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
