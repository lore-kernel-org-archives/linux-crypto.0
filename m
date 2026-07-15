Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38630353A96
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 22:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784152818; cv=none; b=CToGXev1qjrR3bZF79xh56vgQEAPwD0c0f2RnIlTfZCP1Oif12OT8PBITvEMWFoXdUBsi3P/OZh1zzS4lg+/wNKsyqChqVDPMdA/VDjcct2oXOsU608bnHTkU/E6taq2UdlRaBgCUVFPGkNX6EglWW4PCA3ZKeGCKQj1ft7UJI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784152818; c=relaxed/simple;
	bh=UU4dpsTC0PZRGa0CHmrIwL30KhYMbi6CTz9EKPkSgHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RhjxVE72reESf5a6/6zM366mBUYL2ar0l2p3sMeHCp4dbRrKuNrYBg5Y4BIcujcRs1AJN2mraQzM1/yojViSxmlkh74MHOnG7q1lbBspVfMwrS8ve+The7Dnu5/AVLIutWBFw8QOQ0/uYb9Q3xXFBlXhkbA491i8YxsHWiw+wF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MwMm4hTR; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MwMm4hTR"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84874b52eabso3509765b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 15:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784152816; x=1784757616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zc6KeHedMYl+AfkLIxoYn3n3735fNfywh4JzrN7WoQc=;
        b=MwMm4hTRnnZ+kA9T23ug3Wkcyug9e1nvyZiVhlMKC0lcnlGTvGhmtm0NGrAssinJhZ
         ZZwCT5mxJKzE4SNjdKy3iWxWvljt3qvbkNXOPZ9DROibWt3O5OxK0XlAc7oaJN9ZsjEF
         aLoaoDb4jTRm7YGk+48OvU6YF8Jd5ou9Nafnr7674zcM+76iNtQN1duPnxc6UldE+F83
         S/pg0KQqdH5FrV7gT5Jpc3RlRr1Af8K+0oKWOK1spvId3vNMnzLZ01mfOpAbeO/7ZwP9
         Im6WIcKzimuh2iOFrNFudCmv+SGEO+f28y2/WdLj3TE18vnp48w6xj2RCqpYYBvpFdZ5
         b8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784152816; x=1784757616;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zc6KeHedMYl+AfkLIxoYn3n3735fNfywh4JzrN7WoQc=;
        b=htKXssk1XNFA5hLHlEPqOzaIKFgPEN8QshsHjEMAKmpI9xvuDsiGCiCU3vJCjyiE1W
         8AEFTvBB7bTet1dgcMyBsec9JoKfNpLMpo45ZyIR57UOwNnrsxsTd4sS5WjFMdkbffLx
         VWCALsj4ic9siAV/ir6/DFXPvqhT1vhBlAR2xaQ/8/E2JNBFxn7Sj7GV37yuDibRgoAg
         AWby6gmXt/adN/QiHjfmG3V3QcL90qL2IghKblqhtXeem4lCiV6RGIzMwpJnV7I7zCMp
         qYq1oKfBUSkVv1VzQUKzx6KvewiqnqmbNR9XC0A5yQG6yUD44htPXnWjYZWaD6KrMsbf
         Qs5g==
X-Gm-Message-State: AOJu0YzBo44RAtJ9Fu28DJMKNZRnGuRqFWtjURC/riyFZwoc419u6aPK
	BAZJd08jeGzbnPZGW8z2mbd1MfVEx+pyoCHc/uLRNzB24cZ00NkQ0EojXDVo0w==
X-Gm-Gg: AfdE7cnQfP/HTxgY8HCQVb7lW1o9IS73S7OHxaW9bUzBR8qg0MJP66PjQEneXhRtetk
	JoLMbZkkIHUxhAk3jFlg4CE7/Ri1beLUhiE5pfax12BzlDR4hPF+3IUDggv4hs75sVYyEZrzl3d
	12iJGcDr81FPObINPUp8Vr3Oqzpl+1cZ3PZBsuJAV0yvtdW6PUgpCKlVCsMScgbbrLDZDjmdsov
	bdw5RpnfGJRne8mpkXvvRgRjwqShoJsRq8YzSSfTxHVINSLRBZF3pYrESpNXYgHyF9TxFDJ3Aon
	vNPYARSlFucFbjGt5V79mWCCucv7od0vwrWbxvOZ0VVzo8VATGFEc9oJ8xYlrmhs/9iCrwOEA8Y
	uXDVLXV5ZuaU4lvJcCtC0bz1B/IrjlgGe+uFgyrz7PBR3Mtrso5zlqE68XQwqX+gNB+E2rHezMb
	FHugGSdUCdDdLcIUvl7Ggz9MxlJc9zSk/TTJ19zOLtR2is/vf7HgBrR4DhQnl8U/rgODa+uFqbr
	DtJiKkvJzbgTNfB+ubqdlFSfeIFU1Lit54GHas6ruMNCBFA7PlqwII=
X-Received: by 2002:a05:6a00:4298:b0:845:c5d5:3745 with SMTP id d2e1a72fcca58-8488967051fmr18193223b3a.34.1784152816331;
        Wed, 15 Jul 2026 15:00:16 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f241d60sm3993953b3a.11.2026.07.15.15.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 15:00:14 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: omap-sham: use devm_platform_get_and_ioremap_resource
Date: Wed, 15 Jul 2026 15:00:13 -0700
Message-ID: <20260715220013.416122-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the open-coded omap_sham_get_res_of()/omap_sham_get_res_pdev()
helpers and the #ifdef CONFIG_OF machinery with the managed
devm_platform_get_and_ioremap_resource(), platform_get_irq() and
device_get_match_data() helpers. The omap_sham_pdata_omap2 fallback is
kept for the non-DT (legacy platform_device) case. This removes the
manual resource copy and ioremap, simplifying probe.

Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/omap-sham.c | 104 +++++++------------------------------
 1 file changed, 18 insertions(+), 86 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index be1ac640ee59..e8e111bd438a 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -30,8 +30,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
@@ -1896,79 +1894,8 @@ static const struct of_device_id omap_sham_of_match[] = {
 	{},
 };
 MODULE_DEVICE_TABLE(of, omap_sham_of_match);
-
-static int omap_sham_get_res_of(struct omap_sham_dev *dd,
-		struct device *dev, struct resource *res)
-{
-	struct device_node *node = dev->of_node;
-	int err = 0;
-
-	dd->pdata = of_device_get_match_data(dev);
-	if (!dd->pdata) {
-		dev_err(dev, "no compatible OF match\n");
-		err = -EINVAL;
-		goto err;
-	}
-
-	err = of_address_to_resource(node, 0, res);
-	if (err < 0) {
-		dev_err(dev, "can't translate OF node address\n");
-		err = -EINVAL;
-		goto err;
-	}
-
-	dd->irq = irq_of_parse_and_map(node, 0);
-	if (!dd->irq) {
-		dev_err(dev, "can't translate OF irq value\n");
-		err = -EINVAL;
-		goto err;
-	}
-
-err:
-	return err;
-}
-#else
-static const struct of_device_id omap_sham_of_match[] = {
-	{},
-};
-
-static int omap_sham_get_res_of(struct omap_sham_dev *dd,
-		struct device *dev, struct resource *res)
-{
-	return -EINVAL;
-}
 #endif
 
-static int omap_sham_get_res_pdev(struct omap_sham_dev *dd,
-		struct platform_device *pdev, struct resource *res)
-{
-	struct device *dev = &pdev->dev;
-	struct resource *r;
-	int err = 0;
-
-	/* Get the base address */
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(dev, "no MEM resource info\n");
-		err = -ENODEV;
-		goto err;
-	}
-	memcpy(res, r, sizeof(*res));
-
-	/* Get the IRQ */
-	dd->irq = platform_get_irq(pdev, 0);
-	if (dd->irq < 0) {
-		err = dd->irq;
-		goto err;
-	}
-
-	/* Only OMAP2/3 can be non-DT */
-	dd->pdata = &omap_sham_pdata_omap2;
-
-err:
-	return err;
-}
-
 static ssize_t fallback_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -2060,11 +1987,20 @@ static int omap_sham_probe(struct platform_device *pdev)
 {
 	struct omap_sham_dev *dd;
 	struct device *dev = &pdev->dev;
-	struct resource res;
+	void __iomem *io_base;
+	struct resource *res;
 	dma_cap_mask_t mask;
-	int err, i, j;
+	int err, i, j, irq;
 	u32 rev;
 
+	io_base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(io_base))
+		return PTR_ERR(io_base);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
 	dd = devm_kzalloc(dev, sizeof(struct omap_sham_dev), GFP_KERNEL);
 	if (dd == NULL) {
 		dev_err(dev, "unable to alloc data struct.\n");
@@ -2078,17 +2014,13 @@ static int omap_sham_probe(struct platform_device *pdev)
 	INIT_WORK(&dd->done_task, omap_sham_done_task);
 	crypto_init_queue(&dd->queue, OMAP_SHAM_QUEUE_LENGTH);
 
-	err = (dev->of_node) ? omap_sham_get_res_of(dd, dev, &res) :
-			       omap_sham_get_res_pdev(dd, pdev, &res);
-	if (err)
-		goto data_err;
+	dd->pdata = device_get_match_data(dev);
+	if (!dd->pdata)
+		dd->pdata = &omap_sham_pdata_omap2;
 
-	dd->io_base = devm_ioremap_resource(dev, &res);
-	if (IS_ERR(dd->io_base)) {
-		err = PTR_ERR(dd->io_base);
-		goto data_err;
-	}
-	dd->phys_base = res.start;
+	dd->irq = irq;
+	dd->io_base = io_base;
+	dd->phys_base = res->start;
 
 	err = devm_request_irq(dev, dd->irq, dd->pdata->intr_hdlr,
 			       IRQF_TRIGGER_NONE, dev_name(dev), dd);
@@ -2213,7 +2145,7 @@ static struct platform_driver omap_sham_driver = {
 	.remove = omap_sham_remove,
 	.driver	= {
 		.name	= "omap-sham",
-		.of_match_table	= omap_sham_of_match,
+		.of_match_table	= of_match_ptr(omap_sham_of_match),
 		.dev_groups = omap_sham_groups,
 	},
 };
-- 
2.55.0

