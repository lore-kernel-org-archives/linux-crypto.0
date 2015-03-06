From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 01/17] crypto: talitos - base address for Execution Units and macro for ISR masks
Date: Fri,  6 Mar 2015 17:37:45 +0100 (CET)
Message-ID: <20150306163745.66B581A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:53966 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbbCFQhs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 11:37:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SEC1 and SEC2 have different EU base addresses, so define base addresses
as #define
SEC1 and SEC2 have different bit masks for ISR registers, so create a
macro to define them

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.h | 85 ++++++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 61a1405..102dc99 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -149,6 +149,8 @@ extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
  * TALITOS_xxx_LO addresses point to the low data bits (32-63) of the register
  */
 
+#define ISR_FORMAT(x)			(((x) << 4) | (x))
+
 /* global register offset addresses */
 #define TALITOS_MCR			0x1030  /* master control register */
 #define   TALITOS_MCR_RCA0		(1 << 15) /* remap channel 0 */
@@ -163,12 +165,12 @@ extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 #define TALITOS_IMR_LO			0x100C
 #define   TALITOS_IMR_LO_INIT		0x20000 /* allow RNGU error IRQs */
 #define TALITOS_ISR			0x1010  /* interrupt status register */
-#define   TALITOS_ISR_4CHERR		0xaa    /* 4 channel errors mask */
-#define   TALITOS_ISR_4CHDONE		0x55    /* 4 channel done mask */
-#define   TALITOS_ISR_CH_0_2_ERR	0x22    /* channels 0, 2 errors mask */
-#define   TALITOS_ISR_CH_0_2_DONE	0x11    /* channels 0, 2 done mask */
-#define   TALITOS_ISR_CH_1_3_ERR	0x88    /* channels 1, 3 errors mask */
-#define   TALITOS_ISR_CH_1_3_DONE	0x44    /* channels 1, 3 done mask */
+#define   TALITOS_ISR_4CHERR		ISR_FORMAT(0xa)	/* 4 ch errors mask */
+#define   TALITOS_ISR_4CHDONE		ISR_FORMAT(0x5)	/* 4 ch done mask */
+#define   TALITOS_ISR_CH_0_2_ERR	ISR_FORMAT(0x2)	/* ch 0, 2 err mask */
+#define   TALITOS_ISR_CH_0_2_DONE	ISR_FORMAT(0x1)	/* ch 0, 2 done mask */
+#define   TALITOS_ISR_CH_1_3_ERR	ISR_FORMAT(0x8)	/* ch 1, 3 err mask */
+#define   TALITOS_ISR_CH_1_3_DONE	ISR_FORMAT(0x4)	/* ch 1, 3 done mask */
 #define TALITOS_ISR_LO			0x1014
 #define TALITOS_ICR			0x1018  /* interrupt clear register */
 #define TALITOS_ICR_LO			0x101C
@@ -224,37 +226,56 @@ extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 #define TALITOS_SCATTER			0xe0
 #define TALITOS_SCATTER_LO		0xe4
 
+/* execution unit registers base */
+#define TALITOS_DEU			0x2000
+#define TALITOS_AESU			0x4000
+#define TALITOS_MDEU			0x6000
+#define TALITOS_AFEU			0x8000
+#define TALITOS_RNGU			0xa000
+#define TALITOS_PKEU			0xc000
+#define TALITOS_KEU			0xe000
+#define TALITOS_CRCU			0xf000
+
 /* execution unit interrupt status registers */
-#define TALITOS_DEUISR			0x2030 /* DES unit */
-#define TALITOS_DEUISR_LO		0x2034
-#define TALITOS_AESUISR			0x4030 /* AES unit */
-#define TALITOS_AESUISR_LO		0x4034
-#define TALITOS_MDEUISR			0x6030 /* message digest unit */
-#define TALITOS_MDEUISR_LO		0x6034
-#define TALITOS_MDEUICR			0x6038 /* interrupt control */
-#define TALITOS_MDEUICR_LO		0x603c
+/* DES unit */
+#define TALITOS_DEUISR			(TALITOS_DEU + 0x30)
+#define TALITOS_DEUISR_LO		(TALITOS_DEU + 0x34)
+#define TALITOS_DEUICR			(TALITOS_DEU + 0x38) /* int. control */
+/* AES unit */
+#define TALITOS_AESUISR			(TALITOS_AESU + 0x30)
+#define TALITOS_AESUISR_LO		(TALITOS_AESU + 0x34)
+/* message digest unit */
+#define TALITOS_MDEUISR			(TALITOS_MDEU + 0x30)
+#define TALITOS_MDEUISR_LO		(TALITOS_MDEU + 0x34)
+#define TALITOS_MDEUICR			(TALITOS_MDEU + 0x38) /* int. control */
+#define TALITOS_MDEUICR_LO		(TALITOS_MDEU + 0x3c)
 #define   TALITOS_MDEUICR_LO_ICE	0x4000 /* integrity check IRQ enable */
-#define TALITOS_AFEUISR			0x8030 /* arc4 unit */
-#define TALITOS_AFEUISR_LO		0x8034
-#define TALITOS_RNGUISR			0xa030 /* random number unit */
-#define TALITOS_RNGUISR_LO		0xa034
-#define TALITOS_RNGUSR			0xa028 /* rng status */
-#define TALITOS_RNGUSR_LO		0xa02c
+/* arc4 unit */
+#define TALITOS_AFEUISR			(TALITOS_AFEU + 0x30)
+#define TALITOS_AFEUISR_LO		(TALITOS_AFEU + 0x34)
+/* random number unit */
+#define TALITOS_RNGUISR			(TALITOS_RNGU + 0x30)
+#define TALITOS_RNGUISR_LO		(TALITOS_RNGU + 0x34)
+#define TALITOS_RNGUSR			(TALITOS_RNGU + 0x28) /* rng status */
+#define TALITOS_RNGUSR_LO		(TALITOS_RNGU + 0x2c)
 #define   TALITOS_RNGUSR_LO_RD		0x1	/* reset done */
 #define   TALITOS_RNGUSR_LO_OFL		0xff0000/* output FIFO length */
-#define TALITOS_RNGUDSR			0xa010	/* data size */
-#define TALITOS_RNGUDSR_LO		0xa014
-#define TALITOS_RNGU_FIFO		0xa800	/* output FIFO */
-#define TALITOS_RNGU_FIFO_LO		0xa804	/* output FIFO */
-#define TALITOS_RNGURCR			0xa018	/* reset control */
-#define TALITOS_RNGURCR_LO		0xa01c
+#define TALITOS_RNGUDSR			(TALITOS_RNGU + 0x10)	/* data size */
+#define TALITOS_RNGUDSR_LO		(TALITOS_RNGU + 0x14)
+#define TALITOS_RNGU_FIFO		(TALITOS_RNGU + 0x800) /* output FIFO */
+#define TALITOS_RNGU_FIFO_LO		(TALITOS_RNGU + 0x804) /* output FIFO */
+#define TALITOS_RNGURCR			(TALITOS_RNGU + 0x18) /* reset control*/
+#define TALITOS_RNGURCR_LO		(TALITOS_RNGU + 0x1c)
 #define   TALITOS_RNGURCR_LO_SR		0x1	/* software reset */
-#define TALITOS_PKEUISR			0xc030 /* public key unit */
-#define TALITOS_PKEUISR_LO		0xc034
-#define TALITOS_KEUISR			0xe030 /* kasumi unit */
-#define TALITOS_KEUISR_LO		0xe034
-#define TALITOS_CRCUISR			0xf030 /* cyclic redundancy check unit*/
-#define TALITOS_CRCUISR_LO		0xf034
+/* public key unit */
+#define TALITOS_PKEUISR			(TALITOS_PKEU + 0x30)
+#define TALITOS_PKEUISR_LO		(TALITOS_PKEU + 0x34)
+/* kasumi unit */
+#define TALITOS_KEUISR			(TALITOS_KEU + 0x30)
+#define TALITOS_KEUISR_LO		(TALITOS_KEU + 0x34)
+/* cyclic redundancy check unit */
+#define TALITOS_CRCUISR			(TALITOS_CRCU + 0x30)
+#define TALITOS_CRCUISR_LO		(TALITOS_CRCU + 0x34)
 
 #define TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256	0x28
 #define TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512		0x48
-- 
2.1.0
