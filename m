From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: talitos - add support for sha224
Date: Fri, 30 Apr 2010 22:27:59 -0500
Message-ID: <20100430222759.c116410a.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:59044 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab0EADPO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Apr 2010 23:15:14 -0400
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id o413FDnt003566
	for <linux-crypto@vger.kernel.org>; Fri, 30 Apr 2010 20:15:14 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net [10.64.32.10])
	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id o413PRG3029549
	for <linux-crypto@vger.kernel.org>; Fri, 30 Apr 2010 22:25:28 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SEC h/w versions 2.1 and above support sha224 via explicit instruction.

Performing sha224 ahashes on earlier versions is still possible because
they support sha256 (sha224 is sha256 with different initial constants
and a different truncation length).  We do this by overriding hardware
context self-initialization, and perform it manually in s/w instead.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   74 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/crypto/talitos.h |    2 +
 2 files changed, 68 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 1b08a39..80bef09 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -156,6 +156,7 @@ struct talitos_private {
 /* .features flag */
 #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
 #define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
+#define TALITOS_FTR_SHA224_HWINIT 0x00000004
 
 static void to_talitos_ptr(struct talitos_ptr *talitos_ptr, dma_addr_t dma_addr)
 {
@@ -720,10 +721,11 @@ struct talitos_ctx {
 
 struct talitos_ahash_req_ctx {
 	u64 count;
-	u8 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE];
+	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
 	unsigned int hw_context_size;
 	u8 buf[HASH_MAX_BLOCK_SIZE];
 	u8 bufnext[HASH_MAX_BLOCK_SIZE];
+	unsigned int swinit;
 	unsigned int first;
 	unsigned int last;
 	unsigned int to_hash_later;
@@ -1631,12 +1633,13 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* first DWORD empty */
 	desc->ptr[0] = zero_entry;
 
-	/* hash context in (if not first) */
-	if (!req_ctx->first) {
+	/* hash context in */
+	if (!req_ctx->first || req_ctx->swinit) {
 		map_single_talitos_ptr(dev, &desc->ptr[1],
 				       req_ctx->hw_context_size,
 				       (char *)req_ctx->hw_context, 0,
 				       DMA_TO_DEVICE);
+		req_ctx->swinit = 0;
 	} else {
 		desc->ptr[1] = zero_entry;
 		/* Indicate next op is not the first. */
@@ -1722,7 +1725,7 @@ static int ahash_init(struct ahash_request *areq)
 
 	/* Initialize the context */
 	req_ctx->count = 0;
-	req_ctx->first = 1; /* first indicates h/w must init it's context */
+	req_ctx->first = 1; /* first indicates h/w must init its context */
 	req_ctx->hw_context_size =
 		(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
 			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
@@ -1731,6 +1734,29 @@ static int ahash_init(struct ahash_request *areq)
 	return 0;
 }
 
+/*
+ * on h/w without explicit sha224 support, we initialize h/w context
+ * manually with sha224 constants, and tell it to run sha256.
+ */
+static int ahash_init_sha224_swinit(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	ahash_init(areq);
+	req_ctx->swinit = 1;/* prevent h/w initting context with sha256 values*/
+
+	req_ctx->hw_context[0] = cpu_to_be32(SHA224_H0);
+	req_ctx->hw_context[1] = cpu_to_be32(SHA224_H1);
+	req_ctx->hw_context[2] = cpu_to_be32(SHA224_H2);
+	req_ctx->hw_context[3] = cpu_to_be32(SHA224_H3);
+	req_ctx->hw_context[4] = cpu_to_be32(SHA224_H4);
+	req_ctx->hw_context[5] = cpu_to_be32(SHA224_H5);
+	req_ctx->hw_context[6] = cpu_to_be32(SHA224_H6);
+	req_ctx->hw_context[7] = cpu_to_be32(SHA224_H7);
+
+	return 0;
+}
+
 static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
@@ -1799,8 +1825,8 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	else
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
 
-	/* On first one, request SEC to INIT hash. */
-	if (req_ctx->first)
+	/* request SEC to INIT hash. */
+	if (req_ctx->first && !req_ctx->swinit)
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
 
 	/* When the tfm context has a keylen, it's an HMAC.
@@ -1843,8 +1869,9 @@ static int ahash_finup(struct ahash_request *areq)
 static int ahash_digest(struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
 
-	ahash_init(areq);
+	ahash->init(areq);
 	req_ctx->last = 1;
 
 	return ahash_process_req(areq, areq->nbytes);
@@ -2116,6 +2143,27 @@ static struct talitos_alg_template driver_algs[] = {
 			.final = ahash_final,
 			.finup = ahash_finup,
 			.digest = ahash_digest,
+			.halg.digestsize = SHA224_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "sha224",
+				.cra_driver_name = "sha224-talitos",
+				.cra_blocksize = SHA224_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA224,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
 			.halg.digestsize = SHA256_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "sha256",
@@ -2298,6 +2346,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 						    struct talitos_alg_template
 						           *template)
 {
+	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_crypto_alg *t_alg;
 	struct crypto_alg *alg;
 
@@ -2319,6 +2368,14 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
 		alg->cra_init = talitos_cra_init_ahash;
+		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
+		    !strcmp(alg->cra_name, "sha224")) {
+			t_alg->algt.alg.hash.init = ahash_init_sha224_swinit;
+			t_alg->algt.desc_hdr_template =
+					DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					DESC_HDR_SEL0_MDEUA |
+					DESC_HDR_MODE0_MDEU_SHA256;
+		}
 		break;
 	}
 
@@ -2406,7 +2463,8 @@ static int talitos_probe(struct of_device *ofdev,
 		priv->features |= TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT;
 
 	if (of_device_is_compatible(np, "fsl,sec2.1"))
-		priv->features |= TALITOS_FTR_HW_AUTH_CHECK;
+		priv->features |= TALITOS_FTR_HW_AUTH_CHECK |
+				  TALITOS_FTR_SHA224_HWINIT;
 
 	priv->chan = kzalloc(sizeof(struct talitos_channel) *
 			     priv->num_channels, GFP_KERNEL);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 05c57b7..44c1489 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -164,6 +164,7 @@
 #define	DESC_HDR_MODE0_MDEU_INIT	cpu_to_be32(0x01000000)
 #define	DESC_HDR_MODE0_MDEU_HMAC	cpu_to_be32(0x00800000)
 #define	DESC_HDR_MODE0_MDEU_PAD		cpu_to_be32(0x00400000)
+#define	DESC_HDR_MODE0_MDEU_SHA224	cpu_to_be32(0x00300000)
 #define	DESC_HDR_MODE0_MDEU_MD5		cpu_to_be32(0x00200000)
 #define	DESC_HDR_MODE0_MDEU_SHA256	cpu_to_be32(0x00100000)
 #define	DESC_HDR_MODE0_MDEU_SHA1	cpu_to_be32(0x00000000)
@@ -187,6 +188,7 @@
 #define	DESC_HDR_MODE1_MDEU_INIT	cpu_to_be32(0x00001000)
 #define	DESC_HDR_MODE1_MDEU_HMAC	cpu_to_be32(0x00000800)
 #define	DESC_HDR_MODE1_MDEU_PAD		cpu_to_be32(0x00000400)
+#define	DESC_HDR_MODE1_MDEU_SHA224	cpu_to_be32(0x00000300)
 #define	DESC_HDR_MODE1_MDEU_MD5		cpu_to_be32(0x00000200)
 #define	DESC_HDR_MODE1_MDEU_SHA256	cpu_to_be32(0x00000100)
 #define	DESC_HDR_MODE1_MDEU_SHA1	cpu_to_be32(0x00000000)
-- 
1.7.1

