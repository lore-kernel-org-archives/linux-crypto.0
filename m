From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 3] HIFN 795x driver.
Date: Thu, 11 Oct 2007 18:14:00 +0800
Message-ID: <20071011101400.GA17192@gondor.apana.org.au>
References: <20071010152146.GA13379@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3490 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754033AbXJKKOE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 06:14:04 -0400
Content-Disposition: inline
In-Reply-To: <20071010152146.GA13379@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 10, 2007 at 07:21:47PM +0400, Evgeniy Polyakov wrote:
>
> It passed all tests for AES, DES and DES3_EDE except weak test for DES,
> since hardware can not determine weak keys.

Patch applied. Thanks Evgeniy!

BTW, we should change it so that the DES algorithm's setkey
function uses the same weak-key test as used by the generic
DES code.

Oh I had to apply the following fix-up in order for it to build
against cryptodev-2.6.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
diff --git a/arch/s390/crypto/sha256_s390.c b/arch/s390/crypto/sha256_s390.c
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
diff --git a/crypto/sha512.c b/crypto/sha512.c
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 6c446f3..b6c1ee1 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1945,11 +1945,10 @@ static int hifn_handle_req(struct ablkcipher_request *req)
 		err = hifn_setup_session(req);
 
 	if (err == -EAGAIN) {
-		struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 		unsigned long flags;
 
 		spin_lock_irqsave(&dev->lock, flags);
-		err = ablkcipher_enqueue_request(crypto_ablkcipher_alg(tfm), req);
+		err = ablkcipher_enqueue_request(&dev->queue, req);
 		spin_unlock_irqrestore(&dev->lock, flags);
 	}
 
@@ -2359,7 +2358,6 @@ static int hifn_alg_alloc(struct hifn_device *dev, struct hifn_alg_template *t)
 	alg->alg.cra_module = THIS_MODULE;
 	alg->alg.cra_u.ablkcipher = t->ablkcipher;
 	alg->alg.cra_init = hifn_cra_init;
-	alg->alg.cra_ablkcipher.queue = &dev->queue;
 
 	alg->dev = dev;
 
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
