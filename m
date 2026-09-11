Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B376E36A37E;
	Fri, 11 Sep 2026 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138044; cv=none; b=AXPnSRrl5c5OH6dMmTQDvUnO1mfxYjAxj2U98STctuaw+wbj4Bp6/66JooG63Kk0bnsBtIwqwcYw0HeGvpBJ6AgUEddb7TCDk3yCCzKAyG7DY5GMokmFYuplo9o3m+xIurUi1AXysH4Tsspj+Z8cqMWf+Hfh/FBlwzVjn8yYejA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138044; c=relaxed/simple;
	bh=tFnkxpoCEKryP/sZROFuw+j/Nx4Z7+waFd17JbSvDks=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IZyx5hL9Y4KLwA1gRvbEfASQeKD4YbRSMyr/YtoxjprpYTDpAf/joGFaEL25iahETLn/6lL1GRzYLkq6PyLItoHeTL7aU45jVXZJWy5EJP7k1cMPPPef0hbzzGk0vPzYR7e1H9GWCgWeDzcd4GrTrO9EC3jw/e7H1naPP97KDVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=vmRwCCGp; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="vmRwCCGp"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 8D7964E4022B;
	Fri, 11 Sep 2026 14:47:20 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 62F99601DE;
	Fri, 11 Sep 2026 14:47:20 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2977A11C7AFA5;
	Fri, 11 Sep 2026 16:47:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138039; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Mc8IwUqzl+oMwIheaxL+SGMZDnDCMg+GAkmTwP30VJs=;
	b=vmRwCCGp/zM+0FfEFyKfrBMQZyZb/eEMyL+42lRj7Sm4kXNFBsdo48F7nvDWz3VG/Rzh2r
	/W9ZU48l1S8nMnk7pWy3eMjWfa0c1Kf6bql2eIW0kbL9P+ov0ZOTFopELS9gc9udXVv+yn
	pUFzYODSLYxK+lsQmbg034IVpNLLbppHA1zGRQREYhVuRwvisRlg23vmATyPik/wGCNG9q
	/O/XQ7OH7syDzfuDIe79/DlTkro20NLyl2uUEFT+UqU6Anmyt1gm9nQQ1ZcTGGlahm26cG
	i/ezyJ87KxPW8H2HNPfo+SKtlIjiuCykWysl7pwmH83Hkbk4sHsxmgxbmJzBiw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:21 +0200
Subject: [PATCH v6 04/19] crypto: talitos/hwrng - Move into separate file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-4-4215f347c97a@bootlin.com>
References: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
In-Reply-To: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=6485;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=tFnkxpoCEKryP/sZROFuw+j/Nx4Z7+waFd17JbSvDks=;
 b=k+4vQFYpYXMIYCzCc5912fp56uv6+vclxBAfSzbABlzo5f4geoiMzTULDOhaWBvYqoiQWYTGJ
 uFGPXJxwQ+nA6zqHS+G1nABxNJDaK4v91P+3gn3Rf/fwjb0uooyL6Le
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
index c2265afbdea2..366a626a9370 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -822,89 +822,6 @@ DEF_TALITOS2_INTERRUPT(ch0_2, TALITOS2_ISR_CH_0_2_DONE, TALITOS2_ISR_CH_0_2_ERR,
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

