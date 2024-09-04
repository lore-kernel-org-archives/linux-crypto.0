Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4824A15
	for <linux-crypto@vger.kernel.org>; Wed,  4 Sep 2024 03:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419493; cv=none; b=EPrqMl7+wGkWATyXQopRY50NMtpea7916CpQMcBgMWsGqGz3xCbT/77v6KdVtpmcBxUPdkAZn3B8r/U9pB3ZNkag4hewTK4WahvfawmJTuA8lIUroH5n44QuI0ZJb3yGGvZ+Yw4h7MBzRjwrP1EpkGhdfew0hmiUxLQaMki7nY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419493; c=relaxed/simple;
	bh=2CtpusWGVRuc3l651OeDbMkEZxCahLnEaPDEq30MPwI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dIZ11pl8iiVLw0aPHRIIUhCSswA6ESMCorJKEBnYH5q4l3De/VdelK+4FBHVkAcr0Ba56TSO8QiWNh7nrKUmBFy7kj9WuSjaCFLJkiqL2v9DvcyBGN8DIR+av6+7ngOrLgPS7YmcH3k8JTSpr0ELvIyFh5yoEPbD0GhBWyR5Kwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=GeNJE2f6; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="GeNJE2f6"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7176645e4daso1727119b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2024 20:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725419491; x=1726024291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a0DBc/mb2osD/tAWrJoRG9yYkOefnL7xoRRjJr16TMo=;
        b=GeNJE2f6uK3aw/zo/Prw1O9erQuoluIC7/sotQEXeREq6a+6fNCubE8Iwami7UPkeE
         8yVtcyeEnRM+3aItA9uIAiA3B9rETBXT38KAnAgjZnwKJL5UyW7wTcu4Ny6mAK5GqWqq
         YiBxItmB0eCkSHkIQbfiGhCKwQ/m8tKDsZp0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725419491; x=1726024291;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a0DBc/mb2osD/tAWrJoRG9yYkOefnL7xoRRjJr16TMo=;
        b=KoXqq4HKDeRo28c5gNPzx3ckGphLxB1/QKQO1GXOFXwDT5KGq5Qd0LIk9TalSTh7cV
         jdoHWtbcq7KqgaJm3/T0yrpDMPU5aTon6d9VXX2F2oCuEfO6+YDfQOykjjPUV06U5zax
         DJw5Yvzs0JKSi7OobsWkMkUAYqZp5ZKOMDOn7Yp4967iLzPf8Gl4SaQOSDj9WYrNoddx
         n3FGvu2y5CNHYMQowRFHVSNYCnCItIUMSWgUyahJ75mHGsSN0F/a82DJLFr8RdJ2q32F
         LYp2ZhenLmaJypFCbXXN2e/0Pe1V7+KF56Yp0PWMjWkgiGiMbDPPGgRc9yjuHEtdVWWj
         +7Gg==
X-Forwarded-Encrypted: i=1; AJvYcCV5T4IWPIzNd9G5HfTn7vYnTKqwkV/g8RPsrs7eOI+IuD7eH5OJP1iZU8ffNj5Czfj0nRno2X2bb6ofNNs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+tzF5FOoV8h3mcWKZ+B8hK72NMXKG1DGMGHXovE/GleoxtCPX
	ZkdcKXeDIQoHhzfkhtecmGrNh+zJuSPrpflBnCyNXYMijwp12haL+dbpYo0PzDQ=
X-Google-Smtp-Source: AGHT+IHpZUDO0i+YZGPgDLuRkbwRDh7Lc4FrkXMKBTe2WfFYCyyss0tbUTIQkgTEYgNHMZRw+aTftg==
X-Received: by 2002:a05:6a00:887:b0:714:3cd0:a7b2 with SMTP id d2e1a72fcca58-7173fb7d6c6mr12805084b3a.28.1725419491347;
        Tue, 03 Sep 2024 20:11:31 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7177853340bsm590999b3a.82.2024.09.03.20.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 20:11:31 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	robh@kernel.org,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH 1/2] Device tree registration and property names changes
Date: Wed,  4 Sep 2024 08:41:21 +0530
Message-Id: <20240904031123.34144-1-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes Device tree registrations, DT property names and counter width
checks.

Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/dwc-spacc/Kconfig          |  2 +-
 drivers/crypto/dwc-spacc/spacc_core.c     |  4 +-
 drivers/crypto/dwc-spacc/spacc_device.c   | 64 ++++++++---------------
 drivers/crypto/dwc-spacc/spacc_device.h   |  3 +-
 drivers/crypto/dwc-spacc/spacc_skcipher.c | 29 +++++-----
 5 files changed, 40 insertions(+), 62 deletions(-)

diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
index 9eb41a295f9d..bc44c2a61fe7 100644
--- a/drivers/crypto/dwc-spacc/Kconfig
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -3,7 +3,7 @@
 config CRYPTO_DEV_SPACC
 	tristate "Support for dw_spacc Security protocol accelerators"
 	depends on HAS_DMA
-	default m
+	default n
 
 	help
 	  This enables support for the HASH/CRYP/AEAD hw accelerator which can be found
diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-spacc/spacc_core.c
index 1da7cdd93e78..d48e4b9a56af 100644
--- a/drivers/crypto/dwc-spacc/spacc_core.c
+++ b/drivers/crypto/dwc-spacc/spacc_core.c
@@ -1,9 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include <linux/of_device.h>
+#include <crypto/skcipher.h>
+#include <linux/of.h>
 #include <linux/vmalloc.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
 #include "spacc_hal.h"
 #include "spacc_core.h"
 
diff --git a/drivers/crypto/dwc-spacc/spacc_device.c b/drivers/crypto/dwc-spacc/spacc_device.c
index 964ccdf294e3..332703daffef 100644
--- a/drivers/crypto/dwc-spacc/spacc_device.c
+++ b/drivers/crypto/dwc-spacc/spacc_device.c
@@ -25,9 +25,14 @@ void spacc_stat_process(struct spacc_device *spacc)
 	tasklet_schedule(&priv->pop_jobs);
 }
 
+static const struct of_device_id snps_spacc_id[] = {
+	{.compatible = "snps,dwc-spacc" },
+	{ /*sentinel */        }
+};
+
+MODULE_DEVICE_TABLE(of, snps_spacc_id);
 
-int spacc_probe(struct platform_device *pdev,
-		const struct of_device_id snps_spacc_id[])
+int spacc_probe(struct platform_device *pdev)
 {
 	int spacc_idx = -1;
 	struct resource *mem;
@@ -37,29 +42,14 @@ int spacc_probe(struct platform_device *pdev,
 	int spacc_priority = -1;
 	struct spacc_priv *priv;
 	int x = 0, err, oldmode, irq_num;
-	const struct of_device_id *match, *id;
 	u64 oldtimer = 100000, timer = 100000;
 
-	if (pdev->dev.of_node) {
-		id = of_match_node(snps_spacc_id, pdev->dev.of_node);
-		if (!id) {
-			dev_err(&pdev->dev, "DT node did not match\n");
-			return -EINVAL;
-		}
-	}
-
 	/* Initialize DDT DMA pools based on this device's resources */
 	if (pdu_mem_init(&pdev->dev)) {
 		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
 		return -ENOMEM;
 	}
 
-	match = of_match_device(of_match_ptr(snps_spacc_id), &pdev->dev);
-	if (!match) {
-		dev_err(&pdev->dev, "SPAcc dtb missing");
-		return -ENODEV;
-	}
-
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem) {
 		dev_err(&pdev->dev, "no memory resource for spacc\n");
@@ -74,52 +64,52 @@ int spacc_probe(struct platform_device *pdev,
 	}
 
 	/* Read spacc priority and index and save inside priv.spacc.config */
-	if (of_property_read_u32(pdev->dev.of_node, "spacc_priority",
+	if (of_property_read_u32(pdev->dev.of_node, "spacc-priority",
 				 &spacc_priority)) {
-		dev_err(&pdev->dev, "No vspacc priority specified\n");
+		dev_err(&pdev->dev, "No virtual spacc priority specified\n");
 		err = -EINVAL;
 		goto free_ddt_mem_pool;
 	}
 
 	if (spacc_priority < 0 && spacc_priority > VSPACC_PRIORITY_MAX) {
-		dev_err(&pdev->dev, "Invalid vspacc priority\n");
+		dev_err(&pdev->dev, "Invalid virtual spacc priority\n");
 		err = -EINVAL;
 		goto free_ddt_mem_pool;
 	}
 	priv->spacc.config.priority = spacc_priority;
 
-	if (of_property_read_u32(pdev->dev.of_node, "spacc_index",
+	if (of_property_read_u32(pdev->dev.of_node, "spacc-index",
 				 &spacc_idx)) {
-		dev_err(&pdev->dev, "No vspacc index specified\n");
+		dev_err(&pdev->dev, "No virtual spacc index specified\n");
 		err = -EINVAL;
 		goto free_ddt_mem_pool;
 	}
 	priv->spacc.config.idx = spacc_idx;
 
-	if (of_property_read_u32(pdev->dev.of_node, "spacc_endian",
+	if (of_property_read_u32(pdev->dev.of_node, "spacc-endian",
 				 &spacc_endian)) {
-		dev_dbg(&pdev->dev, "No spacc_endian specified\n");
+		dev_dbg(&pdev->dev, "No spacc endian specified\n");
 		dev_dbg(&pdev->dev, "Default spacc Endianness (0==little)\n");
 		spacc_endian = 0;
 	}
 	priv->spacc.config.spacc_endian = spacc_endian;
 
-	if (of_property_read_u64(pdev->dev.of_node, "oldtimer",
+	if (of_property_read_u64(pdev->dev.of_node, "spacc-oldtimer",
 				 &oldtimer)) {
-		dev_dbg(&pdev->dev, "No oldtimer specified\n");
+		dev_dbg(&pdev->dev, "No spacc oldtimer specified\n");
 		dev_dbg(&pdev->dev, "Default oldtimer (100000)\n");
 		oldtimer = 100000;
 	}
 	priv->spacc.config.oldtimer = oldtimer;
 
-	if (of_property_read_u64(pdev->dev.of_node, "timer", &timer)) {
-		dev_dbg(&pdev->dev, "No timer specified\n");
+	if (of_property_read_u64(pdev->dev.of_node, "spacc-timer", &timer)) {
+		dev_dbg(&pdev->dev, "No spacc timer specified\n");
 		dev_dbg(&pdev->dev, "Default timer (100000)\n");
 		timer = 100000;
 	}
 	priv->spacc.config.timer = timer;
 
-	baseaddr = devm_ioremap_resource(&pdev->dev, mem);
+	baseaddr = devm_platform_get_and_ioremap_resource(pdev, 0, &mem);
 	if (IS_ERR(baseaddr)) {
 		dev_err(&pdev->dev, "unable to map iomem\n");
 		err = PTR_ERR(baseaddr);
@@ -127,12 +117,6 @@ int spacc_probe(struct platform_device *pdev,
 	}
 
 	pdu_get_version(baseaddr, &info);
-	if (pdev->dev.platform_data) {
-		struct pdu_info *parent_info = pdev->dev.platform_data;
-
-		memcpy(&info.pdu_config, &parent_info->pdu_config,
-		       sizeof(info.pdu_config));
-	}
 
 	dev_dbg(&pdev->dev, "EPN %04X : virt [%d]\n",
 				info.spacc_version.project,
@@ -273,18 +257,12 @@ static void spacc_unregister_algs(void)
 #endif
 }
 
-static const struct of_device_id snps_spacc_id[] = {
-	{.compatible = "snps-dwc-spacc" },
-	{ /*sentinel */        }
-};
-
-MODULE_DEVICE_TABLE(of, snps_spacc_id);
 
 static int spacc_crypto_probe(struct platform_device *pdev)
 {
 	int rc;
 
-	rc = spacc_probe(pdev, snps_spacc_id);
+	rc = spacc_probe(pdev);
 	if (rc < 0)
 		goto err;
 
@@ -326,7 +304,7 @@ static struct platform_driver spacc_driver = {
 	.remove = spacc_crypto_remove,
 	.driver = {
 		.name  = "spacc",
-		.of_match_table = of_match_ptr(snps_spacc_id),
+		.of_match_table = snps_spacc_id,
 		.owner = THIS_MODULE,
 	},
 };
diff --git a/drivers/crypto/dwc-spacc/spacc_device.h b/drivers/crypto/dwc-spacc/spacc_device.h
index be7fde25046b..e6a34dc20eba 100644
--- a/drivers/crypto/dwc-spacc/spacc_device.h
+++ b/drivers/crypto/dwc-spacc/spacc_device.h
@@ -224,8 +224,7 @@ int spacc_unregister_aead_algs(void);
 int probe_ciphers(struct platform_device *spacc_pdev);
 int spacc_unregister_cipher_algs(void);
 
-int spacc_probe(struct platform_device *pdev,
-		const struct of_device_id snps_spacc_id[]);
+int spacc_probe(struct platform_device *pdev);
 
 irqreturn_t spacc_irq_handler(int irq, void *dev);
 #endif
diff --git a/drivers/crypto/dwc-spacc/spacc_skcipher.c b/drivers/crypto/dwc-spacc/spacc_skcipher.c
index 1ef7c665188f..8410ad9d9910 100644
--- a/drivers/crypto/dwc-spacc/spacc_skcipher.c
+++ b/drivers/crypto/dwc-spacc/spacc_skcipher.c
@@ -401,41 +401,40 @@ static int spacc_cipher_process(struct skcipher_request *req, int enc_dec)
 			return ret;
 		}
 	}
-
 	if (salg->mode->id == CRYPTO_MODE_AES_CTR ||
 	    salg->mode->id == CRYPTO_MODE_SM4_CTR) {
 		/* copy the IV to local buffer */
 		for (i = 0; i < 16; i++)
 			ivc1[i] = req->iv[i];
 
-		/* 64-bit counter width */
-		if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3) & (0x3)) {
+		/* 32-bit counter width */
+		if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3) & (0x2)) {
 
-			for (i = 8; i < 16; i++) {
-				num_iv64 <<= 8;
-				num_iv64 |= ivc1[i];
+			for (i = 12; i < 16; i++) {
+				num_iv <<= 8;
+				num_iv |= ivc1[i];
 			}
 
-			diff64 = SPACC_CTR_IV_MAX64 - num_iv64;
+			diff = SPACC_CTR_IV_MAX32 - num_iv;
 
-			if (len > diff64) {
+			if (len > diff) {
 				name = salg->calg->cra_name;
 				ret = spacc_skcipher_fallback(name,
 							      req, enc_dec);
 				return ret;
 			}
-		/* 32-bit counter width */
+		/* 64-bit counter width */
 		} else if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
-			& (0x2)) {
+			& (0x3)) {
 
-			for (i = 12; i < 16; i++) {
-				num_iv <<= 8;
-				num_iv |= ivc1[i];
+			for (i = 8; i < 16; i++) {
+				num_iv64 <<= 8;
+				num_iv64 |= ivc1[i];
 			}
 
-			diff = SPACC_CTR_IV_MAX32 - num_iv;
+			diff64 = SPACC_CTR_IV_MAX64 - num_iv64;
 
-			if (len > diff) {
+			if (len > diff64) {
 				name = salg->calg->cra_name;
 				ret = spacc_skcipher_fallback(name,
 							      req, enc_dec);

base-commit: 3c44d31cb34ce4eb8311a2e73634d57702948230
-- 
2.25.1

