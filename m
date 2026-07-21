Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D45B370AD1;
	Tue, 21 Jul 2026 13:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784641261; cv=none; b=E2e2N78dwj+mcLkqxupFSAM8+uvnXn4MRjZz57fzDaN1zFJ4LJDaSmCN8Xw8M99sYUa8O3kG8DQlvzhH9h9WLXLTUvr5DP4j5NwcVkb5dMR8PJrujtV9IE6Ptu9rFqUPTtiQeAfWYHgDn/vSVFDWBWTqKVqhCLEyksuCmSlalqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784641261; c=relaxed/simple;
	bh=CVdDSuYexNtNl6N+cqyzxUpW849YisOVb/g0EdpbuDc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B2tUA14DYmL5pjWdJK5Mo0YL09AjfEof+Tj1yy6RsPKvwV6OBzlW4aLO2GanCUmlM+upH6yBbHEbRA+9cG+lXFhobr+xDS6PVNQnb3BG95RgzS6k3YsrIKZbHCvSUkJsXhhylvR+Z5BM2wKQsLSXeAhdzNz0zgd7dxrOpiNZN0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=UbKYCoDa; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="UbKYCoDa"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 0A8C84E40EA1;
	Tue, 21 Jul 2026 13:40:56 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D53E760368;
	Tue, 21 Jul 2026 13:40:55 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 017C511BD2635;
	Tue, 21 Jul 2026 15:40:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784641254; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=dWY8dsRH+pL6ibWTKb6Vw9bchOZ0iZbpl5Sm2Mb8eyo=;
	b=UbKYCoDar5i0WVRrp0cZ2T7QppK5y6Yz4C4MCMTg2dsuiLRUTEm79o6hhC6DY5Rcgdbfgh
	BnC49a8MT9SPJAm42o07FgpGHCs5InxnM4ECrD21wMR2pEC7gV+OvT715cQN2W9uIlqNH8
	ZdMJuXIu5aRZJCVP+cmS0g107Enx7KENvI/QSsCVV5p/mVmxRhLxQ2s6OsgxMUGRyEaNV8
	8TpG4Icf0LYhb9SNt5FHMjqfjxMFcftk6Kt60xqVWcb6rl/yCVNxVFyoZRj3/Hzhvh+Gtw
	eCI3rCTybrFLQkHrL0TVKF/k/wVy7wDOJW8yliap1EmNk1i1solHsve2aGGcLw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:40:14 +0200
Subject: [PATCH v3 04/19] crypto: talitos/hwrng - Move into separate file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-4-6e94359bf72d@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-6e94359bf72d@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-6e94359bf72d@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784641243; l=6422;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=CVdDSuYexNtNl6N+cqyzxUpW849YisOVb/g0EdpbuDc=;
 b=x0NJn/yjkB+mRmScqWlWJZfyuq3VGelWDA23OEsKvZ355a6e3DB5WKrkNSWDjSS7OT38Uf/MJ
 OcqjD/8c/IjCd6WLR7QVFgBwaaRuQaDfEzWyrDUTuFrBsrFSJe8X0MI
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
index 753481d3189a..074f399b6327 100644
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
2.55.0

