From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [0/5] Fix gcm ICV handling and restore old scatterwalk
Date: Fri, 7 Dec 2007 16:25:38 +0800
Message-ID: <20071207082538.GA7930@gondor.apana.org.au>
References: <20071207081904.GA7733@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2047 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138AbXLGIZl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 03:25:41 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J0YWh-0005Js-Hs
	for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2007 19:25:39 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J0YWh-00024D-00
	for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2007 16:25:39 +0800
Content-Disposition: inline
In-Reply-To: <20071207081904.GA7733@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 07, 2007 at 04:19:04PM +0800, Herbert Xu wrote:
> Hi:
> 
> Here's a few misc patches in my tree that I'll push out soon.
> It restores the old scatterwalk chaining because generic chaining
> isn't portable yet.
> 
> It also fixes gcm to following the crypto_aead convention of
> including the ICV in the output for encrypt and input for decrypt.

Oh and one more patch to fix GCM on top of an async ablkcipher.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
commit 15c34df401282ea95a6bba59b3322d6d24d4eae7
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Dec 6 14:59:53 2007 +0800

    [CRYPTO] gcm: Put abreq in private context instead of on stack
    
    The abreq structure is currently allocated on the stack.  This is broken
    if the underlying algorithm is asynchronous.  This patch changes it so
    that it's taken from the private context instead which has been enlarged
    accordingly.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/gcm.c b/crypto/gcm.c
index f293502..1ffbd7d 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -38,6 +38,7 @@ struct crypto_gcm_req_priv_ctx {
 	u8 iauth_tag[16];
 	u8 counter[16];
 	struct crypto_gcm_ghash_ctx ghash;
+	struct ablkcipher_request abreq;
 };
 
 static void crypto_gcm_ghash_init(struct crypto_gcm_ghash_ctx *ctx, u32 flags,
@@ -278,16 +279,17 @@ static void crypto_gcm_encrypt_done(struct crypto_async_request *areq, int err)
 
 static int crypto_gcm_encrypt(struct aead_request *req)
 {
-	struct ablkcipher_request abreq;
+	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct ablkcipher_request *abreq = &pctx->abreq;
 	int err = 0;
 
-	err = crypto_gcm_init_crypt(&abreq, req, req->cryptlen,
+	err = crypto_gcm_init_crypt(abreq, req, req->cryptlen,
 				    crypto_gcm_encrypt_done);
 	if (err)
 		return err;
 
 	if (req->cryptlen) {
-		err = crypto_ablkcipher_encrypt(&abreq);
+		err = crypto_ablkcipher_encrypt(abreq);
 		if (err)
 			return err;
 	}
@@ -302,9 +304,9 @@ static void crypto_gcm_decrypt_done(struct crypto_async_request *areq, int err)
 
 static int crypto_gcm_decrypt(struct aead_request *req)
 {
-	struct ablkcipher_request abreq;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct ablkcipher_request *abreq = &pctx->abreq;
 	u8 *auth_tag = pctx->auth_tag;
 	u8 *iauth_tag = pctx->iauth_tag;
 	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
@@ -316,7 +318,7 @@ static int crypto_gcm_decrypt(struct aead_request *req)
 		return -EINVAL;
 	cryptlen -= authsize;
 
-	err = crypto_gcm_init_crypt(&abreq, req, cryptlen,
+	err = crypto_gcm_init_crypt(abreq, req, cryptlen,
 				    crypto_gcm_decrypt_done);
 	if (err)
 		return err;
@@ -328,7 +330,7 @@ static int crypto_gcm_decrypt(struct aead_request *req)
 	if (memcmp(iauth_tag, auth_tag, authsize))
 		return -EBADMSG;
 
-	return crypto_ablkcipher_decrypt(&abreq);
+	return crypto_ablkcipher_decrypt(abreq);
 }
 
 static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
@@ -351,7 +353,9 @@ static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
 	align = max_t(unsigned long, crypto_ablkcipher_alignmask(ctr),
 		      __alignof__(u32) - 1);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	tfm->crt_aead.reqsize = align + sizeof(struct crypto_gcm_req_priv_ctx);
+	tfm->crt_aead.reqsize = align +
+				sizeof(struct crypto_gcm_req_priv_ctx) +
+				crypto_ablkcipher_reqsize(ctr);
 
 	return 0;
 }
