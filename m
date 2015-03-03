From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 12/17] crypto: talitos - base address for Execution Units
Date: Tue, 3 Mar 2015 02:13:26 +0100
Message-ID: <20150417142406.1D1341A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:41734 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933258AbbDQOYI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 10:24:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SEC 1.0, 1.2 and 2.x+ have different EU base addresses, so we need to
define pointers for each EU in the driver private data structure.
The proper address is set by the probe function depending on the
SEC type, in order to provide access to the proper address.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 83 ++++++++++++++++++++++++++++++++----------------
 drivers/crypto/talitos.h | 72 +++++++++++++++++++++++++----------------
 2 files changed, 100 insertions(+), 55 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index e6ea651..6d77699 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -208,7 +208,7 @@ static int init_device(struct device *dev)
 
 	/* disable integrity check error interrupts (use writeback instead) */
 	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
-		setbits32(priv->reg + TALITOS_MDEUICR_LO,
+		setbits32(priv->reg_mdeu + TALITOS_EUICR_LO,
 		          TALITOS_MDEUICR_LO_ICE);
 
 	return 0;
@@ -424,44 +424,44 @@ static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
 	switch (desc_hdr & DESC_HDR_SEL0_MASK) {
 	case DESC_HDR_SEL0_AFEU:
 		dev_err(dev, "AFEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_AFEUISR),
-			in_be32(priv->reg + TALITOS_AFEUISR_LO));
+			in_be32(priv->reg_afeu + TALITOS_EUISR),
+			in_be32(priv->reg_afeu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_DEU:
 		dev_err(dev, "DEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_DEUISR),
-			in_be32(priv->reg + TALITOS_DEUISR_LO));
+			in_be32(priv->reg_deu + TALITOS_EUISR),
+			in_be32(priv->reg_deu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_MDEUA:
 	case DESC_HDR_SEL0_MDEUB:
 		dev_err(dev, "MDEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_MDEUISR),
-			in_be32(priv->reg + TALITOS_MDEUISR_LO));
+			in_be32(priv->reg_mdeu + TALITOS_EUISR),
+			in_be32(priv->reg_mdeu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_RNG:
 		dev_err(dev, "RNGUISR 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_RNGUISR),
-			in_be32(priv->reg + TALITOS_RNGUISR_LO));
+			in_be32(priv->reg_rngu + TALITOS_ISR),
+			in_be32(priv->reg_rngu + TALITOS_ISR_LO));
 		break;
 	case DESC_HDR_SEL0_PKEU:
 		dev_err(dev, "PKEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_PKEUISR),
-			in_be32(priv->reg + TALITOS_PKEUISR_LO));
+			in_be32(priv->reg_pkeu + TALITOS_EUISR),
+			in_be32(priv->reg_pkeu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_AESU:
 		dev_err(dev, "AESUISR 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_AESUISR),
-			in_be32(priv->reg + TALITOS_AESUISR_LO));
+			in_be32(priv->reg_aesu + TALITOS_EUISR),
+			in_be32(priv->reg_aesu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_CRCU:
 		dev_err(dev, "CRCUISR 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_CRCUISR),
-			in_be32(priv->reg + TALITOS_CRCUISR_LO));
+			in_be32(priv->reg_crcu + TALITOS_EUISR),
+			in_be32(priv->reg_crcu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_KEU:
 		dev_err(dev, "KEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_KEUISR),
-			in_be32(priv->reg + TALITOS_KEUISR_LO));
+			in_be32(priv->reg_pkeu + TALITOS_EUISR),
+			in_be32(priv->reg_pkeu + TALITOS_EUISR_LO));
 		break;
 	}
 
@@ -469,13 +469,13 @@ static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
 	case DESC_HDR_SEL1_MDEUA:
 	case DESC_HDR_SEL1_MDEUB:
 		dev_err(dev, "MDEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_MDEUISR),
-			in_be32(priv->reg + TALITOS_MDEUISR_LO));
+			in_be32(priv->reg_mdeu + TALITOS_EUISR),
+			in_be32(priv->reg_mdeu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL1_CRCU:
 		dev_err(dev, "CRCUISR 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_CRCUISR),
-			in_be32(priv->reg + TALITOS_CRCUISR_LO));
+			in_be32(priv->reg_crcu + TALITOS_EUISR),
+			in_be32(priv->reg_crcu + TALITOS_EUISR_LO));
 		break;
 	}
 
@@ -614,7 +614,7 @@ static int talitos_rng_data_present(struct hwrng *rng, int wait)
 	int i;
 
 	for (i = 0; i < 20; i++) {
-		ofl = in_be32(priv->reg + TALITOS_RNGUSR_LO) &
+		ofl = in_be32(priv->reg_rngu + TALITOS_EUSR_LO) &
 		      TALITOS_RNGUSR_LO_OFL;
 		if (ofl || !wait)
 			break;
@@ -630,8 +630,8 @@ static int talitos_rng_data_read(struct hwrng *rng, u32 *data)
 	struct talitos_private *priv = dev_get_drvdata(dev);
 
 	/* rng fifo requires 64-bit accesses */
-	*data = in_be32(priv->reg + TALITOS_RNGU_FIFO);
-	*data = in_be32(priv->reg + TALITOS_RNGU_FIFO_LO);
+	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO);
+	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO_LO);
 
 	return sizeof(u32);
 }
@@ -642,8 +642,9 @@ static int talitos_rng_init(struct hwrng *rng)
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
 
-	setbits32(priv->reg + TALITOS_RNGURCR_LO, TALITOS_RNGURCR_LO_SR);
-	while (!(in_be32(priv->reg + TALITOS_RNGUSR_LO) & TALITOS_RNGUSR_LO_RD)
+	setbits32(priv->reg_rngu + TALITOS_EURCR_LO, TALITOS_RNGURCR_LO_SR);
+	while (!(in_be32(priv->reg_rngu + TALITOS_EUSR_LO)
+		 & TALITOS_RNGUSR_LO_RD)
 	       && --timeout)
 		cpu_relax();
 	if (timeout == 0) {
@@ -652,7 +653,7 @@ static int talitos_rng_init(struct hwrng *rng)
 	}
 
 	/* start generating */
-	setbits32(priv->reg + TALITOS_RNGUDSR_LO, 0);
+	setbits32(priv->reg_rngu + TALITOS_EUDSR_LO, 0);
 
 	return 0;
 }
@@ -2687,6 +2688,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct talitos_private *priv;
 	const unsigned int *prop;
 	int i, err;
+	int stride;
 
 	priv = kzalloc(sizeof(struct talitos_private), GFP_KERNEL);
 	if (!priv)
@@ -2756,6 +2758,31 @@ static int talitos_probe(struct platform_device *ofdev)
 	if (of_device_is_compatible(np, "fsl,sec1.0"))
 		priv->features |= TALITOS_FTR_SEC1;
 
+	if (of_device_is_compatible(np, "fsl,sec1.2")) {
+		priv->reg_deu = priv->reg + TALITOS12_DEU;
+		priv->reg_aesu = priv->reg + TALITOS12_AESU;
+		priv->reg_mdeu = priv->reg + TALITOS12_MDEU;
+		stride = TALITOS1_CH_STRIDE;
+	} else if (of_device_is_compatible(np, "fsl,sec1.0")) {
+		priv->reg_deu = priv->reg + TALITOS10_DEU;
+		priv->reg_aesu = priv->reg + TALITOS10_AESU;
+		priv->reg_mdeu = priv->reg + TALITOS10_MDEU;
+		priv->reg_afeu = priv->reg + TALITOS10_AFEU;
+		priv->reg_rngu = priv->reg + TALITOS10_RNGU;
+		priv->reg_pkeu = priv->reg + TALITOS10_PKEU;
+		stride = TALITOS1_CH_STRIDE;
+	} else {
+		priv->reg_deu = priv->reg + TALITOS2_DEU;
+		priv->reg_aesu = priv->reg + TALITOS2_AESU;
+		priv->reg_mdeu = priv->reg + TALITOS2_MDEU;
+		priv->reg_afeu = priv->reg + TALITOS2_AFEU;
+		priv->reg_rngu = priv->reg + TALITOS2_RNGU;
+		priv->reg_pkeu = priv->reg + TALITOS2_PKEU;
+		priv->reg_keu = priv->reg + TALITOS2_KEU;
+		priv->reg_crcu = priv->reg + TALITOS2_CRCU;
+		stride = TALITOS2_CH_STRIDE;
+	}
+
 	priv->chan = kzalloc(sizeof(struct talitos_channel) *
 			     priv->num_channels, GFP_KERNEL);
 	if (!priv->chan) {
@@ -2767,7 +2794,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
 
 	for (i = 0; i < priv->num_channels; i++) {
-		priv->chan[i].reg = priv->reg + TALITOS_CH_STRIDE * (i + 1);
+		priv->chan[i].reg = priv->reg + stride * (i + 1);
 		if (!priv->irq[1] || !(i & 1))
 			priv->chan[i].reg += TALITOS_CH_BASE_OFFSET;
 
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index f827c04..4faa3b6 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -111,6 +111,14 @@ struct talitos_private {
 	struct device *dev;
 	struct platform_device *ofdev;
 	void __iomem *reg;
+	void __iomem *reg_deu;
+	void __iomem *reg_aesu;
+	void __iomem *reg_mdeu;
+	void __iomem *reg_afeu;
+	void __iomem *reg_rngu;
+	void __iomem *reg_pkeu;
+	void __iomem *reg_keu;
+	void __iomem *reg_crcu;
 	int irq[2];
 
 	/* SEC global registers lock  */
@@ -206,7 +214,8 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 
 /* channel register address stride */
 #define TALITOS_CH_BASE_OFFSET		0x1000	/* default channel map base */
-#define TALITOS_CH_STRIDE		0x100
+#define TALITOS1_CH_STRIDE		0x1000
+#define TALITOS2_CH_STRIDE		0x100
 
 /* channel configuration register  */
 #define TALITOS_CCCR			0x8
@@ -255,37 +264,46 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 #define TALITOS_SCATTER			0xe0
 #define TALITOS_SCATTER_LO		0xe4
 
+/* execution unit registers base */
+#define TALITOS2_DEU			0x2000
+#define TALITOS2_AESU			0x4000
+#define TALITOS2_MDEU			0x6000
+#define TALITOS2_AFEU			0x8000
+#define TALITOS2_RNGU			0xa000
+#define TALITOS2_PKEU			0xc000
+#define TALITOS2_KEU			0xe000
+#define TALITOS2_CRCU			0xf000
+
+#define TALITOS12_AESU			0x4000
+#define TALITOS12_DEU			0x5000
+#define TALITOS12_MDEU			0x6000
+
+#define TALITOS10_AFEU			0x8000
+#define TALITOS10_DEU			0xa000
+#define TALITOS10_MDEU			0xc000
+#define TALITOS10_RNGU			0xe000
+#define TALITOS10_PKEU			0x10000
+#define TALITOS10_AESU			0x12000
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
+#define TALITOS_EUDSR			0x10	/* data size */
+#define TALITOS_EUDSR_LO		0x14
+#define TALITOS_EURCR			0x18 /* reset control*/
+#define TALITOS_EURCR_LO		0x1c
+#define TALITOS_EUSR			0x28 /* rng status */
+#define TALITOS_EUSR_LO			0x2c
+#define TALITOS_EUISR			0x30
+#define TALITOS_EUISR_LO		0x34
+#define TALITOS_EUICR			0x38 /* int. control */
+#define TALITOS_EUICR_LO		0x3c
+#define TALITOS_EU_FIFO			0x800 /* output FIFO */
+#define TALITOS_EU_FIFO_LO		0x804 /* output FIFO */
+/* message digest unit */
 #define   TALITOS_MDEUICR_LO_ICE	0x4000 /* integrity check IRQ enable */
-#define TALITOS_AFEUISR			0x8030 /* arc4 unit */
-#define TALITOS_AFEUISR_LO		0x8034
-#define TALITOS_RNGUISR			0xa030 /* random number unit */
-#define TALITOS_RNGUISR_LO		0xa034
-#define TALITOS_RNGUSR			0xa028 /* rng status */
-#define TALITOS_RNGUSR_LO		0xa02c
+/* random number unit */
 #define   TALITOS_RNGUSR_LO_RD		0x1	/* reset done */
 #define   TALITOS_RNGUSR_LO_OFL		0xff0000/* output FIFO length */
-#define TALITOS_RNGUDSR			0xa010	/* data size */
-#define TALITOS_RNGUDSR_LO		0xa014
-#define TALITOS_RNGU_FIFO		0xa800	/* output FIFO */
-#define TALITOS_RNGU_FIFO_LO		0xa804	/* output FIFO */
-#define TALITOS_RNGURCR			0xa018	/* reset control */
-#define TALITOS_RNGURCR_LO		0xa01c
 #define   TALITOS_RNGURCR_LO_SR		0x1	/* software reset */
-#define TALITOS_PKEUISR			0xc030 /* public key unit */
-#define TALITOS_PKEUISR_LO		0xc034
-#define TALITOS_KEUISR			0xe030 /* kasumi unit */
-#define TALITOS_KEUISR_LO		0xe034
-#define TALITOS_CRCUISR			0xf030 /* cyclic redundancy check unit*/
-#define TALITOS_CRCUISR_LO		0xf034
 
 #define TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256	0x28
 #define TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512		0x48
-- 
2.1.0
