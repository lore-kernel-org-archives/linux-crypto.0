Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9531A255B;
	Mon, 24 Jun 2024 23:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271382; cv=none; b=JBddgwpy47osXAm7dm7LRvUfEfnwVdkv1fUFeuGAUlOc9BQC1X4YBz8hbVOc0P5TvnzIScHJDPFAq4ev2OPGIW02R2U+GeY0meo+PUHwHz1uWSdJq9896IRPg8k8X7T/8Q8ih8p8BaX3i/Ec0GvmMZyZj/0Prhiw2oEJotHaSnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271382; c=relaxed/simple;
	bh=B/nKXcfo6yGQlfteVwjPpp6GHkEE00QbI1bPTrmms3I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WIoExVdmnjylMCy5ft8YFwT8H9Td8iAP2vMjobcOq+QdKD8lfFf1ETMo1ePJv3kNH6RduQV5Pqa69ECFxmRLBd6cK4wocKtOb6b6wmQO3TBwIBCnJh5twWl2I9pxciuUa9woh5XdLBlSdWZIxHazQqPKxc6O1grU+rOHaqpnn2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D933C14BF;
	Mon, 24 Jun 2024 16:23:24 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0328F3F766;
	Mon, 24 Jun 2024 16:22:57 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Ryan Walklin <ryan@testtoast.com>,
	Philippe Simons <simons.philippe@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	devicetree@vger.kernel.org
Subject: [PATCH v2 2/4] crypto: sun8i-ce - wrap accesses to descriptor address fields
Date: Tue, 25 Jun 2024 00:21:08 +0100
Message-Id: <20240624232110.9817-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.39.4
In-Reply-To: <20240624232110.9817-1-andre.przywara@arm.com>
References: <20240624232110.9817-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Allwinner H616 (and later) SoCs support more than 32 bits worth of
physical addresses. To accommodate the larger address space, the CE task
descriptor fields holding addresses are now encoded as "word addresses",
so take the actual address divided by four.
This is true for the fields within the descriptor, but also for the
descriptor base address, in the CE_TDA register.

Wrap all accesses to those fields in a function, which will do the
required division if needed. For now this in unused, so there should be
no change in behaviour.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c   |  8 ++++----
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c |  6 +++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c |  6 +++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c |  2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h      | 15 +++++++++++++++
 6 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index de50c00ba218f..19b7fb4a93e86 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -190,7 +190,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 		err = -EFAULT;
 		goto theend;
 	}
-	cet->t_key = cpu_to_le32(rctx->addr_key);
+	cet->t_key = desc_addr_val_le32(ce, rctx->addr_key);
 
 	ivsize = crypto_skcipher_ivsize(tfm);
 	if (areq->iv && crypto_skcipher_ivsize(tfm) > 0) {
@@ -208,7 +208,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 			err = -ENOMEM;
 			goto theend_iv;
 		}
-		cet->t_iv = cpu_to_le32(rctx->addr_iv);
+		cet->t_iv = desc_addr_val_le32(ce, rctx->addr_iv);
 	}
 
 	if (areq->src == areq->dst) {
@@ -236,7 +236,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
 	len = areq->cryptlen;
 	for_each_sg(areq->src, sg, nr_sgs, i) {
-		cet->t_src[i].addr = cpu_to_le32(sg_dma_address(sg));
+		cet->t_src[i].addr = desc_addr_val_le32(ce, sg_dma_address(sg));
 		todo = min(len, sg_dma_len(sg));
 		cet->t_src[i].len = cpu_to_le32(todo / 4);
 		dev_dbg(ce->dev, "%s total=%u SG(%d %u off=%d) todo=%u\n", __func__,
@@ -251,7 +251,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
 	len = areq->cryptlen;
 	for_each_sg(areq->dst, sg, nr_sgd, i) {
-		cet->t_dst[i].addr = cpu_to_le32(sg_dma_address(sg));
+		cet->t_dst[i].addr = desc_addr_val_le32(ce, sg_dma_address(sg));
 		todo = min(len, sg_dma_len(sg));
 		cet->t_dst[i].len = cpu_to_le32(todo / 4);
 		dev_dbg(ce->dev, "%s total=%u SG(%d %u off=%d) todo=%u\n", __func__,
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 0408b2d5d533b..6d45c1e559f7d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -172,7 +172,7 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 	writel(v, ce->base + CE_ICR);
 
 	reinit_completion(&ce->chanlist[flow].complete);
-	writel(ce->chanlist[flow].t_phy, ce->base + CE_TDQ);
+	writel(desc_addr_val(ce, ce->chanlist[flow].t_phy), ce->base + CE_TDQ);
 
 	ce->chanlist[flow].status = 0;
 	/* Be sure all data is written before enabling the task */
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index ee2a28c906ede..6072dd9f390b4 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -403,7 +403,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 
 	len = areq->nbytes;
 	for_each_sg(areq->src, sg, nr_sgs, i) {
-		cet->t_src[i].addr = cpu_to_le32(sg_dma_address(sg));
+		cet->t_src[i].addr = desc_addr_val_le32(ce, sg_dma_address(sg));
 		todo = min(len, sg_dma_len(sg));
 		cet->t_src[i].len = cpu_to_le32(todo / 4);
 		len -= todo;
@@ -414,7 +414,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 		goto theend;
 	}
 	addr_res = dma_map_single(ce->dev, result, digestsize, DMA_FROM_DEVICE);
-	cet->t_dst[0].addr = cpu_to_le32(addr_res);
+	cet->t_dst[0].addr = desc_addr_val_le32(ce, addr_res);
 	cet->t_dst[0].len = cpu_to_le32(digestsize / 4);
 	if (dma_mapping_error(ce->dev, addr_res)) {
 		dev_err(ce->dev, "DMA map dest\n");
@@ -445,7 +445,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	}
 
 	addr_pad = dma_map_single(ce->dev, buf, j * 4, DMA_TO_DEVICE);
-	cet->t_src[i].addr = cpu_to_le32(addr_pad);
+	cet->t_src[i].addr = desc_addr_val_le32(ce, addr_pad);
 	cet->t_src[i].len = cpu_to_le32(j);
 	if (dma_mapping_error(ce->dev, addr_pad)) {
 		dev_err(ce->dev, "DMA error on padding SG\n");
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
index 80815379f6fc5..762459867b6c5 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
@@ -132,10 +132,10 @@ int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
 	cet->t_sym_ctl = cpu_to_le32(sym);
 	cet->t_asym_ctl = 0;
 
-	cet->t_key = cpu_to_le32(dma_iv);
-	cet->t_iv = cpu_to_le32(dma_iv);
+	cet->t_key = desc_addr_val_le32(ce, dma_iv);
+	cet->t_iv = desc_addr_val_le32(ce, dma_iv);
 
-	cet->t_dst[0].addr = cpu_to_le32(dma_dst);
+	cet->t_dst[0].addr = desc_addr_val_le32(ce, dma_dst);
 	cet->t_dst[0].len = cpu_to_le32(todo / 4);
 	ce->chanlist[flow].timeout = 2000;
 
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
index 9c35f2a83eda8..e1e8bc15202e0 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
@@ -77,7 +77,7 @@ static int sun8i_ce_trng_read(struct hwrng *rng, void *data, size_t max, bool wa
 	cet->t_sym_ctl = 0;
 	cet->t_asym_ctl = 0;
 
-	cet->t_dst[0].addr = cpu_to_le32(dma_dst);
+	cet->t_dst[0].addr = desc_addr_val_le32(ce, dma_dst);
 	cet->t_dst[0].len = cpu_to_le32(todo / 4);
 	ce->chanlist[flow].timeout = todo;
 
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 93d4985def87a..3b5c2af013d0d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -149,6 +149,7 @@ struct ce_variant {
 	bool hash_t_dlen_in_bits;
 	bool prng_t_dlen_in_bytes;
 	bool trng_t_dlen_in_bytes;
+	bool needs_word_addresses;
 	struct ce_clock ce_clks[CE_MAX_CLOCKS];
 	int esr;
 	unsigned char prng;
@@ -241,6 +242,20 @@ struct sun8i_ce_dev {
 #endif
 };
 
+static inline u32 desc_addr_val(struct sun8i_ce_dev *dev, dma_addr_t addr)
+{
+	if (dev->variant->needs_word_addresses)
+		return addr / 4;
+
+	return addr;
+}
+
+static inline __le32 desc_addr_val_le32(struct sun8i_ce_dev *dev,
+					dma_addr_t addr)
+{
+	return cpu_to_le32(desc_addr_val(dev, addr));
+}
+
 /*
  * struct sun8i_cipher_req_ctx - context for a skcipher request
  * @op_dir:		direction (encrypt vs decrypt) for this request
-- 
2.39.4

