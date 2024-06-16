Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644487317C;
	Sun, 16 Jun 2024 22:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718575743; cv=none; b=HQVzCUSeLe379jPO9oWwA5wqvQNnY0z4WLnPL7WYu0a3cwpCl2fNa4qUdrmxAS0pqtPWyslQsZtItoQ+GWL55qL2R58OQhZNYnvIr+H1B/AWIQr/PZLw69Mc+DtnDFHM/Y9pYLSkdWK6V+xCPEH29Qqy/KFHmF/difDVlJllyXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718575743; c=relaxed/simple;
	bh=vZxSHxbfbt3HjW3e0ai/LsmQdcjOkQEODGgM6YmdQQk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RshPixVdiF/GqQujTk7JnHzec+Tp+x3nfrYvCiZ1gazTk/8rrvhpCD5rz64zbBcayWib10oTodIzukhuM8zX25p7H9EYvKthBMHA+osNGVK9PMIAwJfSD9Hter1VqcjaVeDvio1AxifAk1kj6Oq3OPThrN6ZKLZO7TTwnWs/oFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C88981476;
	Sun, 16 Jun 2024 15:09:20 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D7293F73B;
	Sun, 16 Jun 2024 15:08:54 -0700 (PDT)
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
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	devicetree@vger.kernel.org
Subject: [PATCH 2/4] crypto: sun8i-ce - wrap accesses to descriptor address fields
Date: Sun, 16 Jun 2024 23:07:17 +0100
Message-Id: <20240616220719.26641-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.39.4
In-Reply-To: <20240616220719.26641-1-andre.przywara@arm.com>
References: <20240616220719.26641-1-andre.przywara@arm.com>
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
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c |  8 ++++----
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   |  3 ++-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   |  6 +++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c   |  6 +++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c   |  2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h        | 10 ++++++++++
 6 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index de50c00ba218f..3a5674b1bd3c0 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -190,7 +190,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 		err = -EFAULT;
 		goto theend;
 	}
-	cet->t_key = cpu_to_le32(rctx->addr_key);
+	cet->t_key = sun8i_ce_desc_addr(ce, rctx->addr_key);
 
 	ivsize = crypto_skcipher_ivsize(tfm);
 	if (areq->iv && crypto_skcipher_ivsize(tfm) > 0) {
@@ -208,7 +208,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 			err = -ENOMEM;
 			goto theend_iv;
 		}
-		cet->t_iv = cpu_to_le32(rctx->addr_iv);
+		cet->t_iv = sun8i_ce_desc_addr(ce, rctx->addr_iv);
 	}
 
 	if (areq->src == areq->dst) {
@@ -236,7 +236,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
 	len = areq->cryptlen;
 	for_each_sg(areq->src, sg, nr_sgs, i) {
-		cet->t_src[i].addr = cpu_to_le32(sg_dma_address(sg));
+		cet->t_src[i].addr = sun8i_ce_desc_addr(ce, sg_dma_address(sg));
 		todo = min(len, sg_dma_len(sg));
 		cet->t_src[i].len = cpu_to_le32(todo / 4);
 		dev_dbg(ce->dev, "%s total=%u SG(%d %u off=%d) todo=%u\n", __func__,
@@ -251,7 +251,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
 	len = areq->cryptlen;
 	for_each_sg(areq->dst, sg, nr_sgd, i) {
-		cet->t_dst[i].addr = cpu_to_le32(sg_dma_address(sg));
+		cet->t_dst[i].addr = sun8i_ce_desc_addr(ce, sg_dma_address(sg));
 		todo = min(len, sg_dma_len(sg));
 		cet->t_dst[i].len = cpu_to_le32(todo / 4);
 		dev_dbg(ce->dev, "%s total=%u SG(%d %u off=%d) todo=%u\n", __func__,
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 0408b2d5d533b..89ab3e08f0697 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -172,7 +172,8 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 	writel(v, ce->base + CE_ICR);
 
 	reinit_completion(&ce->chanlist[flow].complete);
-	writel(ce->chanlist[flow].t_phy, ce->base + CE_TDQ);
+	writel(sun8i_ce_desc_addr(ce, ce->chanlist[flow].t_phy),
+	       ce->base + CE_TDQ);
 
 	ce->chanlist[flow].status = 0;
 	/* Be sure all data is written before enabling the task */
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index ee2a28c906ede..a710ec9aa96f1 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -403,7 +403,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 
 	len = areq->nbytes;
 	for_each_sg(areq->src, sg, nr_sgs, i) {
-		cet->t_src[i].addr = cpu_to_le32(sg_dma_address(sg));
+		cet->t_src[i].addr = sun8i_ce_desc_addr(ce, sg_dma_address(sg));
 		todo = min(len, sg_dma_len(sg));
 		cet->t_src[i].len = cpu_to_le32(todo / 4);
 		len -= todo;
@@ -414,7 +414,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 		goto theend;
 	}
 	addr_res = dma_map_single(ce->dev, result, digestsize, DMA_FROM_DEVICE);
-	cet->t_dst[0].addr = cpu_to_le32(addr_res);
+	cet->t_dst[0].addr = sun8i_ce_desc_addr(ce, addr_res);
 	cet->t_dst[0].len = cpu_to_le32(digestsize / 4);
 	if (dma_mapping_error(ce->dev, addr_res)) {
 		dev_err(ce->dev, "DMA map dest\n");
@@ -445,7 +445,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	}
 
 	addr_pad = dma_map_single(ce->dev, buf, j * 4, DMA_TO_DEVICE);
-	cet->t_src[i].addr = cpu_to_le32(addr_pad);
+	cet->t_src[i].addr = sun8i_ce_desc_addr(ce, addr_pad);
 	cet->t_src[i].len = cpu_to_le32(j);
 	if (dma_mapping_error(ce->dev, addr_pad)) {
 		dev_err(ce->dev, "DMA error on padding SG\n");
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
index 80815379f6fc5..f030167f95945 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
@@ -132,10 +132,10 @@ int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
 	cet->t_sym_ctl = cpu_to_le32(sym);
 	cet->t_asym_ctl = 0;
 
-	cet->t_key = cpu_to_le32(dma_iv);
-	cet->t_iv = cpu_to_le32(dma_iv);
+	cet->t_key = sun8i_ce_desc_addr(ce, dma_iv);
+	cet->t_iv = sun8i_ce_desc_addr(ce, dma_iv);
 
-	cet->t_dst[0].addr = cpu_to_le32(dma_dst);
+	cet->t_dst[0].addr = sun8i_ce_desc_addr(ce, dma_dst);
 	cet->t_dst[0].len = cpu_to_le32(todo / 4);
 	ce->chanlist[flow].timeout = 2000;
 
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
index 9c35f2a83eda8..465c1c512eb85 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
@@ -77,7 +77,7 @@ static int sun8i_ce_trng_read(struct hwrng *rng, void *data, size_t max, bool wa
 	cet->t_sym_ctl = 0;
 	cet->t_asym_ctl = 0;
 
-	cet->t_dst[0].addr = cpu_to_le32(dma_dst);
+	cet->t_dst[0].addr = sun8i_ce_desc_addr(ce, dma_dst);
 	cet->t_dst[0].len = cpu_to_le32(todo / 4);
 	ce->chanlist[flow].timeout = todo;
 
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 93d4985def87a..8fa58f3bb7f86 100644
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
@@ -241,6 +242,15 @@ struct sun8i_ce_dev {
 #endif
 };
 
+static inline __le32 sun8i_ce_desc_addr(struct sun8i_ce_dev *dev,
+					dma_addr_t addr)
+{
+	if (dev->variant->needs_word_addresses)
+		return cpu_to_le32(addr / 4);
+
+	return cpu_to_le32(addr);
+}
+
 /*
  * struct sun8i_cipher_req_ctx - context for a skcipher request
  * @op_dir:		direction (encrypt vs decrypt) for this request
-- 
2.39.4

