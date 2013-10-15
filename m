From: Mathias Krause <mathias.krause@secunet.com>
Subject: [PATCH 3/5] crypto: ixp4xx - Simplify and harden key parsing
Date: Tue, 15 Oct 2013 13:49:32 +0200
Message-ID: <aca163545d8137bdae608dc64fa3b5ff49848ce4.1381831574.git.mathias.krause@secunet.com>
References: <cover.1381831574.git.mathias.krause@secunet.com>
Cc: Mathias Krause <mathias.krause@secunet.com>,
	Christian Hohnstaedt <chohnstaedt@innominate.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Jamie Iles <jamie@jamieiles.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:39686 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758561Ab3JOLtp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Oct 2013 07:49:45 -0400
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
References: <cover.1381831574.git.mathias.krause@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the common helper function crypto_authenc_extractkeys() for key
parsing. Also ensure the keys do fit into the corresponding buffers.
Otherwise memory corruption might occur.

Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Mathias Krause <mathias.krause@secunet.com>
---
Not tested as I've no such hardware, nor the needed cross compiler!

 drivers/crypto/ixp4xx_crypto.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 21180d6..153f73c 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1159,32 +1159,24 @@ static int aead_setkey(struct crypto_aead *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
-	struct rtattr *rta = (struct rtattr *)key;
-	struct crypto_authenc_key_param *param;
+	struct crypto_authenc_keys keys;
 
-	if (!RTA_OK(rta, keylen))
-		goto badkey;
-	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
-		goto badkey;
-	if (RTA_PAYLOAD(rta) < sizeof(*param))
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
 		goto badkey;
 
-	param = RTA_DATA(rta);
-	ctx->enckey_len = be32_to_cpu(param->enckeylen);
-
-	key += RTA_ALIGN(rta->rta_len);
-	keylen -= RTA_ALIGN(rta->rta_len);
+	if (keys.authkeylen > sizeof(ctx->authkey))
+		goto badkey;
 
-	if (keylen < ctx->enckey_len)
+	if (keys.enckeylen > sizeof(ctx->enckey))
 		goto badkey;
 
-	ctx->authkey_len = keylen - ctx->enckey_len;
-	memcpy(ctx->enckey, key + ctx->authkey_len, ctx->enckey_len);
-	memcpy(ctx->authkey, key, ctx->authkey_len);
+	memcpy(ctx->authkey, keys.authkey, keys.authkeylen);
+	memcpy(ctx->enckey, keys.enckey, keys.enckeylen);
+	ctx->authkey_len = keys.authkeylen;
+	ctx->enckey_len = keys.enckeylen;
 
 	return aead_setup(tfm, crypto_aead_authsize(tfm));
 badkey:
-	ctx->enckey_len = 0;
 	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	return -EINVAL;
 }
-- 
1.7.2.5
