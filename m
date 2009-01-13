From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: kernel BUG at crypto/scatterwalk.c:37! when using modified
	tcrypt for HMAC testing
Date: Tue, 13 Jan 2009 11:37:04 +1100
Message-ID: <20090113003704.GA13775@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: djenkins@mvista.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58541 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752248AbZAMAhJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Jan 2009 19:37:09 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dean Jenkins <djenkins@mvista.com> wrote:
>
> I'm using a 2.6.27.4 kernel on an armv5te platform.
> 
> I hit a BUG() at crypto/scatterwalk.c:37 that indicates that the scatterlist 
> length is zero.
> 
> I've traced this back to crypto/authenc.c function crypto_authenc_genicv()...

Does this patch fix it?

commit 700aa8bfa071875cda833f44491d3548ad79951e
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Jan 13 11:26:18 2009 +1100

    crypto: authenc - Fix zero-length IV crash
    
    As it is if an algorithm with a zero-length IV is used (e.g.,
    NULL encryption) with authenc, authenc may generate an SG entry
    of length zero, which will trigger a BUG check in the hash layer.
    
    This patch fixes it by skipping the IV SG generation if the IV
    size is zero.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 40b6e9e..5793b64 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -158,16 +158,19 @@ static int crypto_authenc_genicv(struct aead_request *req, u8 *iv,
 	dstp = sg_page(dst);
 	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;
 
-	sg_init_table(cipher, 2);
-	sg_set_buf(cipher, iv, ivsize);
-	authenc_chain(cipher, dst, vdst == iv + ivsize);
+	if (ivsize) {
+		sg_init_table(cipher, 2);
+		sg_set_buf(cipher, iv, ivsize);
+		authenc_chain(cipher, dst, vdst == iv + ivsize);
+		dst = cipher;
+	}
 
 	cryptlen = req->cryptlen + ivsize;
-	hash = crypto_authenc_hash(req, flags, cipher, cryptlen);
+	hash = crypto_authenc_hash(req, flags, dst, cryptlen);
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
 
-	scatterwalk_map_and_copy(hash, cipher, cryptlen,
+	scatterwalk_map_and_copy(hash, dst, cryptlen,
 				 crypto_aead_authsize(authenc), 1);
 	return 0;
 }
@@ -285,11 +288,14 @@ static int crypto_authenc_iverify(struct aead_request *req, u8 *iv,
 	srcp = sg_page(src);
 	vsrc = PageHighMem(srcp) ? NULL : page_address(srcp) + src->offset;
 
-	sg_init_table(cipher, 2);
-	sg_set_buf(cipher, iv, ivsize);
-	authenc_chain(cipher, src, vsrc == iv + ivsize);
+	if (ivsize) {
+		sg_init_table(cipher, 2);
+		sg_set_buf(cipher, iv, ivsize);
+		authenc_chain(cipher, src, vsrc == iv + ivsize);
+		src = cipher;
+	}
 
-	return crypto_authenc_verify(req, cipher, cryptlen + ivsize);
+	return crypto_authenc_verify(req, src, cryptlen + ivsize);
 }
 
 static int crypto_authenc_decrypt(struct aead_request *req)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
