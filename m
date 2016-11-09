From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 02/14] crypto: caam - completely remove error propagation handling
Date: Wed, 9 Nov 2016 10:46:12 +0200
Message-ID: <1478681184-9442-3-git-send-email-horia.geanta@nxp.com>
References: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0080.outbound.protection.outlook.com ([104.47.36.80]:31424
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752600AbcKIJCy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 04:02:54 -0500
In-Reply-To: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 4464a7d4f53d756101291da26563f37f7fce40f3
("crypto: caam - remove error propagation handling")
removed error propagation handling only from caamalg.

Do this in all other places: caamhash, caamrng.
Update descriptors' lengths appropriately.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 5 +----
 drivers/crypto/caam/caamrng.c  | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 660dc206969f..51990dd56024 100644
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
@@ -246,9 +246,6 @@ static inline void init_sh_desc_key_ahash(u32 *desc, struct caam_hash_ctx *ctx)
 
 		set_jump_tgt_here(desc, key_jump_cmd);
 	}
-
-	/* Propagate errors from shared to job descriptor */
-	append_cmd(desc, SET_OK_NO_PROP_ERRORS | CMD_LOAD);
 }
 
 /*
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 9b92af2c7241..bb1c118b2d1b 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -52,7 +52,7 @@
 
 /* length of descriptors */
 #define DESC_JOB_O_LEN			(CAAM_CMD_SZ * 2 + CAAM_PTR_SZ * 2)
-#define DESC_RNG_LEN			(4 * CAAM_CMD_SZ)
+#define DESC_RNG_LEN			(3 * CAAM_CMD_SZ)
 
 /* Buffer, its dma address and lock */
 struct buf_data {
@@ -196,9 +196,6 @@ static inline int rng_create_sh_desc(struct caam_rng_ctx *ctx)
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
-	/* Propagate errors from shared to job descriptor */
-	append_cmd(desc, SET_OK_NO_PROP_ERRORS | CMD_LOAD);
-
 	/* Generate random bytes */
 	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
 
-- 
2.4.4
