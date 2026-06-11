Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEB7369985
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 07:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163412; cv=none; b=ICNV5vw6MgTg+N2ORi2IEz50TeA+9v5VoQcE9fWvamQ1JeLwyGLvPy4U16GPOoYqBOXX8juvyJ6rp1QF00yMyuIRF2/BgfbdtkLNTsQHZP8l19l3KWqWHQHItThtlqBw2uFQ37LWKh2eKimmNe5UIRI3S6iX6aR/AtKVabUIRg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163412; c=relaxed/simple;
	bh=ZBbTZ3lUVo15PEAjomWs0Dha9hqsZrnbXxx/RTHkqV8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=scbTdMHtBump4sdf4Qgx1GlMal4oRjR2yUaJrN36u0jySRxQT4lRQFEma7CkcjlVNuTvz4jtkWHpO7GxTjazD7LKjCrxoqYpc5dPhoVEcyZRB+cdvx0v2SxduJTskX1hLijPLVD0zTnVRiwuK5D1Kg659AcVg/tSkGDMJY2g9YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=1D8ROBoN; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="1D8ROBoN"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id F197A4E42E16;
	Thu, 11 Jun 2026 07:36:48 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id C68A55FF03;
	Thu, 11 Jun 2026 07:36:48 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5D968106B9E4D;
	Thu, 11 Jun 2026 09:36:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1781163408; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ITPNRlTnA/G5KPwOghJ6lQlAPmRJj79zODcsqoxrpWo=;
	b=1D8ROBoNf6bj9LowafRcqXHIc9/XTVlNVu2bxAQx4uR+K2lcAwFUv0hAgIaimceZYwFw0h
	FI+PtouIk1sP+EFnHJpAeFLsnqg6M1F6X3Mcbe9t3wYQMf/nz9ClN6cVDaC5U2o34NNKRL
	543Adg+/r5FMc+/GtQ6p56CGVleicCp2nYRGS/piwzkbgge6Jh/otNsMKl5UvdBSF4elhx
	iW8IlUV6aNz5E+nwdaWjQlhESB9toAJXSCEhJwQxriqNq+GM/L7WiSPr+yWcNuC1GVvPCL
	MTRxCs1gi2Cw1H+yhe4FQb0hBjncwD6gsfSra1b1bGsyzLQytoKnFb+t3Hj4eA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 11 Jun 2026 09:35:59 +0200
Subject: [PATCH v2 05/19] crypto: talitos - Prepare crypto implementation
 file splitting
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-7-1-rc1_talitos_cleanup-v2-5-aa4a813ce69b@bootlin.com>
References: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
In-Reply-To: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781163398; l=15994;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=ZBbTZ3lUVo15PEAjomWs0Dha9hqsZrnbXxx/RTHkqV8=;
 b=vy7uCSMKMvLZoyXGpvDiT0ehYbP8o587zfTE2WSgVO5zhE3WniHhUOG2lY3vhAbQvzm93GVkR
 +ulM/5cL6oVCW/N219fnbaAsiAvxItw2aULuYKmwFdT1pVtEsiijGXR
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Move all talitos helpers and inline them inside the header file.
Remove the static qualifier for the core functions of the driver, they
will be called inside each crypto implementation file.

Add the common structures too.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.c | 182 ++++++---------------------------------
 drivers/crypto/talitos/talitos.h | 167 +++++++++++++++++++++++++++++++++++
 2 files changed, 194 insertions(+), 155 deletions(-)

diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index e28c60d17bb5..58e1e534dedd 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -40,99 +40,6 @@
 
 #include "talitos.h"
 
-static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
-			   unsigned int len, bool is_sec1)
-{
-	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
-	if (is_sec1) {
-		ptr->len1 = cpu_to_be16(len);
-	} else {
-		ptr->len = cpu_to_be16(len);
-		ptr->eptr = upper_32_bits(dma_addr);
-	}
-}
-
-static void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
-			     struct talitos_ptr *src_ptr, bool is_sec1)
-{
-	dst_ptr->ptr = src_ptr->ptr;
-	if (is_sec1) {
-		dst_ptr->len1 = src_ptr->len1;
-	} else {
-		dst_ptr->len = src_ptr->len;
-		dst_ptr->eptr = src_ptr->eptr;
-	}
-}
-
-static unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
-					   bool is_sec1)
-{
-	if (is_sec1)
-		return be16_to_cpu(ptr->len1);
-	else
-		return be16_to_cpu(ptr->len);
-}
-
-static void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val,
-				   bool is_sec1)
-{
-	if (!is_sec1)
-		ptr->j_extent = val;
-}
-
-static void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, bool is_sec1)
-{
-	if (!is_sec1)
-		ptr->j_extent |= val;
-}
-
-/*
- * map virtual single (contiguous) pointer to h/w descriptor pointer
- */
-static void __map_single_talitos_ptr(struct device *dev,
-				     struct talitos_ptr *ptr,
-				     unsigned int len, void *data,
-				     enum dma_data_direction dir,
-				     unsigned long attrs)
-{
-	dma_addr_t dma_addr = dma_map_single_attrs(dev, data, len, dir, attrs);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	to_talitos_ptr(ptr, dma_addr, len, is_sec1);
-}
-
-static void map_single_talitos_ptr(struct device *dev,
-				   struct talitos_ptr *ptr,
-				   unsigned int len, void *data,
-				   enum dma_data_direction dir)
-{
-	__map_single_talitos_ptr(dev, ptr, len, data, dir, 0);
-}
-
-static void map_single_talitos_ptr_nosync(struct device *dev,
-					  struct talitos_ptr *ptr,
-					  unsigned int len, void *data,
-					  enum dma_data_direction dir)
-{
-	__map_single_talitos_ptr(dev, ptr, len, data, dir,
-				 DMA_ATTR_SKIP_CPU_SYNC);
-}
-
-/*
- * unmap bus single (contiguous) h/w descriptor pointer
- */
-static void unmap_single_talitos_ptr(struct device *dev,
-				     struct talitos_ptr *ptr,
-				     enum dma_data_direction dir)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	dma_unmap_single(dev, be32_to_cpu(ptr->ptr),
-			 from_talitos_ptr_len(ptr, is_sec1), dir);
-}
-
 static int reset_channel(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -303,11 +210,11 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
  * callback must check err and feedback in descriptor header
  * for device processing status.
  */
-static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
-			  void (*callback)(struct device *dev,
-					   struct talitos_desc *desc,
-					   void *context, int error),
-			  void *context)
+int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
+		   void (*callback)(struct device *dev,
+				    struct talitos_desc *desc,
+				    void *context, int error),
+		   void *context)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request;
@@ -830,24 +737,6 @@ DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_DONE, TALITOS2_ISR_CH_1_3_ERR,
  * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
-#ifdef CONFIG_CRYPTO_DEV_TALITOS2
-#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
-#else
-#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
-#endif
-#define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
-
-struct talitos_ctx {
-	struct device *dev;
-	int ch;
-	__be32 desc_hdr_template;
-	u8 key[TALITOS_MAX_KEY_SIZE];
-	u8 iv[TALITOS_MAX_IV_LENGTH];
-	dma_addr_t dma_key;
-	unsigned int keylen;
-	unsigned int enckeylen;
-	unsigned int authkeylen;
-};
 
 #define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
 
@@ -938,7 +827,7 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
 	return err;
 }
 
-static void talitos_sg_unmap(struct device *dev,
+void talitos_sg_unmap(struct device *dev,
 			     struct talitos_edesc *edesc,
 			     struct scatterlist *src,
 			     struct scatterlist *dst,
@@ -1123,7 +1012,7 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 	return count;
 }
 
-static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
+int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 			      unsigned int len, struct talitos_edesc *edesc,
 			      struct talitos_ptr *ptr, int sg_count,
 			      unsigned int offset, int tbl_off, int elen,
@@ -1160,7 +1049,7 @@ static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 	return sg_count;
 }
 
-static int talitos_sg_map(struct device *dev, struct scatterlist *src,
+int talitos_sg_map(struct device *dev, struct scatterlist *src,
 			  unsigned int len, struct talitos_edesc *edesc,
 			  struct talitos_ptr *ptr, int sg_count,
 			  unsigned int offset, int tbl_off)
@@ -1298,17 +1187,17 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 /*
  * allocate and map the extended descriptor
  */
-static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
-						 struct scatterlist *src,
-						 struct scatterlist *dst,
-						 u8 *iv,
-						 unsigned int assoclen,
-						 unsigned int cryptlen,
-						 unsigned int authsize,
-						 unsigned int ivsize,
-						 int icv_stashing,
-						 u32 cryptoflags,
-						 bool encrypt)
+struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
+					  struct scatterlist *src,
+					  struct scatterlist *dst,
+					  u8 *iv,
+					  unsigned int assoclen,
+					  unsigned int cryptlen,
+					  unsigned int authsize,
+					  unsigned int ivsize,
+					  int icv_stashing,
+					  u32 cryptoflags,
+					  bool encrypt)
 {
 	struct talitos_edesc *edesc;
 	int src_nents, dst_nents, alloc_len, dma_len, src_len, dst_len;
@@ -2171,18 +2060,6 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 	return 0;
 }
 
-
-struct talitos_alg_template {
-	u32 type;
-	u32 priority;
-	union {
-		struct skcipher_alg skcipher;
-		struct ahash_alg hash;
-		struct aead_alg aead;
-	} alg;
-	__be32 desc_hdr_template;
-};
-
 static struct talitos_alg_template driver_algs[] = {
 	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
@@ -2997,14 +2874,8 @@ static struct talitos_alg_template driver_algs[] = {
 	}
 };
 
-struct talitos_crypto_alg {
-	struct list_head entry;
-	struct device *dev;
-	struct talitos_alg_template algt;
-};
-
-static int talitos_init_common(struct talitos_ctx *ctx,
-			       struct talitos_crypto_alg *talitos_alg)
+int talitos_init_common(struct talitos_ctx *ctx,
+			struct talitos_crypto_alg *talitos_alg)
 {
 	struct talitos_private *priv;
 
@@ -3064,7 +2935,7 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 	return talitos_init_common(ctx, talitos_alg);
 }
 
-static void talitos_cra_exit(struct crypto_tfm *tfm)
+void talitos_cra_exit(struct crypto_tfm *tfm)
 {
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct device *dev = ctx->dev;
@@ -3078,7 +2949,7 @@ static void talitos_cra_exit(struct crypto_tfm *tfm)
  * type and primary/secondary execution units required match the hw
  * capabilities description provided in the device tree node.
  */
-static int hw_supports(struct device *dev, __be32 desc_hdr_template)
+int talitos_hw_supports(struct device *dev, __be32 desc_hdr_template)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int ret;
@@ -3115,7 +2986,7 @@ static void talitos_remove(struct platform_device *ofdev)
 		list_del(&t_alg->entry);
 	}
 
-	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
+	if (talitos_hw_supports(dev, DESC_HDR_SEL0_RNG))
 		talitos_unregister_rng(dev);
 
 	for (i = 0; i < 2; i++)
@@ -3424,7 +3295,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* register the RNG, if available */
-	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
+	if (talitos_hw_supports(dev, DESC_HDR_SEL0_RNG)) {
 		err = talitos_register_rng(dev);
 		if (err) {
 			dev_err(dev, "failed to register hwrng: %d\n", err);
@@ -3435,7 +3306,8 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	/* register crypto algorithms the device supports */
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
-		if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
+		if (talitos_hw_supports(dev,
+					driver_algs[i].desc_hdr_template)) {
 			struct talitos_crypto_alg *t_alg;
 			struct crypto_alg *alg = NULL;
 
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index fa8c71b1f90f..81331914801b 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -5,7 +5,13 @@
  * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
  */
 
+#include <crypto/aes.h>
+#include <crypto/internal/aead.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/sha2.h>
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/hw_random.h>
 #include <linux/interrupt.h>
 #include <linux/scatterlist.h>
@@ -19,6 +25,13 @@
 #define PRIMARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 28) & 0xf)
 #define SECONDARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 16) & 0xf)
 
+#ifdef CONFIG_CRYPTO_DEV_TALITOS2
+#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
+#else
+#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
+#endif
+#define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
+
 /* descriptor pointer entry */
 struct talitos_ptr {
 	union {
@@ -174,6 +187,35 @@ struct talitos_private {
 
 };
 
+struct talitos_ctx {
+	struct device *dev;
+	int ch;
+	__be32 desc_hdr_template;
+	u8 key[TALITOS_MAX_KEY_SIZE];
+	u8 iv[TALITOS_MAX_IV_LENGTH];
+	dma_addr_t dma_key;
+	unsigned int keylen;
+	unsigned int enckeylen;
+	unsigned int authkeylen;
+};
+
+struct talitos_alg_template {
+	u32 type;
+	u32 priority;
+	union {
+		struct skcipher_alg skcipher;
+		struct ahash_alg hash;
+		struct aead_alg aead;
+	} alg;
+	__be32 desc_hdr_template;
+};
+
+struct talitos_crypto_alg {
+	struct list_head entry;
+	struct device *dev;
+	struct talitos_alg_template algt;
+};
+
 /* .features flag */
 #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
 #define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
@@ -432,6 +474,131 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 #define DESC_PTR_LNKTBL_RET			0x02
 #define DESC_PTR_LNKTBL_NEXT			0x01
 
+static inline void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
+				  unsigned int len, bool is_sec1)
+{
+	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
+	if (is_sec1) {
+		ptr->len1 = cpu_to_be16(len);
+	} else {
+		ptr->len = cpu_to_be16(len);
+		ptr->eptr = upper_32_bits(dma_addr);
+	}
+}
+
+static inline void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
+				    struct talitos_ptr *src_ptr, bool is_sec1)
+{
+	dst_ptr->ptr = src_ptr->ptr;
+	if (is_sec1) {
+		dst_ptr->len1 = src_ptr->len1;
+	} else {
+		dst_ptr->len = src_ptr->len;
+		dst_ptr->eptr = src_ptr->eptr;
+	}
+}
+
+static inline unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
+						  bool is_sec1)
+{
+	if (is_sec1)
+		return be16_to_cpu(ptr->len1);
+	else
+		return be16_to_cpu(ptr->len);
+}
+
+static inline void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val,
+					  bool is_sec1)
+{
+	if (!is_sec1)
+		ptr->j_extent = val;
+}
+
+static inline void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val,
+					 bool is_sec1)
+{
+	if (!is_sec1)
+		ptr->j_extent |= val;
+}
+
+/*
+ * map virtual single (contiguous) pointer to h/w descriptor pointer
+ */
+static void __map_single_talitos_ptr(struct device *dev,
+				     struct talitos_ptr *ptr, unsigned int len,
+				     void *data, enum dma_data_direction dir,
+				     unsigned long attrs)
+{
+	dma_addr_t dma_addr = dma_map_single_attrs(dev, data, len, dir, attrs);
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+
+	to_talitos_ptr(ptr, dma_addr, len, is_sec1);
+}
+
+static inline void map_single_talitos_ptr(struct device *dev,
+					  struct talitos_ptr *ptr,
+					  unsigned int len, void *data,
+					  enum dma_data_direction dir)
+{
+	__map_single_talitos_ptr(dev, ptr, len, data, dir, 0);
+}
+
+static inline void map_single_talitos_ptr_nosync(struct device *dev,
+						 struct talitos_ptr *ptr,
+						 unsigned int len, void *data,
+						 enum dma_data_direction dir)
+{
+	__map_single_talitos_ptr(dev, ptr, len, data, dir,
+				 DMA_ATTR_SKIP_CPU_SYNC);
+}
+
+/*
+ * unmap bus single (contiguous) h/w descriptor pointer
+ */
+static inline void unmap_single_talitos_ptr(struct device *dev,
+					    struct talitos_ptr *ptr,
+					    enum dma_data_direction dir)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+
+	dma_unmap_single(dev, be32_to_cpu(ptr->ptr),
+			 from_talitos_ptr_len(ptr, is_sec1), dir);
+}
+
+int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
+		   void (*callback)(struct device *dev,
+				    struct talitos_desc *desc, void *context,
+				    int error),
+		   void *context);
+
+void talitos_sg_unmap(struct device *dev, struct talitos_edesc *edesc,
+		      struct scatterlist *src, struct scatterlist *dst,
+		      unsigned int len, unsigned int offset);
+int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
+		       unsigned int len, struct talitos_edesc *edesc,
+		       struct talitos_ptr *ptr, int sg_count,
+		       unsigned int offset, int tbl_off, int elen, bool force,
+		       int align);
+int talitos_sg_map(struct device *dev, struct scatterlist *src,
+		   unsigned int len, struct talitos_edesc *edesc,
+		   struct talitos_ptr *ptr, int sg_count, unsigned int offset,
+		   int tbl_off);
+
+struct talitos_edesc *
+talitos_edesc_alloc(struct device *dev, struct scatterlist *src,
+		    struct scatterlist *dst, u8 *iv, unsigned int assoclen,
+		    unsigned int cryptlen, unsigned int authsize,
+		    unsigned int ivsize, int icv_stashing, u32 cryptoflags,
+		    bool encrypt);
+
+int talitos_hw_supports(struct device *dev, __be32 desc_hdr_template);
+
+int talitos_init_common(struct talitos_ctx *ctx,
+			struct talitos_crypto_alg *talitos_alg);
+void talitos_cra_exit(struct crypto_tfm *tfm);
+
 /* Hardware RNG */
 
 int talitos_register_rng(struct device *dev);

-- 
2.54.0

