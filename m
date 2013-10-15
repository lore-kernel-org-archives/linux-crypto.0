From: Mathias Krause <mathias.krause@secunet.com>
Subject: [PATCH 4/5] crypto: picoxcell - Simplify and harden key parsing
Date: Tue, 15 Oct 2013 13:49:33 +0200
Message-ID: <6d421ea0859a4d3ca27a73492756f4b9058591d9.1381831574.git.mathias.krause@secunet.com>
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
	id S1758878Ab3JOLtq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Oct 2013 07:49:46 -0400
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
References: <cover.1381831574.git.mathias.krause@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the common helper function crypto_authenc_extractkeys() for key
parsing. Also ensure the auth key won't overflow the hash_ctx buffer.

Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Mathias Krause <mathias.krause@secunet.com>
---
Not tested as I've no such hardware, nor the needed cross compiler!

 drivers/crypto/picoxcell_crypto.c |   32 ++++++++------------------------
 1 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 888f7f4..a6175ba 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -495,45 +495,29 @@ static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 {
 	struct spacc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct spacc_alg *alg = to_spacc_alg(tfm->base.__crt_alg);
-	struct rtattr *rta = (void *)key;
-	struct crypto_authenc_key_param *param;
-	unsigned int authkeylen, enckeylen;
+	struct crypto_authenc_keys keys;
 	int err = -EINVAL;
 
-	if (!RTA_OK(rta, keylen))
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
 		goto badkey;
 
-	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
+	if (keys.enckeylen > AES_MAX_KEY_SIZE)
 		goto badkey;
 
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
-
-	if (enckeylen > AES_MAX_KEY_SIZE)
+	if (keys.authkeylen > sizeof(ctx->hash_ctx))
 		goto badkey;
 
 	if ((alg->ctrl_default & SPACC_CRYPTO_ALG_MASK) ==
 	    SPA_CTRL_CIPH_ALG_AES)
-		err = spacc_aead_aes_setkey(tfm, key + authkeylen, enckeylen);
+		err = spacc_aead_aes_setkey(tfm, keys.enckey, keys.enckeylen);
 	else
-		err = spacc_aead_des_setkey(tfm, key + authkeylen, enckeylen);
+		err = spacc_aead_des_setkey(tfm, keys.enckey, keys.enckeylen);
 
 	if (err)
 		goto badkey;
 
-	memcpy(ctx->hash_ctx, key, authkeylen);
-	ctx->hash_key_len = authkeylen;
+	memcpy(ctx->hash_ctx, keys.authkey, keys.authkeylen);
+	ctx->hash_key_len = keys.authkeylen;
 
 	return 0;
 
-- 
1.7.2.5
