From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 03/10] crypto: inside-secure - rework the alg type settings in the context
Date: Wed,  2 May 2018 11:57:18 +0200
Message-ID: <20180502095725.31935-4-antoine.tenart@bootlin.com>
References: <20180502095725.31935-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502095725.31935-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patches reworks the way the algorithm type is set in the context,
by using the fact that the decryption algorithms are just a combination
of the algorithm encryption type and CONTEXT_CONTROL_TYPE_NULL_IN.

This will help having simpler code when adding the AEAD support, to
avoid ending up with an endless switch case block.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index a5e904a404d7..4977039f3d33 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -104,10 +104,13 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	int ctrl_size;
 
-	if (sreq->direction == SAFEXCEL_ENCRYPT)
-		cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_CRYPTO_OUT;
-	else
-		cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_CRYPTO_IN;
+	cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_CRYPTO_OUT;
+
+	/* The decryption control type is a combination of the encryption type
+	 * and CONTEXT_CONTROL_TYPE_NULL_IN, for all types.
+	 */
+	if (sreq->direction == SAFEXCEL_DECRYPT)
+		cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_NULL_IN;
 
 	cdesc->control_data.control0 |= CONTEXT_CONTROL_KEY_EN;
 	cdesc->control_data.control1 |= ctx->mode;
-- 
2.17.0
