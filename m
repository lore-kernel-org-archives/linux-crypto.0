Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA60D47728A;
	Mon,  7 Sep 2026 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787408; cv=none; b=FsXPiXx5Ys/JEvUPNBt8WCIzzG0+Wq4HPpUF+cfeqKIhKciDkn8h92WeuGfggW9YGDhs/4Qqyy1mc+hWce9EfWz5RA5fqEDBDcNXJOZ9QeD2mJzMvRKahpPbe2CbgWEPaG3gtSOM61rFbR5LXQsSzdmFYZO4mWwfWRfpBv4t7p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787408; c=relaxed/simple;
	bh=+V6TwRpRcAHbLUEqC/uBzK12Y4oi9gShliHqWlvH39M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=peD87I2NKHEaqQEmH2WGKl8tEvIcP7QCoqF9Uh5+F0E1zDTK289FpCUDPV4Vv0pwQwASxufKVbo5NvxZWs2FmFvfv0Olb1dnKlujMknY2NqSaWWrayfg9QjMh2P/er0EgFqTjT9p57BgVv9rF3u5FKrYXDTuCZNUfDE5XQ1XzSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=T0qqPMy7; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="T0qqPMy7"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 7147F4E41571;
	Mon,  7 Sep 2026 13:23:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 449BC60383;
	Mon,  7 Sep 2026 13:23:18 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id BD8A811C7AF1E;
	Mon,  7 Sep 2026 15:23:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788787397; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=HFlD0tNS//nXzuF5Pt6Q4nxt3TYbNI2OoApbDPsgJWk=;
	b=T0qqPMy7NcPAlhIfyKxsCCLRSaAOTRvAbyaFjfUpAQ3+7w3D6A7NRX/aKEd1spUslyrMur
	2j7lCy7HM0U1SJWJC2hTLTjKygJMTyzoVEMqPL7NGsnt98xKOKNYScCyrRxmQ+N/RQUvkt
	qOAsvOVTqCiouuLjiWQyL6pMjF5aWvXu6wnhpV+f/OsREfDIjNonnuCEjP44QUegdJ11ks
	Eg7qTeYt+WHO+QxJsq2INI3yJL0e4KuATd6J/IQ+QQoasEl2ysjrTNBK14yMrqZlARif5r
	llj12dGEpTRImmEJpDI9j+wo86XvyxhVSXzEf8ZJ17jAS2WUCM10JQ/PO9vmBw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Mon, 07 Sep 2026 15:22:38 +0200
Subject: [PATCH v5 04/19] crypto: talitos/hwrng - Move into separate file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-7-1-rc1_talitos_cleanup-v5-4-860f43cd7317@bootlin.com>
References: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
In-Reply-To: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788787387; l=6485;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=+V6TwRpRcAHbLUEqC/uBzK12Y4oi9gShliHqWlvH39M=;
 b=YRkx1vJJTIiuhUm4CwsCEqAre2OALuwwGaZQwPRAa3Lnx5HhIaexokbf9UkUDZ345GNRojHl9
 01Ddw7zTSPvDsGz09UYm3FAdrtiyrAnay5LBMzs35VYs0Pu07QOcctm
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Move the hardware random number generator implementation from
talitos.c into a dedicated talitos-rng.c file.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/Makefile      |  4 +-
 drivers/crypto/talitos/talitos-rng.c | 93 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos/talitos.c     | 83 --------------------------------
 drivers/crypto/talitos/talitos.h     |  5 ++
 4 files changed, 101 insertions(+), 84 deletions(-)

diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Makefile
index fcc5db5e63c2..329a2be494b6 100644
--- a/drivers/crypto/talitos/Makefile
+++ b/drivers/crypto/talitos/Makefile
@@ -1 +1,3 @@
-obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
+obj-$(CONFIG_CRYPTO_DEV_TALITOS) += crypto-talitos.o
+
+crypto-talitos-y := talitos.o talitos-rng.o
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
index 9f0928312102..b99092b5b59b 100644
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

