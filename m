From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v2 04/12] crypto: atmel-sha: redefine SHA_FLAGS_SHA* flags to match SHA_MR_ALGO_SHA*
Date: Thu, 22 Dec 2016 17:37:53 +0100
Message-ID: <31213519617e6504fe812e377d0a5f246bc46fb2.1482424395.git.cyrille.pitchen@atmel.com>
References: <cover.1482424395.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1482424395.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch modifies the SHA_FLAGS_SHA* flags: those algo flags are now
organized as values of a single bitfield instead of individual bits.
This allows to reduce the number of bits needed to encode all possible
values. Also the new values match the SHA_MR_ALGO_SHA* values hence
the algorithm bitfield of the SHA_MR register could simply be set with:

mr = (mr & ~SHA_FLAGS_ALGO_MASK) | (ctx->flags & SHA_FLAGS_ALGO_MASK)

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha-regs.h |  1 +
 drivers/crypto/atmel-sha.c      | 45 +++++++++++++++++++++++++++++------------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/atmel-sha-regs.h b/drivers/crypto/atmel-sha-regs.h
index e08897109cab..deb0b0b15096 100644
--- a/drivers/crypto/atmel-sha-regs.h
+++ b/drivers/crypto/atmel-sha-regs.h
@@ -19,6 +19,7 @@
 #define SHA_MR_PROCDLY			(1 << 4)
 #define SHA_MR_UIHV			(1 << 5)
 #define SHA_MR_UIEHV			(1 << 6)
+#define SHA_MR_ALGO_MASK		GENMASK(10, 8)
 #define SHA_MR_ALGO_SHA1		(0 << 8)
 #define SHA_MR_ALGO_SHA256		(1 << 8)
 #define SHA_MR_ALGO_SHA384		(2 << 8)
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 643d79a05dda..b29a4e5bc404 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -51,14 +51,16 @@
 #define SHA_FLAGS_CPU			BIT(5)
 #define SHA_FLAGS_DMA_READY		BIT(6)
 
+/* bits[10:8] are reserved. */
+#define SHA_FLAGS_ALGO_MASK	SHA_MR_ALGO_MASK
+#define SHA_FLAGS_SHA1		SHA_MR_ALGO_SHA1
+#define SHA_FLAGS_SHA256	SHA_MR_ALGO_SHA256
+#define SHA_FLAGS_SHA384	SHA_MR_ALGO_SHA384
+#define SHA_FLAGS_SHA512	SHA_MR_ALGO_SHA512
+#define SHA_FLAGS_SHA224	SHA_MR_ALGO_SHA224
+
 #define SHA_FLAGS_FINUP		BIT(16)
 #define SHA_FLAGS_SG		BIT(17)
-#define SHA_FLAGS_ALGO_MASK	GENMASK(22, 18)
-#define SHA_FLAGS_SHA1		BIT(18)
-#define SHA_FLAGS_SHA224	BIT(19)
-#define SHA_FLAGS_SHA256	BIT(20)
-#define SHA_FLAGS_SHA384	BIT(21)
-#define SHA_FLAGS_SHA512	BIT(22)
 #define SHA_FLAGS_ERROR		BIT(23)
 #define SHA_FLAGS_PAD		BIT(24)
 #define SHA_FLAGS_RESTORE	BIT(25)
@@ -264,7 +266,9 @@ static void atmel_sha_fill_padding(struct atmel_sha_reqctx *ctx, int length)
 	bits[1] = cpu_to_be64(size[0] << 3);
 	bits[0] = cpu_to_be64(size[1] << 3 | size[0] >> 61);
 
-	if (ctx->flags & (SHA_FLAGS_SHA384 | SHA_FLAGS_SHA512)) {
+	switch (ctx->flags & SHA_FLAGS_ALGO_MASK) {
+	case SHA_FLAGS_SHA384:
+	case SHA_FLAGS_SHA512:
 		index = ctx->bufcnt & 0x7f;
 		padlen = (index < 112) ? (112 - index) : ((128+112) - index);
 		*(ctx->buffer + ctx->bufcnt) = 0x80;
@@ -272,7 +276,9 @@ static void atmel_sha_fill_padding(struct atmel_sha_reqctx *ctx, int length)
 		memcpy(ctx->buffer + ctx->bufcnt + padlen, bits, 16);
 		ctx->bufcnt += padlen + 16;
 		ctx->flags |= SHA_FLAGS_PAD;
-	} else {
+		break;
+
+	default:
 		index = ctx->bufcnt & 0x3f;
 		padlen = (index < 56) ? (56 - index) : ((64+56) - index);
 		*(ctx->buffer + ctx->bufcnt) = 0x80;
@@ -280,6 +286,7 @@ static void atmel_sha_fill_padding(struct atmel_sha_reqctx *ctx, int length)
 		memcpy(ctx->buffer + ctx->bufcnt + padlen, &bits[1], 8);
 		ctx->bufcnt += padlen + 8;
 		ctx->flags |= SHA_FLAGS_PAD;
+		break;
 	}
 }
 
@@ -828,16 +835,28 @@ static void atmel_sha_copy_ready_hash(struct ahash_request *req)
 	if (!req->result)
 		return;
 
-	if (ctx->flags & SHA_FLAGS_SHA1)
+	switch (ctx->flags & SHA_FLAGS_ALGO_MASK) {
+	default:
+	case SHA_FLAGS_SHA1:
 		memcpy(req->result, ctx->digest, SHA1_DIGEST_SIZE);
-	else if (ctx->flags & SHA_FLAGS_SHA224)
+		break;
+
+	case SHA_FLAGS_SHA224:
 		memcpy(req->result, ctx->digest, SHA224_DIGEST_SIZE);
-	else if (ctx->flags & SHA_FLAGS_SHA256)
+		break;
+
+	case SHA_FLAGS_SHA256:
 		memcpy(req->result, ctx->digest, SHA256_DIGEST_SIZE);
-	else if (ctx->flags & SHA_FLAGS_SHA384)
+		break;
+
+	case SHA_FLAGS_SHA384:
 		memcpy(req->result, ctx->digest, SHA384_DIGEST_SIZE);
-	else
+		break;
+
+	case SHA_FLAGS_SHA512:
 		memcpy(req->result, ctx->digest, SHA512_DIGEST_SIZE);
+		break;
+	}
 }
 
 static int atmel_sha_finish(struct ahash_request *req)
-- 
2.7.4
