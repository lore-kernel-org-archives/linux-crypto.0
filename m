From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 1/9] crypto: caam - completely remove error propagation handling
Date: Fri, 18 Jul 2014 19:37:18 +0300
Message-ID: <1405701446-13656-2-git-send-email-horia.geanta@freescale.com>
References: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"Horia Geanta" <horia.geanta@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:21496
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935113AbaGRQjD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 12:39:03 -0400
In-Reply-To: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 4464a7d4f53d756101291da26563f37f7fce40f3
("crypto: caam - remove error propagation handling")
removed error propagation handling only from caamalg.

Do this in all other places: caamhash, caamrng.
Update descriptors' lengths appropriately.
Note that caamrng's shared descriptor length was incorrect.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 5 +----
 drivers/crypto/caam/caamrng.c  | 9 +++------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index b464d03ebf40..56ec534337b3 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -72,7 +72,7 @@
 #define CAAM_MAX_HASH_DIGEST_SIZE	SHA512_DIGEST_SIZE
 
 /* length of descriptors text */
-#define DESC_AHASH_BASE			(4 * CAAM_CMD_SZ)
+#define DESC_AHASH_BASE			(3 * CAAM_CMD_SZ)
 #define DESC_AHASH_UPDATE_LEN		(6 * CAAM_CMD_SZ)
 #define DESC_AHASH_UPDATE_FIRST_LEN	(DESC_AHASH_BASE + 4 * CAAM_CMD_SZ)
 #define DESC_AHASH_FINAL_LEN		(DESC_AHASH_BASE + 5 * CAAM_CMD_SZ)
@@ -247,9 +247,6 @@ static inline void init_sh_desc_key_ahash(u32 *desc, struct caam_hash_ctx *ctx)
 
 		set_jump_tgt_here(desc, key_jump_cmd);
 	}
-
-	/* Propagate errors from shared to job descriptor */
-	append_cmd(desc, SET_OK_NO_PROP_ERRORS | CMD_LOAD);
 }
 
 /*
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index ae31e555793c..8b9df8deda67 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -52,7 +52,7 @@
 
 /* length of descriptors */
 #define DESC_JOB_O_LEN			(CAAM_CMD_SZ * 2 + CAAM_PTR_SZ * 2)
-#define DESC_RNG_LEN			(10 * CAAM_CMD_SZ)
+#define DESC_RNG_LEN			(3 * CAAM_CMD_SZ)
 
 /* Buffer, its dma address and lock */
 struct buf_data {
@@ -90,8 +90,8 @@ static inline void rng_unmap_ctx(struct caam_rng_ctx *ctx)
 	struct device *jrdev = ctx->jrdev;
 
 	if (ctx->sh_desc_dma)
-		dma_unmap_single(jrdev, ctx->sh_desc_dma, DESC_RNG_LEN,
-				 DMA_TO_DEVICE);
+		dma_unmap_single(jrdev, ctx->sh_desc_dma,
+				 desc_bytes(ctx->sh_desc), DMA_TO_DEVICE);
 	rng_unmap_buf(jrdev, &ctx->bufs[0]);
 	rng_unmap_buf(jrdev, &ctx->bufs[1]);
 }
@@ -192,9 +192,6 @@ static inline int rng_create_sh_desc(struct caam_rng_ctx *ctx)
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
-	/* Propagate errors from shared to job descriptor */
-	append_cmd(desc, SET_OK_NO_PROP_ERRORS | CMD_LOAD);
-
 	/* Generate random bytes */
 	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
 
-- 
1.8.3.1
