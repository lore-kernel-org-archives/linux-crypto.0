From: Mathias Krause <mathias.krause@secunet.com>
Subject: [PATCH 1/5] crypto: authenc - Export key parsing helper function
Date: Tue, 15 Oct 2013 13:49:30 +0200
Message-ID: <ff6f8cac3172528407e99e427d2fae912fa9d280.1381831574.git.mathias.krause@secunet.com>
References: <cover.1381831574.git.mathias.krause@secunet.com>
Cc: Mathias Krause <mathias.krause@secunet.com>,
	Christian Hohnstaedt <chohnstaedt@innominate.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Jamie Iles <jamie@jamieiles.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:39678 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758780Ab3JOLtp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Oct 2013 07:49:45 -0400
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
References: <cover.1381831574.git.mathias.krause@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

AEAD key parsing is duplicated to multiple places in the kernel. Add a
common helper function to consolidate that functionality.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Mathias Krause <mathias.krause@secunet.com>
---
 crypto/authenc.c         |   48 ++++++++++++++++++++++++++++-----------------
 include/crypto/authenc.h |   12 ++++++++++-
 2 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index ffce19d..0fda5ba 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -52,40 +52,52 @@ static void authenc_request_complete(struct aead_request *req, int err)
 		aead_request_complete(req, err);
 }
 
-static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
-				 unsigned int keylen)
+int crypto_authenc_extractkeys(struct crypto_authenc_keys *keys, const u8 *key,
+			       unsigned int keylen)
 {
-	unsigned int authkeylen;
-	unsigned int enckeylen;
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	struct crypto_ahash *auth = ctx->auth;
-	struct crypto_ablkcipher *enc = ctx->enc;
-	struct rtattr *rta = (void *)key;
+	struct rtattr *rta = (struct rtattr *)key;
 	struct crypto_authenc_key_param *param;
-	int err = -EINVAL;
 
 	if (!RTA_OK(rta, keylen))
-		goto badkey;
+		return -EINVAL;
 	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
-		goto badkey;
+		return -EINVAL;
 	if (RTA_PAYLOAD(rta) < sizeof(*param))
-		goto badkey;
+		return -EINVAL;
 
 	param = RTA_DATA(rta);
-	enckeylen = be32_to_cpu(param->enckeylen);
+	keys->enckeylen = be32_to_cpu(param->enckeylen);
 
 	key += RTA_ALIGN(rta->rta_len);
 	keylen -= RTA_ALIGN(rta->rta_len);
 
-	if (keylen < enckeylen)
-		goto badkey;
+	if (keylen < keys->enckeylen)
+		return -EINVAL;
 
-	authkeylen = keylen - enckeylen;
+	keys->authkeylen = keylen - keys->enckeylen;
+	keys->authkey = key;
+	keys->enckey = key + keys->authkeylen;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_authenc_extractkeys);
+
+static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
+				 unsigned int keylen)
+{
+	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+	struct crypto_ahash *auth = ctx->auth;
+	struct crypto_ablkcipher *enc = ctx->enc;
+	struct crypto_authenc_keys keys;
+	int err = -EINVAL;
+
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
+		goto badkey;
 
 	crypto_ahash_clear_flags(auth, CRYPTO_TFM_REQ_MASK);
 	crypto_ahash_set_flags(auth, crypto_aead_get_flags(authenc) &
 				    CRYPTO_TFM_REQ_MASK);
-	err = crypto_ahash_setkey(auth, key, authkeylen);
+	err = crypto_ahash_setkey(auth, keys.authkey, keys.authkeylen);
 	crypto_aead_set_flags(authenc, crypto_ahash_get_flags(auth) &
 				       CRYPTO_TFM_RES_MASK);
 
@@ -95,7 +107,7 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	crypto_ablkcipher_clear_flags(enc, CRYPTO_TFM_REQ_MASK);
 	crypto_ablkcipher_set_flags(enc, crypto_aead_get_flags(authenc) &
 					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_ablkcipher_setkey(enc, key + authkeylen, enckeylen);
+	err = crypto_ablkcipher_setkey(enc, keys.enckey, keys.enckeylen);
 	crypto_aead_set_flags(authenc, crypto_ablkcipher_get_flags(enc) &
 				       CRYPTO_TFM_RES_MASK);
 
diff --git a/include/crypto/authenc.h b/include/crypto/authenc.h
index e47b044..6775059 100644
--- a/include/crypto/authenc.h
+++ b/include/crypto/authenc.h
@@ -23,5 +23,15 @@ struct crypto_authenc_key_param {
 	__be32 enckeylen;
 };
 
-#endif	/* _CRYPTO_AUTHENC_H */
+struct crypto_authenc_keys {
+	const u8 *authkey;
+	const u8 *enckey;
+
+	unsigned int authkeylen;
+	unsigned int enckeylen;
+};
 
+int crypto_authenc_extractkeys(struct crypto_authenc_keys *keys, const u8 *key,
+			       unsigned int keylen);
+
+#endif	/* _CRYPTO_AUTHENC_H */
-- 
1.7.2.5
