From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] net/ipsec: don't treat EINPROGRESS as a regular error
Date: Mon, 26 Apr 2010 09:17:11 +0800
Message-ID: <20100426011711.GA19734@gondor.apana.org.au>
References: <4B12F9E7.1020207@gmail.com> <20091130211531.GK18101@deprecation.cyrius.com> <4B144627.7060901@gmail.com> <20091204212847.GC28480@deprecation.cyrius.com> <4BCB4009.70707@gmail.com> <20100418191719.GA2508@Chamillionaire.breakpoint.cc> <4BCE125F.30200@gmail.com> <20100424144215.GA9057@Chamillionaire.breakpoint.cc> <20100425011821.GA5284@gondor.apana.org.au> <20100425152928.GA14489@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "L.C." <lucorsel@gmail.com>, linux-arm-kernel@lists.infradead.org,
	Martin Michlmayr <tbm@cyrius.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:33760 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752853Ab0DZBRe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Apr 2010 21:17:34 -0400
Content-Disposition: inline
In-Reply-To: <20100425152928.GA14489@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 25, 2010 at 05:29:28PM +0200, Sebastian Andrzej Siewior wrote:
> * Herbert Xu | 2010-04-25 09:18:21 [+0800]:
> 
> >This should only be possible when we use the MAY_BACKLOG flag,
> >as otherwise EINPROGRESS should never be used on the completion
> >function unless it's a real error.
> Urgh, right. I think I lost it.
> 
> >Which algorithm is generating EINPROGRESS in this case?
> The call stack looks like the following:
> 
>   crypto_authenc_givencrypt_done()
>    \crypto_authenc_ahash
>     \crypto_ahash_digest()
>      \mv_hash_digest()
>       \crypto_enqueue_request() <= -EINPROGRESS

OK that was my fault.  Steffen had all the requisite EINPROGRESS
checks in place but I told him to get rid of them.

This patch should fix it.

commit 180ce7e81030e1ef763d58f97f9ab840ff57d848
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Mon Apr 26 09:14:05 2010 +0800

    crypto: authenc - Add EINPROGRESS check
    
    When Steffen originally wrote the authenc async hash patch, he
    correctly had EINPROGRESS checks in place so that we did not invoke
    the original completion handler with it.
    
    Unfortuantely I told him to remove it before the patch was applied.
    
    As only MAY_BACKLOG request completion handlers are required to
    handle EINPROGRESS completions, those checks are really needed.
    
    This patch restores them.
    
    Reported-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 2bb7348..05eb32e 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -46,6 +46,12 @@ struct authenc_request_ctx {
 	char tail[];
 };
 
+static void authenc_request_complete(struct aead_request *req, int err)
+{
+	if (err != -EINPROGRESS)
+		aead_request_complete(req, err);
+}
+
 static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 				 unsigned int keylen)
 {
@@ -142,7 +148,7 @@ static void authenc_geniv_ahash_update_done(struct crypto_async_request *areq,
 				 crypto_aead_authsize(authenc), 1);
 
 out:
-	aead_request_complete(req, err);
+	authenc_request_complete(req, err);
 }
 
 static void authenc_geniv_ahash_done(struct crypto_async_request *areq, int err)
@@ -208,7 +214,7 @@ static void authenc_verify_ahash_update_done(struct crypto_async_request *areq,
 	err = crypto_ablkcipher_decrypt(abreq);
 
 out:
-	aead_request_complete(req, err);
+	authenc_request_complete(req, err);
 }
 
 static void authenc_verify_ahash_done(struct crypto_async_request *areq,
@@ -245,7 +251,7 @@ static void authenc_verify_ahash_done(struct crypto_async_request *areq,
 	err = crypto_ablkcipher_decrypt(abreq);
 
 out:
-	aead_request_complete(req, err);
+	authenc_request_complete(req, err);
 }
 
 static u8 *crypto_authenc_ahash_fb(struct aead_request *req, unsigned int flags)
@@ -379,7 +385,7 @@ static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
 		err = crypto_authenc_genicv(areq, iv, 0);
 	}
 
-	aead_request_complete(areq, err);
+	authenc_request_complete(areq, err);
 }
 
 static int crypto_authenc_encrypt(struct aead_request *req)
@@ -420,7 +426,7 @@ static void crypto_authenc_givencrypt_done(struct crypto_async_request *req,
 		err = crypto_authenc_genicv(areq, greq->giv, 0);
 	}
 
-	aead_request_complete(areq, err);
+	authenc_request_complete(areq, err);
 }
 
 static int crypto_authenc_givencrypt(struct aead_givcrypt_request *req)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
