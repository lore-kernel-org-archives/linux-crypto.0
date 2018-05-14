From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH v2 01/10] crypto: inside-secure - remove VLAs
Date: Mon, 14 May 2018 15:10:55 +0200
Message-ID: <20180514131104.25552-2-antoine.tenart@bootlin.com>
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

This patch removes the use of VLAs to allocate requests on the stack, by
removing both SKCIPHER_REQUEST_ON_STACK and AHASH_REQUEST_ON_STACK. As
we still need to allocate requests on the stack to ease the creation of
invalidation requests a new, non-VLA, definition is used:
EIP197_REQUEST_ON_STACK.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.h        | 9 +++++++++
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
 drivers/crypto/inside-secure/safexcel_hash.c   | 2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index b470a849721f..afdd099b2c1a 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -28,6 +28,15 @@
 #define EIP197_GFP_FLAGS(base)	((base).flags & CRYPTO_TFM_REQ_MAY_SLEEP ? \
 				 GFP_KERNEL : GFP_ATOMIC)
 
+/* Custom on-stack requests (for invalidation) */
+#define EIP197_SKCIPHER_REQ_SIZE	sizeof(struct skcipher_request) + \
+					sizeof(struct safexcel_cipher_req)
+#define EIP197_AHASH_REQ_SIZE		sizeof(struct ahash_request) + \
+					sizeof(struct safexcel_ahash_req)
+#define EIP197_REQUEST_ON_STACK(name, type, size) \
+	char __##name##_desc[size] CRYPTO_MINALIGN_ATTR; \
+	struct type##_request *name = (void *)__##name##_desc
+
 /* Register base offsets */
 #define EIP197_HIA_AIC(priv)		((priv)->base + (priv)->offsets.hia_aic)
 #define EIP197_HIA_AIC_G(priv)		((priv)->base + (priv)->offsets.hia_aic_g)
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index bafb60505fab..9a51da28fb62 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -433,7 +433,7 @@ static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
-	SKCIPHER_REQUEST_ON_STACK(req, __crypto_skcipher_cast(tfm));
+	EIP197_REQUEST_ON_STACK(req, skcipher, EIP197_SKCIPHER_REQ_SIZE);
 	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
 	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 317b9e480312..00d2cad0ff1c 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -480,7 +480,7 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
-	AHASH_REQUEST_ON_STACK(req, __crypto_ahash_cast(tfm));
+	EIP197_REQUEST_ON_STACK(req, ahash, EIP197_AHASH_REQ_SIZE);
 	struct safexcel_ahash_req *rctx = ahash_request_ctx(req);
 	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
-- 
2.17.0
