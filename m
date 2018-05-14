From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH v2 04/10] crypto: inside-secure - make the context control size dynamic
Date: Mon, 14 May 2018 15:10:58 +0200
Message-ID: <20180514131104.25552-5-antoine.tenart@bootlin.com>
References: <20180514131104.25552-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180514131104.25552-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch makes the context control size computation dynamic, not to
rely on hardcoded values. This is better for the future, and will help
adding the AEAD support.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 9ed3f2641ef3..26f6e05726ea 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -118,21 +118,20 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 	switch (ctx->key_len) {
 	case AES_KEYSIZE_128:
 		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES128;
-		ctrl_size = 4;
 		break;
 	case AES_KEYSIZE_192:
 		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES192;
-		ctrl_size = 6;
 		break;
 	case AES_KEYSIZE_256:
 		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES256;
-		ctrl_size = 8;
 		break;
 	default:
 		dev_err(priv->dev, "aes keysize not supported: %u\n",
 			ctx->key_len);
 		return -EINVAL;
 	}
+
+	ctrl_size = ctx->key_len / sizeof(u32);
 	cdesc->control_data.control0 |= CONTEXT_CONTROL_SIZE(ctrl_size);
 
 	return 0;
-- 
2.17.0
