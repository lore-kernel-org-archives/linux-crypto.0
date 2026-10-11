Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51614433BB0;
	Sun, 11 Oct 2026 13:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791724564; cv=none; b=r79ghJ8npt9J25V0nd+frWbD0+73EH6pOPbVUZoUuvQm5La4qoCDqVN78n8X3AhLzh1zenGV83zfu6469wfgV5VlG/7tc6653w2vjctObhBH07pPCR+InA3WgtL4p0ya8aEkk9ErFQNHoTwsA6bkRgXRSBPgy8q/kHDPV9TqUaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791724564; c=relaxed/simple;
	bh=KEkmnMWgYaghFaXFMXtaovDls7gPJm8lfBR8aCes3mY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R/K7vLHdAFEy2+i4pI1MRPiz3YfW7BKJe+5jtGrRa7/ZJffEIyVZdUQbo7+mvm1Wp30h+lxtB81inLuEVeVfmURrmGMSL1fwfWQqNz6nKK/KqCW76JBfwhMV3rb+HMIeMMljiftAR7wLkRhWes+q0jEhbirMrSQd45EjJJ2b+30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLgiQH8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLgiQH8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A2D1F0089B;
	Sun, 11 Oct 2026 13:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791724562;
	bh=pe5ZoGWIz1vQLH5FnEmGSnJ3DTic8vhTTxWYQCwafgs=;
	h=From:To:Cc:Subject:Date;
	b=cLgiQH8V1smqJMLx/3kIeIAKEfO6jMkuAucYMIBpHFmHilnilK2DAPcDC06BG/r5C
	 Neg5maOVRxjWyXBjWpu8Ex9rewgBDSQSZcSI7lcOCtRKgXY2H83fsdyxxAO/a0MZv/
	 eUhELVRQqB8RrZbDMZi9Ioj3b5bVnIUyoWbSnFXzBpcVRvXDiMwjYSK4ZBDwTZklUj
	 ZeP59kj0d/XJ24aBS7O7XoW+fcQwiN3CeQqKSKX0qzTGvsz5SXUrlCqe4Hdt7SxFD/
	 Yk7o5C1Uf9nONXBa3A5pvplxBnu/QzJnLd1O6yu7qGfW/3dgZMmUrF/mGCpEKc2+Hi
	 nULrVLJW9SyTA==
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] crypto: atmel-tdes - use separate DMA scatterlists
Date: Sun, 11 Oct 2026 15:15:56 +0200
Message-ID: <20261011131556.272382-4-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2443; i=blum@kernel.org; h=from:subject; bh=KEkmnMWgYaghFaXFMXtaovDls7gPJm8lfBR8aCes3mY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmne3g2Kh/Pvi7Lv+O8rtKGWYGlITnSsRcKPaUXJAQtu fZ32r+ojlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiI2EGG/x4OEj7tXPGPVuTE KfPxyd9TPbT9f879A2Z7tK3/c//dcpPhv9u9iSG/atMneZlMM8z3ymetXDot6SDrIvHlYZUSoqs a+AA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use two separate input and output scatterlists instead of an array.

Also use DMA_SLAVE_BUSWIDTH_4_BYTES directly and drop the now-unused
addr_width variable.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index f084fda42423..b2fca4baee2f 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -372,37 +372,32 @@ static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
 				dma_addr_t dma_addr_in,
 				dma_addr_t dma_addr_out)
 {
-	struct scatterlist sg[2];
-	struct dma_async_tx_descriptor	*in_desc, *out_desc;
-	enum dma_slave_buswidth addr_width;
+	struct scatterlist sg_in, sg_out;
+	struct dma_async_tx_descriptor *in_desc, *out_desc;
 
-	addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-
-	dd->dma_lch_in.dma_conf.dst_addr_width = addr_width;
-	dd->dma_lch_out.dma_conf.src_addr_width = addr_width;
+	dd->dma_lch_in.dma_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dd->dma_lch_out.dma_conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 
 	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf);
 	dmaengine_slave_config(dd->dma_lch_out.chan, &dd->dma_lch_out.dma_conf);
 
 	dd->flags |= TDES_FLAGS_DMA;
 
-	sg_init_table(&sg[0], 1);
-	sg_dma_address(&sg[0]) = dma_addr_in;
-	sg_dma_len(&sg[0]) = dd->dma_size;
+	sg_init_table(&sg_in, 1);
+	sg_dma_address(&sg_in) = dma_addr_in;
+	sg_dma_len(&sg_in) = dd->dma_size;
 
-	sg_init_table(&sg[1], 1);
-	sg_dma_address(&sg[1]) = dma_addr_out;
-	sg_dma_len(&sg[1]) = dd->dma_size;
+	sg_init_table(&sg_out, 1);
+	sg_dma_address(&sg_out) = dma_addr_out;
+	sg_dma_len(&sg_out) = dd->dma_size;
 
-	in_desc = dmaengine_prep_slave_sg(dd->dma_lch_in.chan, &sg[0],
-				1, DMA_MEM_TO_DEV,
-				DMA_PREP_INTERRUPT  |  DMA_CTRL_ACK);
+	in_desc = dmaengine_prep_slave_sg(dd->dma_lch_in.chan, &sg_in, 1, DMA_MEM_TO_DEV,
+					  DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!in_desc)
 		return -EINVAL;
 
-	out_desc = dmaengine_prep_slave_sg(dd->dma_lch_out.chan, &sg[1],
-				1, DMA_DEV_TO_MEM,
-				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	out_desc = dmaengine_prep_slave_sg(dd->dma_lch_out.chan, &sg_out, 1, DMA_DEV_TO_MEM,
+					   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!out_desc)
 		return -EINVAL;
 
