From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v2] crypto: caam - treat SGT address pointer as u64
Date: Fri, 30 Sep 2016 12:09:39 +0300
Message-ID: <1475226579-2078-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <fabio.estevam@nxp.com>, <horia.geanta@nxp.com>,
        <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:5332
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932413AbcI3Jnd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Sep 2016 05:43:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Even for i.MX, CAAM is able to use address pointers greater than
32 bits, the address pointer field being interpreted as a double word.
Enforce u64 address pointer in the sec4_sg_entry struct.

This patch fixes the SGT address pointer endianness issue for
32bit platforms where core endianness != caam endianness.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
v2: Removed mx7d restriction.

 drivers/crypto/caam/desc.h       | 6 ------
 drivers/crypto/caam/regs.h       | 8 ++++++++
 drivers/crypto/caam/sg_sw_sec4.h | 2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 26427c1..513b664 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -23,13 +23,7 @@
 #define SEC4_SG_OFFSET_MASK	0x00001fff
 
 struct sec4_sg_entry {
-#if !defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) && \
-	defined(CONFIG_CRYPTO_DEV_FSL_CAAM_IMX)
-	u32 rsvd1;
-	dma_addr_t ptr;
-#else
 	u64 ptr;
-#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_IMX */
 	u32 len;
 	u32 bpid_offset;
 };
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index b3c5016..84d2f83 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -196,6 +196,14 @@ static inline u64 rd_reg64(void __iomem *reg)
 #define caam_dma_to_cpu(value) caam32_to_cpu(value)
 #endif /* CONFIG_ARCH_DMA_ADDR_T_64BIT  */
 
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
+#define cpu_to_caam_dma64(value) \
+		(((u64)cpu_to_caam32(lower_32_bits(value)) << 32) | \
+		 (u64)cpu_to_caam32(upper_32_bits(value)))
+#else
+#define cpu_to_caam_dma64(value) cpu_to_caam64(value)
+#endif
+
 /*
  * jr_outentry
  * Represents each entry in a JobR output ring
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index 19dc64f..41cd5a3 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -15,7 +15,7 @@ struct sec4_sg_entry;
 static inline void dma_to_sec4_sg_one(struct sec4_sg_entry *sec4_sg_ptr,
 				      dma_addr_t dma, u32 len, u16 offset)
 {
-	sec4_sg_ptr->ptr = cpu_to_caam_dma(dma);
+	sec4_sg_ptr->ptr = cpu_to_caam_dma64(dma);
 	sec4_sg_ptr->len = cpu_to_caam32(len);
 	sec4_sg_ptr->bpid_offset = cpu_to_caam32(offset & SEC4_SG_OFFSET_MASK);
 #ifdef DEBUG
-- 
1.8.3.1
