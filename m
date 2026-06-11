Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E35368D55
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 07:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163410; cv=none; b=g6G++uSQOtq4uWd6jYy6H7YkyEtbcb80JMQTEaWQ6pQ4JkH9lZW3u8U0gxEgp1FpQ41/tDrd/sqSS6CDJ+UGI2WphnFDFUPgTtfRtXgNPVNzxrA07l/49qPDnmI56swJKJGagb3Watrj32/8Rvgm09h4/S1mDApWmcS+3V8vQC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163410; c=relaxed/simple;
	bh=BCN6MV+8/bGx7MGi3DzsHUCdtd8VLhO3Q87Sel4kqXE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dU0xj3l88xLFBn1DJtxsRsCCdOhYIfnh19yO69hJnJsO595cmhNpxkIpS7swy43MdW+QhC4TEyG/F5jTUUY8x7G7x7S4Sv0GztGPqmc9jzlawZw48ffc747t8RXNBXtzpXLJ2/d2XYFD43bS80ezpddwYNL30KQU1nC6CZfsOu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=c6Rxg1qI; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="c6Rxg1qI"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id D67EEC49F67;
	Thu, 11 Jun 2026 07:36:49 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 99AEA5FF03;
	Thu, 11 Jun 2026 07:36:47 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5A2C0106B9E4C;
	Thu, 11 Jun 2026 09:36:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1781163406; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=dBgDVCr/Xzh8SxwleXolfkhy78P9RPRFewQH2kwTF74=;
	b=c6Rxg1qIt0O308UGifCWsyn1paUt3VX2hA5JB+1lKlKN9us4AodfTiu0p5Jarcnjvl45As
	GuW3Y+MmMaRaA4um5tkxJ+9fifsOoKXfqpEcszDpFIl1Jd+mL6ajcKfOvAnLFotuv15Flf
	hjbgkYYumD4qgAoBj6WUtIiSnaC7qEHsQFUYpfObf4lA7Q2l3F1WCwRw5h/5DAOoABCUDo
	EQgqNbecQkzmBgUJnYJPA3zyDxH3FbJQHv0rmZD+58b0DjYO7JDedrs0UIh8uTzBGIXO03
	GYLDNmdK9yvogBGCdUiaK49q74rfEZakxVA4F+lWM6SgJidQws+4b+yiUYjRAA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 11 Jun 2026 09:35:58 +0200
Subject: [PATCH v2 04/19] crypto: talitos/hwrng - Move into separate file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-7-1-rc1_talitos_cleanup-v2-4-aa4a813ce69b@bootlin.com>
References: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
In-Reply-To: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781163398; l=6422;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=BCN6MV+8/bGx7MGi3DzsHUCdtd8VLhO3Q87Sel4kqXE=;
 b=TROqO5NnvW6JidqfKL6gjLA9mn+D3FOCnGTQrL2oA7Tu+TcrPdfT2Eb/IkmfUHz8945j2YjU0
 bs8Nlshhu0sBoCU04cyfb9J9/aANnBUKpcXTB4WGOg4utKMpwW/OFNp
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Move the hardware random number generator implementation from
talitos.c into a dedicated talitos-rng.c file.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/Makefile      |  2 +
 drivers/crypto/talitos/talitos-rng.c | 93 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos/talitos.c     | 83 --------------------------------
 drivers/crypto/talitos/talitos.h     |  5 ++
 4 files changed, 100 insertions(+), 83 deletions(-)

diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Makefile
index fcc5db5e63c2..901ec681f010 100644
--- a/drivers/crypto/talitos/Makefile
+++ b/drivers/crypto/talitos/Makefile
@@ -1 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
+
+talitos-y := talitos.o talitos-rng.o
diff --git a/drivers/crypto/talitos/talitos-rng.c b/drivers/crypto/talitos/talitos-rng.c
new file mode 100644
index 000000000000..3aa00de33b25
--- /dev/null
+++ b/drivers/crypto/talitos/talitos-rng.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+/*
+ * Freescale SEC (talitos) device hardware random number generator implementation
+ *
+ * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+
+#include "talitos.h"
+
+static int talitos_rng_data_present(struct hwrng *rng, int wait)
+{
+	struct device *dev = (struct device *)rng->priv;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	u32 ofl;
+	int i;
+
+	for (i = 0; i < 20; i++) {
+		ofl = in_be32(priv->reg_rngu + TALITOS_EUSR_LO) &
+		      TALITOS_RNGUSR_LO_OFL;
+		if (ofl || !wait)
+			break;
+		udelay(10);
+	}
+
+	return !!ofl;
+}
+
+static int talitos_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	struct device *dev = (struct device *)rng->priv;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+
+	/* rng fifo requires 64-bit accesses */
+	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO);
+	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO_LO);
+
+	return sizeof(u32);
+}
+
+static int talitos_rng_init(struct hwrng *rng)
+{
+	struct device *dev = (struct device *)rng->priv;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned int timeout = TALITOS_TIMEOUT;
+
+	setbits32(priv->reg_rngu + TALITOS_EURCR_LO, TALITOS_RNGURCR_LO_SR);
+	while (!(in_be32(priv->reg_rngu + TALITOS_EUSR_LO)
+		 & TALITOS_RNGUSR_LO_RD)
+	       && --timeout)
+		cpu_relax();
+	if (timeout == 0) {
+		dev_err(dev, "failed to reset rng hw\n");
+		return -ENODEV;
+	}
+
+	/* start generating */
+	setbits32(priv->reg_rngu + TALITOS_EUDSR_LO, 0);
+
+	return 0;
+}
+
+int talitos_register_rng(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	int err;
+
+	priv->rng.name		= dev_driver_string(dev);
+	priv->rng.init		= talitos_rng_init;
+	priv->rng.data_present	= talitos_rng_data_present;
+	priv->rng.data_read	= talitos_rng_data_read;
+	priv->rng.priv		= (unsigned long)dev;
+
+	err = hwrng_register(&priv->rng);
+	if (!err)
+		priv->rng_registered = true;
+
+	return err;
+}
+
+void talitos_unregister_rng(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+
+	if (!priv->rng_registered)
+		return;
+
+	hwrng_unregister(&priv->rng);
+	priv->rng_registered = false;
+}
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 58663edd4ad4..e28c60d17bb5 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -820,89 +820,6 @@ DEF_TALITOS2_INTERRUPT(ch0_2, TALITOS2_ISR_CH_0_2_DONE, TALITOS2_ISR_CH_0_2_ERR,
 DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_DONE, TALITOS2_ISR_CH_1_3_ERR,
 		       1)
 
-/*
- * hwrng
- */
-static int talitos_rng_data_present(struct hwrng *rng, int wait)
-{
-	struct device *dev = (struct device *)rng->priv;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	u32 ofl;
-	int i;
-
-	for (i = 0; i < 20; i++) {
-		ofl = in_be32(priv->reg_rngu + TALITOS_EUSR_LO) &
-		      TALITOS_RNGUSR_LO_OFL;
-		if (ofl || !wait)
-			break;
-		udelay(10);
-	}
-
-	return !!ofl;
-}
-
-static int talitos_rng_data_read(struct hwrng *rng, u32 *data)
-{
-	struct device *dev = (struct device *)rng->priv;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-
-	/* rng fifo requires 64-bit accesses */
-	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO);
-	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO_LO);
-
-	return sizeof(u32);
-}
-
-static int talitos_rng_init(struct hwrng *rng)
-{
-	struct device *dev = (struct device *)rng->priv;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	unsigned int timeout = TALITOS_TIMEOUT;
-
-	setbits32(priv->reg_rngu + TALITOS_EURCR_LO, TALITOS_RNGURCR_LO_SR);
-	while (!(in_be32(priv->reg_rngu + TALITOS_EUSR_LO)
-		 & TALITOS_RNGUSR_LO_RD)
-	       && --timeout)
-		cpu_relax();
-	if (timeout == 0) {
-		dev_err(dev, "failed to reset rng hw\n");
-		return -ENODEV;
-	}
-
-	/* start generating */
-	setbits32(priv->reg_rngu + TALITOS_EUDSR_LO, 0);
-
-	return 0;
-}
-
-static int talitos_register_rng(struct device *dev)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	int err;
-
-	priv->rng.name		= dev_driver_string(dev);
-	priv->rng.init		= talitos_rng_init;
-	priv->rng.data_present	= talitos_rng_data_present;
-	priv->rng.data_read	= talitos_rng_data_read;
-	priv->rng.priv		= (unsigned long)dev;
-
-	err = hwrng_register(&priv->rng);
-	if (!err)
-		priv->rng_registered = true;
-
-	return err;
-}
-
-static void talitos_unregister_rng(struct device *dev)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-
-	if (!priv->rng_registered)
-		return;
-
-	hwrng_unregister(&priv->rng);
-	priv->rng_registered = false;
-}
 
 /*
  * crypto alg
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 56e36a65ddcc..fa8c71b1f90f 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -431,3 +431,8 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 #define DESC_PTR_LNKTBL_JUMP			0x80
 #define DESC_PTR_LNKTBL_RET			0x02
 #define DESC_PTR_LNKTBL_NEXT			0x01
+
+/* Hardware RNG */
+
+int talitos_register_rng(struct device *dev);
+void talitos_unregister_rng(struct device *dev);

-- 
2.54.0

