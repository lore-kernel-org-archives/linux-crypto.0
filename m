Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D4C50AC3E
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897143; cv=none; b=RjpZRKHs1nxWiu+379Rfzz54hFogYtVVuPbnNkLKI8n9DrppOWn6smS1fj1xDrjjCtFQ/u+uvazdYgHBI6GsiJYVZL7M00Iz1VYy0l6/RaKZOfwJopvEmWQXAZ2LDEqhg17yw95bfd7ufWrtLcS13ZPyWntVMAK1I6p8BK2Iy2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897143; c=relaxed/simple;
	bh=kmjULOU1VpzGpMwy12RmPLXqxzu0HITh7V2Jdk4g2K0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ICA7As+sdE8Riq2tN/n4riScP0EebEEdakReDtHR+GbaRI9PK5V5UwN63kzOWB+wQOZ6Ge+0cW1H4Cj8SyxgCuDqb9RgRxc6lOHTg+mDGdLU9S8Lj1AjbJnuA7bVbFbBYllwJWh66j7t2GRsFfHHppkFkaEKcKDQ9VatMpZls/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=aA2L4I1i; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="aA2L4I1i"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id E31071A1215
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:12:19 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B7FF260362;
	Tue, 13 Oct 2026 13:12:19 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B6AE111D71396;
	Tue, 13 Oct 2026 15:12:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897138; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=xbu+D4VG8cvjTC0Hz5Ibbn4epB/ZLypHpQLYvSLMbbc=;
	b=aA2L4I1iIBergeNHzlcvQ4G9lEomBU+zab8z4L1L1ZBalCPDw9CoD1xcu/egcOpR/qvGHY
	+w5BSaSKesJhN111y7Q0GrlSk1NY7+vbdX/3043BD66CxaCuKL5K8s5ukn0Oq6Yh4s+wAe
	8IwOV5EZQTg10BfeV2t8sXgPs2V2QWAQfS4OhaxdWw070wB7wW085xT+6xzw/+ATvXuSe/
	GJMK5pOm/hLMuZb6birnZ33Arg1/33uMKBhPg8LxcM+OZKno4hGCumRkNPl3GLIP0+fjdM
	eqE+XlUgdC3DjJB6xKXJ/OR9obk7gby1tbhDrql9AyWttsJRxmQQYoLycb5sUg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:31 +0200
Subject: [PATCH v8 05/20] crypto: talitos - Prepare crypto implementation
 file splitting
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-5-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=16035;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=kmjULOU1VpzGpMwy12RmPLXqxzu0HITh7V2Jdk4g2K0=;
 b=+JWy0aAStfilSLDX7Q8Jnv8atjJxDSNOjtwtCy4wwcBSxW1GhwY1Ca05P6P8CwmJlK9COFfqB
 ddwvkHGQEcQBoGebU2o4OYPpkZUIUrCmKO/FQlwaVilJ1bH90MiT5Xc
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Move all talitos helpers and inline them inside the header file.
Remove the static qualifier for the core functions of the driver, they
will be called inside each crypto implementation file.

Add the common structures too.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-core.c | 182 +++++-----------------------------
 drivers/crypto/talitos/talitos.h      | 167 +++++++++++++++++++++++++++++++
 2 files changed, 194 insertions(+), 155 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-core.c b/drivers/crypto/talitos/talitos-core.c
index dfc49bc2db86..80dcab4ab54b 100644
--- a/drivers/crypto/talitos/talitos-core.c
+++ b/drivers/crypto/talitos/talitos-core.c
@@ -42,99 +42,6 @@
 
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
@@ -305,11 +212,11 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
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
 
@@ -941,7 +830,7 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
 	return err;
 }
 
-static void talitos_sg_unmap(struct device *dev,
+void talitos_sg_unmap(struct device *dev,
 			     struct talitos_edesc *edesc,
 			     struct scatterlist *src,
 			     struct scatterlist *dst,
@@ -1126,7 +1015,7 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 	return count;
 }
 
-static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
+int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 			      unsigned int len, struct talitos_edesc *edesc,
 			      struct talitos_ptr *ptr, int sg_count,
 			      unsigned int offset, int tbl_off, int elen,
@@ -1163,7 +1052,7 @@ static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 	return sg_count;
 }
 
-static int talitos_sg_map(struct device *dev, struct scatterlist *src,
+int talitos_sg_map(struct device *dev, struct scatterlist *src,
 			  unsigned int len, struct talitos_edesc *edesc,
 			  struct talitos_ptr *ptr, int sg_count,
 			  unsigned int offset, int tbl_off)
@@ -1301,17 +1190,17 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
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
@@ -2187,18 +2076,6 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
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
@@ -3001,14 +2878,8 @@ static struct talitos_alg_template driver_algs[] = {
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
 
@@ -3068,7 +2939,7 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 	return talitos_init_common(ctx, talitos_alg);
 }
 
-static void talitos_cra_exit(struct crypto_tfm *tfm)
+void talitos_cra_exit(struct crypto_tfm *tfm)
 {
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct device *dev = ctx->dev;
@@ -3082,7 +2953,7 @@ static void talitos_cra_exit(struct crypto_tfm *tfm)
  * type and primary/secondary execution units required match the hw
  * capabilities description provided in the device tree node.
  */
-static int hw_supports(struct device *dev, __be32 desc_hdr_template)
+int talitos_hw_supports(struct device *dev, __be32 desc_hdr_template)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int ret;
@@ -3119,7 +2990,7 @@ static void talitos_remove(struct platform_device *ofdev)
 		list_del(&t_alg->entry);
 	}
 
-	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
+	if (talitos_hw_supports(dev, DESC_HDR_SEL0_RNG))
 		talitos_unregister_rng(dev);
 
 	for (i = 0; i < 2; i++)
@@ -3433,7 +3304,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		goto err_out;
 
 	/* register the RNG, if available */
-	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
+	if (talitos_hw_supports(dev, DESC_HDR_SEL0_RNG)) {
 		err = talitos_register_rng(dev);
 		if (err) {
 			dev_err(dev, "failed to register hwrng: %d\n", err);
@@ -3444,7 +3315,8 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	/* register crypto algorithms the device supports */
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
-		if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
+		if (talitos_hw_supports(dev,
+					driver_algs[i].desc_hdr_template)) {
 			struct talitos_crypto_alg *t_alg;
 			struct crypto_alg *alg = NULL;
 
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index fa8c71b1f90f..24b4d541df2c 100644
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
+static inline void __map_single_talitos_ptr(struct device *dev,
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
2.56.0

