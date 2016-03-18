From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: gcm - Fix rfc4543 decryption crash
Date: Fri, 18 Mar 2016 22:42:40 +0800
Message-ID: <20160318144240.GA20816@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: stable@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	patrick.meyer@vasgard.com
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This bug has already bee fixed upstream since 4.2.  However, it
was fixed during the AEAD conversion so no fix was backported to
the older kernels.

When we do an RFC 4543 decryption, we will end up writing the
ICV beyond the end of the dst buffer.  This should lead to a
crash but for some reason it was never noticed.

This patch fixes it by only writing back the ICV for encryption.

Fixes: d733ac90f9fe ("crypto: gcm - fix rfc4543 to handle async...")
Reported-by: Patrick Meyer <patrick.meyer@vasgard.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/gcm.c b/crypto/gcm.c
index b4c2520..cd97cdd 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1173,6 +1173,9 @@ static struct aead_request *crypto_rfc4543_crypt(struct aead_request *req,
 	aead_request_set_tfm(subreq, ctx->child);
 	aead_request_set_callback(subreq, req->base.flags, crypto_rfc4543_done,
 				  req);
+	if (!enc)
+		aead_request_set_callback(subreq, req->base.flags,
+					  req->base.complete, req->base.data);
 	aead_request_set_crypt(subreq, cipher, cipher, enc ? 0 : authsize, iv);
 	aead_request_set_assoc(subreq, assoc, assoclen);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
