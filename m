From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HMAC regression
Date: Fri, 29 May 2009 16:19:31 +1000
Message-ID: <20090529061931.GA10003@gondor.apana.org.au>
References: <1243523348.30487.89.camel@martin.hsr.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37819 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227AbZE2GTd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2009 02:19:33 -0400
Content-Disposition: inline
In-Reply-To: <1243523348.30487.89.camel@martin.hsr.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 28, 2009 at 05:09:08PM +0200, Martin Willi wrote:
> 
> Switching the hash implementations to the new shash API introduced a
> regression. HMACs are created incorrectly if the data is scattered over
> multiple pages, resulting in very unreliable IPsec tunnels.

What are the symptoms?

> +		.psize	= 4100,
> +		.digest	= "\x4F\x3B\x6B\xD1\x1A\x2E\xD6\x12\x3D\x5A\xC8\x39\x91\xE3\xC3\x0E\xB6\x51\x85\xA5",

This test vector is wrong.  We don't support vectors longer than
a page without scattering it.  You must set np and tap.  I tried
it using tap = { 4064, 36 } and it worked under cryptodev-2.6.

Here's a patch to detect this for future reference.

commit dfddf5dbe683cfdeb84bd218a1f819c09f5ea44a
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri May 29 16:05:42 2009 +1000

    crypto: testmgr - Check all test vector lengths
    
    As we cannot guarantee the availability of contiguous pages at
    run-time, all test vectors must either fit within a page, or use
    scatter lists.  In some cases vectors were not checked as to
    whether they fit inside a page.  This patch adds all the missing
    checks.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 376ea88..8fcea70 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -185,6 +185,10 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 
 		hash_buff = xbuf[0];
 
+		ret = -EINVAL;
+		if (WARN_ON(template[i].psize > PAGE_SIZE))
+			goto out;
+
 		memcpy(hash_buff, template[i].plaintext, template[i].psize);
 		sg_init_one(&sg[0], hash_buff, template[i].psize);
 
@@ -238,7 +242,11 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 
 			temp = 0;
 			sg_init_table(sg, template[i].np);
+			ret = -EINVAL;
 			for (k = 0; k < template[i].np; k++) {
+				if (WARN_ON(offset_in_page(IDX[k]) +
+					    template[i].tap[k] > PAGE_SIZE))
+					goto out;
 				sg_set_buf(&sg[k],
 					   memcpy(xbuf[IDX[k] >> PAGE_SHIFT] +
 						  offset_in_page(IDX[k]),
@@ -357,6 +365,11 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			input = xbuf[0];
 			assoc = axbuf[0];
 
+			ret = -EINVAL;
+			if (WARN_ON(template[i].ilen > PAGE_SIZE ||
+				    template[i].alen > PAGE_SIZE))
+				goto out;
+
 			memcpy(input, template[i].input, template[i].ilen);
 			memcpy(assoc, template[i].assoc, template[i].alen);
 			if (template[i].iv)
@@ -516,7 +529,11 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			}
 
 			sg_init_table(asg, template[i].anp);
+			ret = -EINVAL;
 			for (k = 0, temp = 0; k < template[i].anp; k++) {
+				if (WARN_ON(offset_in_page(IDX[k]) +
+					    template[i].atap[k] > PAGE_SIZE))
+					goto out;
 				sg_set_buf(&asg[k],
 					   memcpy(axbuf[IDX[k] >> PAGE_SHIFT] +
 						  offset_in_page(IDX[k]),
@@ -650,6 +667,10 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 
 		j++;
 
+		ret = -EINVAL;
+		if (WARN_ON(template[i].ilen > PAGE_SIZE))
+			goto out;
+
 		data = xbuf[0];
 		memcpy(data, template[i].input, template[i].ilen);
 
@@ -741,6 +762,10 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 		if (!(template[i].np)) {
 			j++;
 
+			ret = -EINVAL;
+			if (WARN_ON(template[i].ilen > PAGE_SIZE))
+				goto out;
+
 			data = xbuf[0];
 			memcpy(data, template[i].input, template[i].ilen);
 

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
