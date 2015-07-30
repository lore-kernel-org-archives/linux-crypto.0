From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH 04/12] crypto: caam - Modify Freescale CAAM driver Scatter Gather entry definition
Date: Wed, 29 Jul 2015 20:58:21 -0700
Message-ID: <1438228709-27650-5-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0147.outbound.protection.outlook.com ([207.46.100.147]:27136
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750732AbbG3Ebt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 00:31:49 -0400
In-Reply-To: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Modify the Scatter-Gather entry definitions for the Freescale
CAAM driver to include support for both 64- and 32-bit DMA pointers.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/desc.h       | 25 +++++++++++++++++++++----
 drivers/crypto/caam/sg_sw_sec4.h |  1 -
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index d397ff9..405acbf 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -8,12 +8,29 @@
 #ifndef DESC_H
 #define DESC_H
 
+/*
+ * 16-byte hardware scatter/gather table
+ * An 8-byte table exists in the hardware spec, but has never been
+ * implemented to date. The 8/16 option is selected at RTL-compile-time.
+ * and this selection is visible in the Compile Time Parameters Register
+ */
+
+#define SEC4_SG_LEN_EXT		0x80000000	/* Entry points to table */
+#define SEC4_SG_LEN_FIN		0x40000000	/* Last ent in table */
+#define SEC4_SG_BPID_MASK	0x000000ff
+#define SEC4_SG_BPID_SHIFT	16
+#define SEC4_SG_LEN_MASK	0x3fffffff	/* Excludes EXT and FINAL */
+#define SEC4_SG_OFFS_MASK	0x00001fff
+
 struct sec4_sg_entry {
-	u64 ptr;
-#define SEC4_SG_LEN_FIN 0x40000000
-#define SEC4_SG_LEN_EXT 0x80000000
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	dma_addr_t ptr;
+#else
+	u32 rsvd1;
+	dma_addr_t ptr;
+#endif
 	u32 len;
-	u8 reserved;
+	u8 rsvd2;
 	u8 buf_pool_id;
 	u16 offset;
 };
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index b68b74c..711bb39 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -15,7 +15,6 @@ static inline void dma_to_sec4_sg_one(struct sec4_sg_entry *sec4_sg_ptr,
 {
 	sec4_sg_ptr->ptr = dma;
 	sec4_sg_ptr->len = len;
-	sec4_sg_ptr->reserved = 0;
 	sec4_sg_ptr->buf_pool_id = 0;
 	sec4_sg_ptr->offset = offset;
 #ifdef DEBUG
-- 
2.1.4
