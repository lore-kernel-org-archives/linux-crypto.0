From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: tcrypt: hmac test with keys > blocksize fail
Date: Tue, 06 May 2008 18:28:15 +0800
Message-ID: <E1JtKP9-0004NE-00@gondolin.me.apana.org.au>
References: <481BAD7A.3010003@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org, linux-crypto@ml.breakpoint.cc
To: rueegsegger@swiss-it.ch (Adrian-Ken R??egsegger)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39493 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751348AbYEFK2U (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 May 2008 06:28:20 -0400
In-Reply-To: <481BAD7A.3010003@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adrian-Ken R??egsegger <rueegsegger@swiss-it.ch> wrote:
> 
> using the cryptodev-2.6 tree I noticed that the hmac tests that have
> keys larger than blocksize for md5 and the various sha algorithms all
> fail (tcrypt mode=10[0-5]). The other tests seem to pass just fine.
> 
> The issue seems to have come from commit
> de224c309b5631bdaae3fcd6880cfb93b52f5a53.
> 
> 
> I have tested 48c8949ea8460216783dd33640121187b9531b60 which does not
> contain this bug.  It's just before the various tcrypt-changes from
> Sebastian Siewior.

Actually this just exposed an ancient bug in hmac.  It relied
on the key to be in identity-mapped memory which has never been
guaranteed.

This patch fixes the problem for me.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/hmac.c b/crypto/hmac.c
index b60c3c7..14c6351 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -57,14 +57,35 @@ static int hmac_setkey(struct crypto_hash *parent,
 	if (keylen > bs) {
 		struct hash_desc desc;
 		struct scatterlist tmp;
+		int tmplen;
 		int err;
 
 		desc.tfm = tfm;
 		desc.flags = crypto_hash_get_flags(parent);
 		desc.flags &= CRYPTO_TFM_REQ_MAY_SLEEP;
-		sg_init_one(&tmp, inkey, keylen);
 
-		err = crypto_hash_digest(&desc, &tmp, keylen, digest);
+		err = crypto_hash_init(&desc);
+		if (err)
+			return err;
+
+		tmplen = bs * 2 + ds;
+		sg_init_one(&tmp, ipad, tmplen);
+
+		for (; keylen > tmplen; inkey += tmplen, keylen -= tmplen) {
+			memcpy(ipad, inkey, tmplen);
+			err = crypto_hash_update(&desc, &tmp, tmplen);
+			if (err)
+				return err;
+		}
+
+		if (keylen) {
+			memcpy(ipad, inkey, keylen);
+			err = crypto_hash_update(&desc, &tmp, keylen);
+			if (err)
+				return err;
+		}
+
+		err = crypto_hash_final(&desc, digest);
 		if (err)
 			return err;
 
