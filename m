From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 05/10] crypto: inside-secure - make the key and context size computation dynamic
Date: Wed,  2 May 2018 11:57:20 +0200
Message-ID: <20180502095725.31935-6-antoine.tenart@bootlin.com>
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

This patches makes the key and context size computation dynamic when
using memzero_explicit() on these two arrays. This is safer, cleaner and
will help future modifications of the driver when these two parameters
sizes will changes (the context size will be bigger when using AEAD
algorithms).

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 7c801aace04b..a658f8f14002 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -554,13 +554,13 @@ static int safexcel_cipher_cra_exit(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	memzero_explicit(ctx->key, 8 * sizeof(u32));
+	memzero_explicit(ctx->key, sizeof(ctx->key));
 
 	/* context not allocated, skip invalidation */
 	if (!ctx->base.ctxr)
 		return -ENOMEM;
 
-	memzero_explicit(ctx->base.ctxr->data, 8 * sizeof(u32));
+	memzero_explicit(ctx->base.ctxr->data, sizeof(ctx->base.ctxr->data));
 	return 0;
 }
 
-- 
2.17.0
