Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C0F1F0E5F
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772292; cv=none; b=aOxswDy/UwWqS9Ai31qdqm0/401J0GC4YjL9V8mskEq+y4M/jt/R198MuugpzPIhJ35wuE4OAY+SdIB2/OvTRDgD5lr37yYOML9javQZqAyGykKS0veqrJxI+Zdzj+n1CbD7iN2GLsGtlgbjN0pX0EI9y6O3T7/UWubWZvXmB+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772292; c=relaxed/simple;
	bh=qJ8+hZyETm23N5a/uptwvwer/epz/AF43NJnCgoO2n8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puooNoxggoRd6nraKpEutZbpU8a9KhZ1UkBOLNraldy5l8PvdULEy6MiLPHDmJ9EHadUWP5v0MMAYn5tCUOSJmHu/00uqdAOjNbEoq2NK6FnCkUIbtG7FoHY+FF5Q3LiD1P4uAGpyeyRCvKCAuy4mzNenOMC/FR7R8AQ+ZLA3yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGlRxxi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGlRxxi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E07DC4CED7
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772292;
	bh=qJ8+hZyETm23N5a/uptwvwer/epz/AF43NJnCgoO2n8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mGlRxxi6oVh+DLhSjkcUgIu56tM0PwYBQQS7+sBRwFfuINUZNxUJV+K5TD5ZUlqDU
	 4t91+cBEqaNyVKg7d9HQsve2JGwpQtyEzwjsai3Jbbg4EvQsWA56pbQiUpDNUzogO7
	 qN/JbSv9GfM7P8jBAlD8rsK4Xij6VciZhJ1W3ID9Fb3bVBNdjGuRabg3MU8DEWa/kN
	 muymEOoXpgBbA/WqMIXgtkzZFKH2TLH0E8RpGNoE4qIJYiLOf/gNzZenDEJ9plHpHT
	 qf3lLap4Fo97cBjkIqIjceu7jOCDvQtHTi0PZXK19ijP9p8xYX1KL1HcQwOLuzMyDi
	 9wR3aDH44T/Zg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 09/29] crypto: omap - switch from scatter_walk to plain offset
Date: Sat, 21 Dec 2024 01:10:36 -0800
Message-ID: <20241221091056.282098-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The omap driver was using struct scatter_walk, but only to maintain an
offset, rather than iterating through the virtual addresses of the data
contained in the scatterlist which is what scatter_walk is intended for.
Make it just use a plain offset instead.  This is simpler and avoids
depending on functions that are planned to be removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/omap-aes.c | 34 ++++++++++++++-------------------
 drivers/crypto/omap-aes.h |  6 ++----
 drivers/crypto/omap-des.c | 40 ++++++++++++++++-----------------------
 3 files changed, 32 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index e27b84616743..551dd32a8db0 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -16,11 +16,10 @@
 #include <crypto/aes.h>
 #include <crypto/gcm.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/engine.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/scatterwalk.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -270,13 +269,13 @@ static int omap_aes_crypt_dma(struct omap_aes_dev *dd,
 	struct dma_async_tx_descriptor *tx_in, *tx_out = NULL, *cb_desc;
 	struct dma_slave_config cfg;
 	int ret;
 
 	if (dd->pio_only) {
-		scatterwalk_start(&dd->in_walk, dd->in_sg);
+		dd->in_sg_offset = 0;
 		if (out_sg_len)
-			scatterwalk_start(&dd->out_walk, dd->out_sg);
+			dd->out_sg_offset = 0;
 
 		/* Enable DATAIN interrupt and let it take
 		   care of the rest */
 		omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x2);
 		return 0;
@@ -869,25 +868,22 @@ static irqreturn_t omap_aes_irq(int irq, void *dev_id)
 	if (status & AES_REG_IRQ_DATA_IN) {
 		omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x0);
 
 		BUG_ON(!dd->in_sg);
 
-		BUG_ON(_calc_walked(in) > dd->in_sg->length);
+		BUG_ON(dd->in_sg_offset > dd->in_sg->length);
 
-		src = sg_virt(dd->in_sg) + _calc_walked(in);
+		src = sg_virt(dd->in_sg) + dd->in_sg_offset;
 
 		for (i = 0; i < AES_BLOCK_WORDS; i++) {
 			omap_aes_write(dd, AES_REG_DATA_N(dd, i), *src);
-
-			scatterwalk_advance(&dd->in_walk, 4);
-			if (dd->in_sg->length == _calc_walked(in)) {
+			dd->in_sg_offset += 4;
+			if (dd->in_sg_offset == dd->in_sg->length) {
 				dd->in_sg = sg_next(dd->in_sg);
 				if (dd->in_sg) {
-					scatterwalk_start(&dd->in_walk,
-							  dd->in_sg);
-					src = sg_virt(dd->in_sg) +
-					      _calc_walked(in);
+					dd->in_sg_offset = 0;
+					src = sg_virt(dd->in_sg);
 				}
 			} else {
 				src++;
 			}
 		}
@@ -902,24 +898,22 @@ static irqreturn_t omap_aes_irq(int irq, void *dev_id)
 	} else if (status & AES_REG_IRQ_DATA_OUT) {
 		omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x0);
 
 		BUG_ON(!dd->out_sg);
 
-		BUG_ON(_calc_walked(out) > dd->out_sg->length);
+		BUG_ON(dd->out_sg_offset > dd->out_sg->length);
 
-		dst = sg_virt(dd->out_sg) + _calc_walked(out);
+		dst = sg_virt(dd->out_sg) + dd->out_sg_offset;
 
 		for (i = 0; i < AES_BLOCK_WORDS; i++) {
 			*dst = omap_aes_read(dd, AES_REG_DATA_N(dd, i));
-			scatterwalk_advance(&dd->out_walk, 4);
-			if (dd->out_sg->length == _calc_walked(out)) {
+			dd->out_sg_offset += 4;
+			if (dd->out_sg_offset == dd->out_sg->length) {
 				dd->out_sg = sg_next(dd->out_sg);
 				if (dd->out_sg) {
-					scatterwalk_start(&dd->out_walk,
-							  dd->out_sg);
-					dst = sg_virt(dd->out_sg) +
-					      _calc_walked(out);
+					dd->out_sg_offset = 0;
+					dst = sg_virt(dd->out_sg);
 				}
 			} else {
 				dst++;
 			}
 		}
diff --git a/drivers/crypto/omap-aes.h b/drivers/crypto/omap-aes.h
index 0f35c9164764..41d67780fd45 100644
--- a/drivers/crypto/omap-aes.h
+++ b/drivers/crypto/omap-aes.h
@@ -12,12 +12,10 @@
 #include <crypto/aes.h>
 
 #define DST_MAXBURST			4
 #define DMA_MIN				(DST_MAXBURST * sizeof(u32))
 
-#define _calc_walked(inout) (dd->inout##_walk.offset - dd->inout##_sg->offset)
-
 /*
  * OMAP TRM gives bitfields as start:end, where start is the higher bit
  * number. For example 7:0
  */
 #define FLD_MASK(start, end)	(((1 << ((start) - (end) + 1)) - 1) << (end))
@@ -184,12 +182,12 @@ struct omap_aes_dev {
 	/* Buffers for copying for unaligned cases */
 	struct scatterlist		in_sgl[2];
 	struct scatterlist		out_sgl;
 	struct scatterlist		*orig_out;
 
-	struct scatter_walk		in_walk;
-	struct scatter_walk		out_walk;
+	unsigned int		in_sg_offset;
+	unsigned int		out_sg_offset;
 	struct dma_chan		*dma_lch_in;
 	struct dma_chan		*dma_lch_out;
 	int			in_sg_len;
 	int			out_sg_len;
 	int			pio_only;
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 498cbd585ed1..a099460d5f21 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -17,11 +17,10 @@
 #endif
 
 #include <crypto/engine.h>
 #include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/scatterwalk.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -38,12 +37,10 @@
 
 #define DST_MAXBURST			2
 
 #define DES_BLOCK_WORDS		(DES_BLOCK_SIZE >> 2)
 
-#define _calc_walked(inout) (dd->inout##_walk.offset - dd->inout##_sg->offset)
-
 #define DES_REG_KEY(dd, x)		((dd)->pdata->key_ofs - \
 						((x ^ 0x01) * 0x04))
 
 #define DES_REG_IV(dd, x)		((dd)->pdata->iv_ofs + ((x) * 0x04))
 
@@ -150,12 +147,12 @@ struct omap_des_dev {
 	/* Buffers for copying for unaligned cases */
 	struct scatterlist		in_sgl;
 	struct scatterlist		out_sgl;
 	struct scatterlist		*orig_out;
 
-	struct scatter_walk		in_walk;
-	struct scatter_walk		out_walk;
+	unsigned int		in_sg_offset;
+	unsigned int		out_sg_offset;
 	struct dma_chan		*dma_lch_in;
 	struct dma_chan		*dma_lch_out;
 	int			in_sg_len;
 	int			out_sg_len;
 	int			pio_only;
@@ -377,12 +374,12 @@ static int omap_des_crypt_dma(struct crypto_tfm *tfm,
 	struct dma_async_tx_descriptor *tx_in, *tx_out;
 	struct dma_slave_config cfg;
 	int ret;
 
 	if (dd->pio_only) {
-		scatterwalk_start(&dd->in_walk, dd->in_sg);
-		scatterwalk_start(&dd->out_walk, dd->out_sg);
+		dd->in_sg_offset = 0;
+		dd->out_sg_offset = 0;
 
 		/* Enable DATAIN interrupt and let it take
 		   care of the rest */
 		omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x2);
 		return 0;
@@ -834,25 +831,22 @@ static irqreturn_t omap_des_irq(int irq, void *dev_id)
 	if (status & DES_REG_IRQ_DATA_IN) {
 		omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x0);
 
 		BUG_ON(!dd->in_sg);
 
-		BUG_ON(_calc_walked(in) > dd->in_sg->length);
+		BUG_ON(dd->in_sg_offset > dd->in_sg->length);
 
-		src = sg_virt(dd->in_sg) + _calc_walked(in);
+		src = sg_virt(dd->in_sg) + dd->in_sg_offset;
 
 		for (i = 0; i < DES_BLOCK_WORDS; i++) {
 			omap_des_write(dd, DES_REG_DATA_N(dd, i), *src);
-
-			scatterwalk_advance(&dd->in_walk, 4);
-			if (dd->in_sg->length == _calc_walked(in)) {
+			dd->in_sg_offset += 4;
+			if (dd->in_sg_offset == dd->in_sg->length) {
 				dd->in_sg = sg_next(dd->in_sg);
 				if (dd->in_sg) {
-					scatterwalk_start(&dd->in_walk,
-							  dd->in_sg);
-					src = sg_virt(dd->in_sg) +
-					      _calc_walked(in);
+					dd->in_sg_offset = 0;
+					src = sg_virt(dd->in_sg);
 				}
 			} else {
 				src++;
 			}
 		}
@@ -867,24 +861,22 @@ static irqreturn_t omap_des_irq(int irq, void *dev_id)
 	} else if (status & DES_REG_IRQ_DATA_OUT) {
 		omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x0);
 
 		BUG_ON(!dd->out_sg);
 
-		BUG_ON(_calc_walked(out) > dd->out_sg->length);
+		BUG_ON(dd->out_sg_offset > dd->out_sg->length);
 
-		dst = sg_virt(dd->out_sg) + _calc_walked(out);
+		dst = sg_virt(dd->out_sg) + dd->out_sg_offset;
 
 		for (i = 0; i < DES_BLOCK_WORDS; i++) {
 			*dst = omap_des_read(dd, DES_REG_DATA_N(dd, i));
-			scatterwalk_advance(&dd->out_walk, 4);
-			if (dd->out_sg->length == _calc_walked(out)) {
+			dd->out_sg_offset += 4;
+			if (dd->out_sg_offset == dd->out_sg->length) {
 				dd->out_sg = sg_next(dd->out_sg);
 				if (dd->out_sg) {
-					scatterwalk_start(&dd->out_walk,
-							  dd->out_sg);
-					dst = sg_virt(dd->out_sg) +
-					      _calc_walked(out);
+					dd->out_sg_offset = 0;
+					dst = sg_virt(dd->out_sg);
 				}
 			} else {
 				dst++;
 			}
 		}
-- 
2.47.1

