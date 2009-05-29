From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HMAC regression
Date: Fri, 29 May 2009 16:23:35 +1000
Message-ID: <20090529062335.GA10053@gondor.apana.org.au>
References: <1243523348.30487.89.camel@martin.hsr.ch> <20090529061931.GA10003@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47444 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752815AbZE2GXf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2009 02:23:35 -0400
Content-Disposition: inline
In-Reply-To: <20090529061931.GA10003@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 29, 2009 at 04:19:31PM +1000, Herbert Xu wrote:
> 
> Here's a patch to detect this for future reference.
> 
> commit dfddf5dbe683cfdeb84bd218a1f819c09f5ea44a
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Fri May 29 16:05:42 2009 +1000
> 
>     crypto: testmgr - Check all test vector lengths

I also needed this to actually test your vector.

BTW, please reformat your test vector so that it doesn't exceed
80 columns when you resubmit.

commit 35a20d2814525826700e25529cdbe361d685caf7
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri May 29 16:23:12 2009 +1000

    crypto: testmgr - Allow hash test vectors longer than a page
    
    As it stands we will each test hash vector both linearly and as
    a scatter list if applicable.  This means that we cannot have
    vectors longer than a page, even with scatter lists.
    
    This patch fixes this by skipping test vectors with np != 0 when
    testing linearly.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8fcea70..e9e9d84 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -180,7 +180,12 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   tcrypt_complete, &tresult);
 
+	j = 0;
 	for (i = 0; i < tcount; i++) {
+		if (template[i].np)
+			continue;
+
+		j++;
 		memset(result, 0, 64);
 
 		hash_buff = xbuf[0];
@@ -198,7 +203,7 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 						  template[i].ksize);
 			if (ret) {
 				printk(KERN_ERR "alg: hash: setkey failed on "
-				       "test %d for %s: ret=%d\n", i + 1, algo,
+				       "test %d for %s: ret=%d\n", j, algo,
 				       -ret);
 				goto out;
 			}
@@ -220,14 +225,14 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 			/* fall through */
 		default:
 			printk(KERN_ERR "alg: hash: digest failed on test %d "
-			       "for %s: ret=%d\n", i + 1, algo, -ret);
+			       "for %s: ret=%d\n", j, algo, -ret);
 			goto out;
 		}
 
 		if (memcmp(result, template[i].digest,
 			   crypto_ahash_digestsize(tfm))) {
 			printk(KERN_ERR "alg: hash: Test %d failed for %s\n",
-			       i + 1, algo);
+			       j, algo);
 			hexdump(result, crypto_ahash_digestsize(tfm));
 			ret = -EINVAL;
 			goto out;

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
