From: Mathias Krause <mathias.krause@secunet.com>
Subject: [PATCH 5/5] crypto: talitos - Simplify key parsing
Date: Tue, 15 Oct 2013 13:49:34 +0200
Message-ID: <998deca85e4f195b7380ef43747118972e239b55.1381831574.git.mathias.krause@secunet.com>
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
	id S1758780Ab3JOLtq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Oct 2013 07:49:46 -0400
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
References: <cover.1381831574.git.mathias.krause@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the common helper function crypto_authenc_extractkeys() for key
parsing.

Cc: Kim Phillips <kim.phillips@freescale.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Mathias Krause <mathias.krause@secunet.com>
---
Not tested as I've no such hardware, nor the needed cross compiler!

 drivers/crypto/talitos.c |   35 ++++++++---------------------------
 1 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 661dc3e..f6f7c68 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -671,39 +671,20 @@ static int aead_setkey(struct crypto_aead *authenc,
 		       const u8 *key, unsigned int keylen)
 {
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct rtattr *rta = (void *)key;
-	struct crypto_authenc_key_param *param;
-	unsigned int authkeylen;
-	unsigned int enckeylen;
-
-	if (!RTA_OK(rta, keylen))
-		goto badkey;
+	struct crypto_authenc_keys keys;
 
-	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
 		goto badkey;
 
-	if (RTA_PAYLOAD(rta) < sizeof(*param))
+	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
 		goto badkey;
 
-	param = RTA_DATA(rta);
-	enckeylen = be32_to_cpu(param->enckeylen);
-
-	key += RTA_ALIGN(rta->rta_len);
-	keylen -= RTA_ALIGN(rta->rta_len);
-
-	if (keylen < enckeylen)
-		goto badkey;
+	memcpy(ctx->key, keys.authkey, keys.authkeylen);
+	memcpy(&ctx->key[keys.authkeylen], keys.enckey, keys.enckeylen);
 
-	authkeylen = keylen - enckeylen;
-
-	if (keylen > TALITOS_MAX_KEY_SIZE)
-		goto badkey;
-
-	memcpy(&ctx->key, key, keylen);
-
-	ctx->keylen = keylen;
-	ctx->enckeylen = enckeylen;
-	ctx->authkeylen = authkeylen;
+	ctx->keylen = keys.authkeylen + keys.enckeylen;
+	ctx->enckeylen = keys.enckeylen;
+	ctx->authkeylen = keys.authkeylen;
 
 	return 0;
 
-- 
1.7.2.5
