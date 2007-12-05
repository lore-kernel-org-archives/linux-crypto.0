From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] [CRYPTO] authenc: Fix hash verification
Date: Wed, 5 Dec 2007 12:06:07 +1100
Message-ID: <20071205010607.GA17438@gondor.apana.org.au>
References: <20071122083656.GB7368@gondor.apana.org.au> <E1IyjdX-0001XC-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1907 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751239AbXLEBGK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Dec 2007 20:06:10 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IziiG-0001Tb-JY
	for <linux-crypto@vger.kernel.org>; Wed, 05 Dec 2007 12:06:08 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IziiF-0004Xv-00
	for <linux-crypto@vger.kernel.org>; Wed, 05 Dec 2007 12:06:07 +1100
Content-Disposition: inline
In-Reply-To: <E1IyjdX-0001XC-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 02, 2007 at 06:53:11PM +1100, Herbert Xu wrote:
> [CRYPTO] authenc: Fix hash verification
> 
> The previous code incorrectly included the hash in the verification which
> also meant that we'd crash and burn when it comes to actually verifying
> the hash since we'd go past the end of the SG list.
> 
> This patch fixes that by subtracting authsize from cryptlen at the start.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Heh that fix was incomplete since we need to exclude the ICV from
decryption too.  Here's the corrected version.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
59e9d637797c1466bf86c5ac67140cee5f023c2e
diff --git a/crypto/authenc.c b/crypto/authenc.c
index a61dea1..82e03ff 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -158,7 +158,8 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	return crypto_authenc_hash(req);
 }
 
-static int crypto_authenc_verify(struct aead_request *req)
+static int crypto_authenc_verify(struct aead_request *req,
+				 unsigned int cryptlen)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
@@ -170,7 +171,6 @@ static int crypto_authenc_verify(struct aead_request *req)
 	u8 *ohash = aead_request_ctx(req);
 	u8 *ihash;
 	struct scatterlist *src = req->src;
-	unsigned int cryptlen = req->cryptlen;
 	unsigned int authsize;
 	int err;
 
@@ -214,16 +214,22 @@ static int crypto_authenc_decrypt(struct aead_request *req)
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct ablkcipher_request *abreq = aead_request_ctx(req);
+	unsigned int cryptlen = req->cryptlen;
+	unsigned int authsize = crypto_aead_authsize(authenc);
 	int err;
 
-	err = crypto_authenc_verify(req);
+	if (cryptlen < authsize)
+		return -EINVAL;
+	cryptlen -= authsize;
+
+	err = crypto_authenc_verify(req, cryptlen);
 	if (err)
 		return err;
 
 	ablkcipher_request_set_tfm(abreq, ctx->enc);
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
 					crypto_authenc_decrypt_done, req);
-	ablkcipher_request_set_crypt(abreq, req->src, req->dst, req->cryptlen,
+	ablkcipher_request_set_crypt(abreq, req->src, req->dst, cryptlen,
 				     req->iv);
 
 	return crypto_ablkcipher_decrypt(abreq);
