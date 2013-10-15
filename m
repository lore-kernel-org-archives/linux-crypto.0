From: Mathias Krause <mathias.krause@secunet.com>
Subject: [PATCH 2/5] crypto: authencesn - Simplify key parsing
Date: Tue, 15 Oct 2013 13:49:31 +0200
Message-ID: <cba6d8a063d00bab1f2ee0b1f87a0c11b09a4119.1381831574.git.mathias.krause@secunet.com>
References: <cover.1381831574.git.mathias.krause@secunet.com>
Cc: Mathias Krause <mathias.krause@secunet.com>,
	Christian Hohnstaedt <chohnstaedt@innominate.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Jamie Iles <jamie@jamieiles.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:39669 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758561Ab3JOLto (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Oct 2013 07:49:44 -0400
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
References: <cover.1381831574.git.mathias.krause@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the common helper function crypto_authenc_extractkeys() for key
parsing.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Mathias Krause <mathias.krause@secunet.com>
---
 crypto/authencesn.c |   26 ++++----------------------
 1 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index ab53762..8ed5b47 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -59,37 +59,19 @@ static void authenc_esn_request_complete(struct aead_request *req, int err)
 static int crypto_authenc_esn_setkey(struct crypto_aead *authenc_esn, const u8 *key,
 				     unsigned int keylen)
 {
-	unsigned int authkeylen;
-	unsigned int enckeylen;
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
 	struct crypto_ahash *auth = ctx->auth;
 	struct crypto_ablkcipher *enc = ctx->enc;
-	struct rtattr *rta = (void *)key;
-	struct crypto_authenc_key_param *param;
+	struct crypto_authenc_keys keys;
 	int err = -EINVAL;
 
-	if (!RTA_OK(rta, keylen))
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
 		goto badkey;
-	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
-		goto badkey;
-	if (RTA_PAYLOAD(rta) < sizeof(*param))
-		goto badkey;
-
-	param = RTA_DATA(rta);
-	enckeylen = be32_to_cpu(param->enckeylen);
-
-	key += RTA_ALIGN(rta->rta_len);
-	keylen -= RTA_ALIGN(rta->rta_len);
-
-	if (keylen < enckeylen)
-		goto badkey;
-
-	authkeylen = keylen - enckeylen;
 
 	crypto_ahash_clear_flags(auth, CRYPTO_TFM_REQ_MASK);
 	crypto_ahash_set_flags(auth, crypto_aead_get_flags(authenc_esn) &
 				     CRYPTO_TFM_REQ_MASK);
-	err = crypto_ahash_setkey(auth, key, authkeylen);
+	err = crypto_ahash_setkey(auth, keys.authkey, keys.authkeylen);
 	crypto_aead_set_flags(authenc_esn, crypto_ahash_get_flags(auth) &
 					   CRYPTO_TFM_RES_MASK);
 
@@ -99,7 +81,7 @@ static int crypto_authenc_esn_setkey(struct crypto_aead *authenc_esn, const u8 *
 	crypto_ablkcipher_clear_flags(enc, CRYPTO_TFM_REQ_MASK);
 	crypto_ablkcipher_set_flags(enc, crypto_aead_get_flags(authenc_esn) &
 					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_ablkcipher_setkey(enc, key + authkeylen, enckeylen);
+	err = crypto_ablkcipher_setkey(enc, keys.enckey, keys.enckeylen);
 	crypto_aead_set_flags(authenc_esn, crypto_ablkcipher_get_flags(enc) &
 					   CRYPTO_TFM_RES_MASK);
 
-- 
1.7.2.5
