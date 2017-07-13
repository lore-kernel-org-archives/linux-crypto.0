From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 1/3] crypto: stm32 - CRC use relaxed function
Date: Thu, 13 Jul 2017 15:06:31 +0200
Message-ID: <05aae64aaee08aa97b53179d64be1a76e0d9c182.1499950409.git.lionel.debieve@st.com>
References: <cover.1499950409.git.lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Lionel Debieve <lionel.debieve@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:28410 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752358AbdGMNHq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 09:07:46 -0400
In-Reply-To: <cover.1499950409.git.lionel.debieve@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In case of arm soc support, readl and writel will
be optimized using relaxed functions

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/crypto/stm32/stm32_crc32.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32_crc32.c
index ec83b1e..04d2f4b 100644
--- a/drivers/crypto/stm32/stm32_crc32.c
+++ b/drivers/crypto/stm32/stm32_crc32.c
@@ -107,12 +107,12 @@ static int stm32_crc_init(struct shash_desc *desc)
 	spin_unlock_bh(&crc_list.lock);
 
 	/* Reset, set key, poly and configure in bit reverse mode */
-	writel(bitrev32(mctx->key), ctx->crc->regs + CRC_INIT);
-	writel(bitrev32(mctx->poly), ctx->crc->regs + CRC_POL);
-	writel(CRC_CR_RESET | CRC_CR_REVERSE, ctx->crc->regs + CRC_CR);
+	writel_relaxed(bitrev32(mctx->key), ctx->crc->regs + CRC_INIT);
+	writel_relaxed(bitrev32(mctx->poly), ctx->crc->regs + CRC_POL);
+	writel_relaxed(CRC_CR_RESET | CRC_CR_REVERSE, ctx->crc->regs + CRC_CR);
 
 	/* Store partial result */
-	ctx->partial = readl(ctx->crc->regs + CRC_DR);
+	ctx->partial = readl_relaxed(ctx->crc->regs + CRC_DR);
 	ctx->crc->nb_pending_bytes = 0;
 
 	return 0;
@@ -135,7 +135,8 @@ static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
 
 		if (crc->nb_pending_bytes == sizeof(u32)) {
 			/* Process completed pending data */
-			writel(*(u32 *)crc->pending_data, crc->regs + CRC_DR);
+			writel_relaxed(*(u32 *)crc->pending_data,
+				       crc->regs + CRC_DR);
 			crc->nb_pending_bytes = 0;
 		}
 	}
@@ -143,10 +144,10 @@ static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
 	d32 = (u32 *)d8;
 	for (i = 0; i < length >> 2; i++)
 		/* Process 32 bits data */
-		writel(*(d32++), crc->regs + CRC_DR);
+		writel_relaxed(*(d32++), crc->regs + CRC_DR);
 
 	/* Store partial result */
-	ctx->partial = readl(crc->regs + CRC_DR);
+	ctx->partial = readl_relaxed(crc->regs + CRC_DR);
 
 	/* Check for pending data (non 32 bits) */
 	length &= 3;
-- 
2.7.4
