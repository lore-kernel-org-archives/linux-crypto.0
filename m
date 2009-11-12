From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: Bug in geode-aes.c ?
Date: Thu, 12 Nov 2009 10:09:51 +0100
Message-ID: <20091112090951.GA22434@Chamillionaire.breakpoint.cc>
References: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com>
 <20091111220832.GC18452@Chamillionaire.breakpoint.cc>
 <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Mironov <ierton@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33591 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbZKLJJr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Nov 2009 04:09:47 -0500
Content-Disposition: inline
In-Reply-To: <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sergey Mironov | 2009-11-12 11:36:42 [+0300]:

>From 0a61b446585324a3041ef0a138515ef936a14eb7 Mon Sep 17 00:00:00 2001
>From: Sergey Mironov <ierton@gmail.com>
>Date: Thu, 12 Nov 2009 11:30:02 +0300
>Subject: [PATCH] Fixed typo bugs in geod-aes.c
>
>
>Signed-off-by: Sergey Mironov <ierton@gmail.com>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

I have the feeling that the driver will deadlock anyway. Got to check
this once I find the board......

>---
> drivers/crypto/geode-aes.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
>index 4801162..03e71b1 100644
>--- a/drivers/crypto/geode-aes.c
>+++ b/drivers/crypto/geode-aes.c
>@@ -135,8 +135,8 @@ static int geode_setkey_cip(struct crypto_tfm
>*tfm, const u8 *key,
> 	/*
> 	 * The requested key size is not supported by HW, do a fallback
> 	 */
>-	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
>-	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
>+	op->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
>+	op->fallback.cip->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
>
> 	ret = crypto_cipher_setkey(op->fallback.cip, key, len);
> 	if (ret) {
>@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
>
> 	if (IS_ERR(op->fallback.cip)) {
> 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
>-		return PTR_ERR(op->fallback.blk);
>+		return PTR_ERR(op->fallback.cip);
> 	}
>
> 	return 0;
>-- 
>1.6.4.4
