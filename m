From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 11/11] [CRYPTO] authenc: Add givcrypt operation
Date: Fri, 23 Nov 2007 19:24:43 +0800
Message-ID: <20071123112443.GA19048@gondor.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au> <E1Iv7kI-000220-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1241 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755040AbXKWLYq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Nov 2007 06:24:46 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IvWeK-0000oN-JN
	for <linux-crypto@vger.kernel.org>; Fri, 23 Nov 2007 22:24:44 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IvWeJ-0004xX-00
	for <linux-crypto@vger.kernel.org>; Fri, 23 Nov 2007 19:24:43 +0800
Content-Disposition: inline
In-Reply-To: <E1Iv7kI-000220-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 04:49:14PM +0800, Herbert Xu wrote:
> [CRYPTO] authenc: Add givcrypt operation
> 
> This patch implements the givcrypt function for authenc.  It simply
> calls the givcrypt operation on the underlying cipher instead of encrypt.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Another bug.  I forgot to set giv in the sub-request.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
3ac5d3dc0fb6039b2ba8e5938ad49bf531a5649b
diff --git a/crypto/authenc.c b/crypto/authenc.c
index bc4e608..7bbdbbe 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -144,6 +144,27 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	return crypto_authenc_hash(req);
 }
 
+static int crypto_authenc_givcrypt(struct aead_request *req)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+	struct ablkcipher_request *abreq = aead_request_ctx(req);
+	int err;
+
+	ablkcipher_request_set_tfm(abreq, ctx->enc);
+	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
+					crypto_authenc_encrypt_done, req);
+	ablkcipher_request_set_crypt(abreq, req->src, req->dst, req->cryptlen,
+				     req->iv);
+	ablkcipher_request_set_giv(abreq, req->giv, req->seq);
+
+	err = crypto_ablkcipher_givcrypt(abreq);
+	if (err)
+		return err;
+
+	return crypto_authenc_hash(req);
+}
+
 static int crypto_authenc_verify(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
@@ -346,6 +367,7 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 
 	inst->alg.cra_aead.setkey = crypto_authenc_setkey;
 	inst->alg.cra_aead.encrypt = crypto_authenc_encrypt;
+	inst->alg.cra_aead.givcrypt = crypto_authenc_givcrypt;
 	inst->alg.cra_aead.decrypt = crypto_authenc_decrypt;
 
 out:
