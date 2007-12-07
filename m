From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/5] [CRYPTO] aead: Return EBADMSG for ICV mismatch
Date: Fri, 07 Dec 2007 16:19:45 +0800
Message-ID: <E1J0YQz-00021u-00@gondolin.me.apana.org.au>
References: <20071207081904.GA7733@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1993 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752180AbXLGITt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 03:19:49 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J0YR0-0005EW-9p
	for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2007 19:19:46 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] aead: Return EBADMSG for ICV mismatch

This patch changes gcm/authenc to return EBADMSG instead of EINVAL for
ICV mismatches.  This convention has already been adopted by IPsec.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |    2 +-
 crypto/gcm.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 82e03ff..6c9104e 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -200,7 +200,7 @@ auth_unlock:
 
 	authsize = crypto_aead_authsize(authenc);
 	scatterwalk_map_and_copy(ihash, src, cryptlen, authsize, 0);
-	return memcmp(ihash, ohash, authsize) ? -EINVAL : 0;
+	return memcmp(ihash, ohash, authsize) ? -EBADMSG: 0;
 }
 
 static void crypto_authenc_decrypt_done(struct crypto_async_request *req,
diff --git a/crypto/gcm.c b/crypto/gcm.c
index ed8a626..d60c340 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -327,7 +327,7 @@ static int crypto_gcm_decrypt(struct aead_request *req)
 
 	scatterwalk_map_and_copy(iauth_tag, req->src, cryptlen, authsize, 0);
 	if (memcmp(iauth_tag, auth_tag, authsize))
-		return -EINVAL;
+		return -EBADMSG;
 
 	return crypto_ablkcipher_decrypt(&abreq);
 }
