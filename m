Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2474E37267B
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784641262; cv=none; b=ddG6kuwoK8akZk5Cf3H9YFZmBnzSt+HDWLVtMjK6FYUsRymlaDpbkwzR5irZpJMYaD4AKR6d8Jl+mRTMSy0rAqqbVAHozhxWmTvbED+7aliw517SZn/lF4z1IHr9GPA7oxHKMDjjIDEBBJ2f+lT8UTedbZB7848x6dRgqp4UU68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784641262; c=relaxed/simple;
	bh=XNxKGUyNJ2pVUAmB0BJ6R8l3pXC46nTBdhveQVesYiE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=twMDZZz4fQ9/voRic0yTObDV4yZXekGh8t6UEO43xZ6VodhzJLpolgi29pXnXK5kEYFdAjYlWuwWIzO6d4O+N+GiXurV1s1m7RfOy9KG+qneKgfnYibKzUE8cl1W3slPMUmX7bd6hUKVuWUvPpHFqXmjawCsLJOPcb78NI6ACBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=dPgCCPCx; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="dPgCCPCx"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 6D4931A113D;
	Tue, 21 Jul 2026 13:40:57 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 427F560368;
	Tue, 21 Jul 2026 13:40:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6B15411BD3B3A;
	Tue, 21 Jul 2026 15:40:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784641256; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=U00tSCZGPEdfU2RMLoXy2dxoBApBfGuF06F/lSXcJCg=;
	b=dPgCCPCxOXGHOE1aZP5i5BLsp0TtFiOt6kaWJqEWCxugGaRMe5kD4B54IA2zeI0Po+Grzx
	8eNuZ2esQFZaFyeHt6Y6P2HNzGCznkG632pPwad5jvx9hPSu6ZHQmTEkt8/hyK0ViKVjLp
	M3kf2GWSky3dDY0vaQGG9UNH53mn0P5tRDc2sEJ6PQcNHk9o+dLn/fUU4Uu3p01aQmrL/Q
	MFC6Sblwbqr7Gqy/5B6XyddK2El4ANZ6iKb25kKXeDkoZ3X86Rckm6z/5sIX2AG35iqqoZ
	5ouTq0QGdTZJsYV/0dKsYwZPnC6asG+ikD9nFiHvb4jSjcxUJopV8+0u/OvAwA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:40:15 +0200
Subject: [PATCH v3 05/19] crypto: talitos - Prepare crypto implementation
 file splitting
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-5-6e94359bf72d@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-6e94359bf72d@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-6e94359bf72d@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784641243; l=15994;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=XNxKGUyNJ2pVUAmB0BJ6R8l3pXC46nTBdhveQVesYiE=;
 b=zUYodZa7pnqyXxNumkeAnRgpog/1R+pHxXEPk8DBXEtu3UkkcqKJmfXbytgIbyINVNP3Sgc6Q
 SVT9qTzVqDPBoHCwNFzQTiOMdpN3IQWw3xt2d+QukJibK/PHQXLv6fU
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
index 074f399b6327..dc92b98ec5ef 100644
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
@@ -2176,18 +2065,6 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
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
@@ -2990,14 +2867,8 @@ static struct talitos_alg_template driver_algs[] = {
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
 
@@ -3057,7 +2928,7 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 	return talitos_init_common(ctx, talitos_alg);
 }
 
-static void talitos_cra_exit(struct crypto_tfm *tfm)
+void talitos_cra_exit(struct crypto_tfm *tfm)
 {
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct device *dev = ctx->dev;
@@ -3071,7 +2942,7 @@ static void talitos_cra_exit(struct crypto_tfm *tfm)
  * type and primary/secondary execution units required match the hw
  * capabilities description provided in the device tree node.
  */
-static int hw_supports(struct device *dev, __be32 desc_hdr_template)
+int talitos_hw_supports(struct device *dev, __be32 desc_hdr_template)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int ret;
@@ -3108,7 +2979,7 @@ static void talitos_remove(struct platform_device *ofdev)
 		list_del(&t_alg->entry);
 	}
 
-	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
+	if (talitos_hw_supports(dev, DESC_HDR_SEL0_RNG))
 		talitos_unregister_rng(dev);
 
 	for (i = 0; i < 2; i++)
@@ -3417,7 +3288,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* register the RNG, if available */
-	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
+	if (talitos_hw_supports(dev, DESC_HDR_SEL0_RNG)) {
 		err = talitos_register_rng(dev);
 		if (err) {
 			dev_err(dev, "failed to register hwrng: %d\n", err);
@@ -3428,7 +3299,8 @@ static int talitos_probe(struct platform_device *ofdev)
 
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
2.55.0

