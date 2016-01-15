From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 4/5] crypto: atmel-sha: fix context switches
Date: Fri, 15 Jan 2016 15:49:34 +0100
Message-ID: <5f1c3378baa3256b7b4a30736b863469c01c73c1.1452867917.git.cyrille.pitchen@atmel.com>
References: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch saves the value of the internal hash register at the end of an
'update' operation then restores this value before starting the next
'update'. This way the driver can now properly handle context switches.

WARNING: only hardware versions from sama5d4x and later provide the
needed interface to update the internal hash value. Especially, sama5d3x
cannot implement this feature so context switches are still broken.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha-regs.h |   4 ++
 drivers/crypto/atmel-sha.c      | 105 ++++++++++++++++++++++++++++++----------
 2 files changed, 84 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/atmel-sha-regs.h b/drivers/crypto/atmel-sha-regs.h
index 83b2d7425666..e08897109cab 100644
--- a/drivers/crypto/atmel-sha-regs.h
+++ b/drivers/crypto/atmel-sha-regs.h
@@ -8,6 +8,8 @@
 #define SHA_CR_START			(1 << 0)
 #define SHA_CR_FIRST			(1 << 4)
 #define SHA_CR_SWRST			(1 << 8)
+#define SHA_CR_WUIHV			(1 << 12)
+#define SHA_CR_WUIEHV			(1 << 13)
 
 #define SHA_MR				0x04
 #define SHA_MR_MODE_MASK		(0x3 << 0)
@@ -15,6 +17,8 @@
 #define SHA_MR_MODE_AUTO		0x1
 #define SHA_MR_MODE_PDC			0x2
 #define SHA_MR_PROCDLY			(1 << 4)
+#define SHA_MR_UIHV			(1 << 5)
+#define SHA_MR_UIEHV			(1 << 6)
 #define SHA_MR_ALGO_SHA1		(0 << 8)
 #define SHA_MR_ALGO_SHA256		(1 << 8)
 #define SHA_MR_ALGO_SHA384		(2 << 8)
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 7327e11e0ccb..da4c3055784f 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -53,6 +53,7 @@
 
 #define SHA_FLAGS_FINUP		BIT(16)
 #define SHA_FLAGS_SG		BIT(17)
+#define SHA_FLAGS_ALGO_MASK	GENMASK(22, 18)
 #define SHA_FLAGS_SHA1		BIT(18)
 #define SHA_FLAGS_SHA224	BIT(19)
 #define SHA_FLAGS_SHA256	BIT(20)
@@ -60,6 +61,7 @@
 #define SHA_FLAGS_SHA512	BIT(22)
 #define SHA_FLAGS_ERROR		BIT(23)
 #define SHA_FLAGS_PAD		BIT(24)
+#define SHA_FLAGS_RESTORE	BIT(25)
 
 #define SHA_OP_UPDATE	1
 #define SHA_OP_FINAL	2
@@ -73,6 +75,7 @@ struct atmel_sha_caps {
 	bool	has_dualbuff;
 	bool	has_sha224;
 	bool	has_sha_384_512;
+	bool	has_uihv;
 };
 
 struct atmel_sha_dev;
@@ -318,7 +321,8 @@ static int atmel_sha_init(struct ahash_request *req)
 static void atmel_sha_write_ctrl(struct atmel_sha_dev *dd, int dma)
 {
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(dd->req);
-	u32 valcr = 0, valmr = SHA_MR_MODE_AUTO;
+	u32 valmr = SHA_MR_MODE_AUTO;
+	unsigned int i, hashsize = 0;
 
 	if (likely(dma)) {
 		if (!dd->caps.has_dma)
@@ -330,22 +334,62 @@ static void atmel_sha_write_ctrl(struct atmel_sha_dev *dd, int dma)
 		atmel_sha_write(dd, SHA_IER, SHA_INT_DATARDY);
 	}
 
-	if (ctx->flags & SHA_FLAGS_SHA1)
+	switch (ctx->flags & SHA_FLAGS_ALGO_MASK) {
+	case SHA_FLAGS_SHA1:
 		valmr |= SHA_MR_ALGO_SHA1;
-	else if (ctx->flags & SHA_FLAGS_SHA224)
+		hashsize = SHA1_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA224:
 		valmr |= SHA_MR_ALGO_SHA224;
-	else if (ctx->flags & SHA_FLAGS_SHA256)
+		hashsize = SHA256_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA256:
 		valmr |= SHA_MR_ALGO_SHA256;
-	else if (ctx->flags & SHA_FLAGS_SHA384)
+		hashsize = SHA256_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA384:
 		valmr |= SHA_MR_ALGO_SHA384;
-	else if (ctx->flags & SHA_FLAGS_SHA512)
+		hashsize = SHA512_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA512:
 		valmr |= SHA_MR_ALGO_SHA512;
+		hashsize = SHA512_DIGEST_SIZE;
+		break;
+
+	default:
+		break;
+	}
 
 	/* Setting CR_FIRST only for the first iteration */
-	if (!(ctx->digcnt[0] || ctx->digcnt[1]))
-		valcr = SHA_CR_FIRST;
+	if (!(ctx->digcnt[0] || ctx->digcnt[1])) {
+		atmel_sha_write(dd, SHA_CR, SHA_CR_FIRST);
+	} else if (dd->caps.has_uihv && (ctx->flags & SHA_FLAGS_RESTORE)) {
+		const u32 *hash = (const u32 *)ctx->digest;
+
+		/*
+		 * Restore the hardware context: update the User Initialize
+		 * Hash Value (UIHV) with the value saved when the latest
+		 * 'update' operation completed on this very same crypto
+		 * request.
+		 */
+		ctx->flags &= ~SHA_FLAGS_RESTORE;
+		atmel_sha_write(dd, SHA_CR, SHA_CR_WUIHV);
+		for (i = 0; i < hashsize / sizeof(u32); ++i)
+			atmel_sha_write(dd, SHA_REG_DIN(i), hash[i]);
+		atmel_sha_write(dd, SHA_CR, SHA_CR_FIRST);
+		valmr |= SHA_MR_UIHV;
+	}
+	/*
+	 * WARNING: If the UIHV feature is not available, the hardware CANNOT
+	 * process concurrent requests: the internal registers used to store
+	 * the hash/digest are still set to the partial digest output values
+	 * computed during the latest round.
+	 */
 
-	atmel_sha_write(dd, SHA_CR, valcr);
 	atmel_sha_write(dd, SHA_MR, valmr);
 }
 
@@ -714,23 +758,31 @@ static void atmel_sha_copy_hash(struct ahash_request *req)
 {
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
 	u32 *hash = (u32 *)ctx->digest;
-	int i;
+	unsigned int i, hashsize;
 
-	if (ctx->flags & SHA_FLAGS_SHA1)
-		for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(u32); i++)
-			hash[i] = atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
-	else if (ctx->flags & SHA_FLAGS_SHA224)
-		for (i = 0; i < SHA224_DIGEST_SIZE / sizeof(u32); i++)
-			hash[i] = atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
-	else if (ctx->flags & SHA_FLAGS_SHA256)
-		for (i = 0; i < SHA256_DIGEST_SIZE / sizeof(u32); i++)
-			hash[i] = atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
-	else if (ctx->flags & SHA_FLAGS_SHA384)
-		for (i = 0; i < SHA384_DIGEST_SIZE / sizeof(u32); i++)
-			hash[i] = atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
-	else
-		for (i = 0; i < SHA512_DIGEST_SIZE / sizeof(u32); i++)
-			hash[i] = atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
+	switch (ctx->flags & SHA_FLAGS_ALGO_MASK) {
+	case SHA_FLAGS_SHA1:
+		hashsize = SHA1_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA224:
+	case SHA_FLAGS_SHA256:
+		hashsize = SHA256_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA384:
+	case SHA_FLAGS_SHA512:
+		hashsize = SHA512_DIGEST_SIZE;
+		break;
+
+	default:
+		/* Should not happen... */
+		return;
+	}
+
+	for (i = 0; i < hashsize / sizeof(u32); ++i)
+		hash[i] = atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
+	ctx->flags |= SHA_FLAGS_RESTORE;
 }
 
 static void atmel_sha_copy_ready_hash(struct ahash_request *req)
@@ -1276,6 +1328,7 @@ static void atmel_sha_get_cap(struct atmel_sha_dev *dd)
 	dd->caps.has_dualbuff = 0;
 	dd->caps.has_sha224 = 0;
 	dd->caps.has_sha_384_512 = 0;
+	dd->caps.has_uihv = 0;
 
 	/* keep only major version number */
 	switch (dd->hw_version & 0xff0) {
@@ -1284,12 +1337,14 @@ static void atmel_sha_get_cap(struct atmel_sha_dev *dd)
 		dd->caps.has_dualbuff = 1;
 		dd->caps.has_sha224 = 1;
 		dd->caps.has_sha_384_512 = 1;
+		dd->caps.has_uihv = 1;
 		break;
 	case 0x420:
 		dd->caps.has_dma = 1;
 		dd->caps.has_dualbuff = 1;
 		dd->caps.has_sha224 = 1;
 		dd->caps.has_sha_384_512 = 1;
+		dd->caps.has_uihv = 1;
 		break;
 	case 0x410:
 		dd->caps.has_dma = 1;
-- 
1.8.2.2
