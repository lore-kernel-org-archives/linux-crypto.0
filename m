From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: authencesn - Fix digest_null crash
Date: Mon, 17 Jul 2017 15:32:30 +0800
Message-ID: <20170717073230.GA1941@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Tluka <jtluka@redhat.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39294 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbdGQHc5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 03:32:57 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When authencesn is used together with digest_null a crash will
occur on the decrypt path.  This is because normally we perform
a special setup to preserve the ESN, but this is skipped if there
is no authentication.  However, on the post-authentication path
it always expects the preservation to be in place, thus causing
a crash when digest_null is used.

This patch fixes this by also skipping the post-processing when
there is no authentication.

Fixes: 104880a6b470 ("crypto: authencesn - Convert to new AEAD...")
Cc: <stable@vger.kernel.org>
Reported-by: Jan Tluka <jtluka@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 6f8f6b8..0cf5fef 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -248,6 +248,9 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
 	u32 tmp[2];
 
+	if (!authsize)
+		goto decrypt;
+
 	/* Move high-order bits of sequence number back. */
 	scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
 	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
@@ -256,6 +259,8 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	if (crypto_memneq(ihash, ohash, authsize))
 		return -EBADMSG;
 
+decrypt:
+
 	sg_init_table(areq_ctx->dst, 2);
 	dst = scatterwalk_ffwd(areq_ctx->dst, dst, assoclen);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
