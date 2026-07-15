Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220A9399D0B
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 21:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784152733; cv=none; b=dLNeKAZNwzWrw+2NqjbQ3X5dzGDzQo+PuTaxUQY8ZJ7a1u8Xxzd2WvAGluEuOXGae9oezmBZ7JhzrH66VHvpdrFoJE88kDTv9jeJHDMpN2oeoZFcMscLmUTK90x/fUMpzRNVAKn79BWgheh4YQM+EizAsXCHgkEUQxCuADQEJ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784152733; c=relaxed/simple;
	bh=hPsHkppYcJtwT5WD6a4FMlXcOjcuj/3HF/re4bLRuy4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UHhxyg8nke/mfRyyQ1zIVoTLBooSYsc5VVS5IOZUQP0zs8A6c1zkcA1bXzVRGjISbsh6kAR+gSPvG+0DZSJLfMd7DoSb8ULbOYEitm+kjG2+YGexMUnWnA6Jr6nioo5hd2/T0SaNRO0dP+84Kcnvr+5VOEJ2S02Fl6FlIDNzSNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OyLwZ6fa; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OyLwZ6fa"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-383cb94f742so5613748a91.3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 14:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784152730; x=1784757530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dwyoEBnXgoKae76Ob1aTIuI+DlKo+FgchRJItlspJFk=;
        b=OyLwZ6fa5QsetQxu83kw0XM0NxHd2yM1RfW6xNOBotBNVV/KEsQlXfAh5JEUfstY/c
         78jR1tEec4inZZit1jJwD6zJvDk65GiNU5ANI7oJaoW80YWqvrR/7mBLCvQhs2qToCuD
         TSfJQlzjIQ1/bNuRn0q61ql7/sg9MFZK8EAgvavWcr8SuhMtSs4hqQyNIaQAosujeRDO
         Nyqub2ibRRClRWWP8isYMhOqhkjFoZVBfsKs9hMoIy54crHJUHj0FL3VRrVFugvIa+Qt
         gqaR/cWXvBekZ3LXSQFl5cahhXjBz7qUVmbv94v/MFm8ybF5JH89KX8lkbjIwABwwqTO
         DRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784152730; x=1784757530;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dwyoEBnXgoKae76Ob1aTIuI+DlKo+FgchRJItlspJFk=;
        b=h9x9MCWA68SYyHOmhEEvfoT9zDwmA9btE0zNQdhOzMVHt8sInVkcV7zplVo9cODSeK
         W3hHVkuLDOZvNSrl1B7mlsCYqki8AmUCsO6dZEi3hpboUgNEKpRn1wOX4H5Z0DyA32jT
         oXb6brmknfQX2kaVdDDG2d6mzRtvUku26w40lOnpyzeTpKyWAw0/TSOw3t6QPl2/mGbt
         h0tztPBDiSmx0w4gZy7auHU6sacwoaPz0+L+lYT9otHgwKxyRvOsesqH8QBMfekQv7yS
         ADUfujsYjcgQDVX54DFKRbDov+smPRt9VJhdiz6TMs4mnvobgHGc5P9Ngum+SV18HfT0
         LE2w==
X-Gm-Message-State: AOJu0YxuBQG5BJ/TblEZ/osKh98Na3Stmbkl3D3t6e9YDgwmGI3BxRcn
	lOeTT8+MYzistXt/GowzyTHWvW8Ub8nqmIFoM2gY/Txde+837TJSNzE6pwflXA==
X-Gm-Gg: AfdE7cmv/ra6kgvvb/5Mt2Ze1AO2HwIfldcZjMpL4SUK/gXHyhh86xI8psiFAd7+sWI
	jmoGEPNVEVavyYWXVPi9FYOyfOFW0gpaWHXXI1okE39TMMDpeNbyAq3uct58057xJhRX2Wm/4aG
	Pg2z0ZKzhXnJ8uSy3wBvZiXG9JWM5ZSPVjiHbaoYN5M6rpSL3xmcwxVPFsHzxzKHMpk+5lyAtq3
	VVh3t3PVDY61TaDhYq7t3JAWrW+GxEi5Os9UvgBNyAQUXVh2+t/4zGdBtijd82cc45qb/aqRbdA
	nwmvQyxUsmsdE4pq6vlzkMPP8nCXhXL7/+kqJdewA/reoNAVKeGI/x8PBlvGvoJtQSQP22d07bN
	sa7c3BYiRERaJkZz+tmfOOaXy8Nx24loBhn0RWPfuSvE+4ixcoSNTIxNtsLZBvf5+DcfWK9x09M
	5W2qRSHgHx4iop0fZAjsaV1xc4nyJ6xOQXhHIQ83VUUjliiweagyxxfDkK0bdtD6wj36d4pkw1a
	2dgSwIxyF2dsJQ8BjtekvfSfEr1onMyD1s4cPlXuIDhZev2MSzXTXNCRe2UUZerpQ==
X-Received: by 2002:a17:90b:28c8:b0:37f:f4ae:5f25 with SMTP id 98e67ed59e1d1-38e2a0c3b18mr3502975a91.20.1784152730368;
        Wed, 15 Jul 2026 14:58:50 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e39fe37d1sm215111a91.12.2026.07.15.14.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:58:49 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: omap-aes: use devm_platform_get_and_ioremap_resource
Date: Wed, 15 Jul 2026 14:58:48 -0700
Message-ID: <20260715215848.410011-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the open-coded omap_aes_get_res_of()/omap_aes_get_res_pdev()
helpers and the #ifdef CONFIG_OF machinery with the managed
devm_platform_get_and_ioremap_resource(), platform_get_irq() and
device_get_match_data() helpers. The omap_aes_pdata_omap2 fallback is
kept for the non-DT (legacy platform_device) case, and the now-unused
err_res label is removed.

Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/omap-aes.c | 84 ++++++---------------------------------
 1 file changed, 12 insertions(+), 72 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index f31555c0d715..a5fce216de34 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
@@ -952,65 +951,8 @@ static const struct of_device_id omap_aes_of_match[] = {
 	{},
 };
 MODULE_DEVICE_TABLE(of, omap_aes_of_match);
-
-static int omap_aes_get_res_of(struct omap_aes_dev *dd,
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
-err:
-	return err;
-}
-#else
-static const struct of_device_id omap_aes_of_match[] = {
-	{},
-};
-
-static int omap_aes_get_res_of(struct omap_aes_dev *dd,
-		struct device *dev, struct resource *res)
-{
-	return -EINVAL;
-}
 #endif
 
-static int omap_aes_get_res_pdev(struct omap_aes_dev *dd,
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
-	/* Only OMAP2/3 can be non-DT */
-	dd->pdata = &omap_aes_pdata_omap2;
-
-err:
-	return err;
-}
-
 static ssize_t fallback_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -1109,10 +1051,15 @@ static int omap_aes_probe(struct platform_device *pdev)
 	struct omap_aes_dev *dd;
 	struct skcipher_engine_alg *algp;
 	struct aead_engine_alg *aalg;
-	struct resource res;
+	struct resource *res;
+	void __iomem *io_base;
 	int err = -ENOMEM, i, j, irq = -1;
 	u32 reg;
 
+	io_base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(io_base))
+		return PTR_ERR(io_base);
+
 	dd = devm_kzalloc(dev, sizeof(struct omap_aes_dev), GFP_KERNEL);
 	if (dd == NULL) {
 		dev_err(dev, "unable to alloc data struct.\n");
@@ -1123,17 +1070,12 @@ static int omap_aes_probe(struct platform_device *pdev)
 
 	aead_init_queue(&dd->aead_queue, OMAP_AES_QUEUE_LENGTH);
 
-	err = (dev->of_node) ? omap_aes_get_res_of(dd, dev, &res) :
-			       omap_aes_get_res_pdev(dd, pdev, &res);
-	if (err)
-		goto err_res;
+	dd->pdata = device_get_match_data(dev);
+	if (!dd->pdata)
+		dd->pdata = &omap_aes_pdata_omap2;
 
-	dd->io_base = devm_ioremap_resource(dev, &res);
-	if (IS_ERR(dd->io_base)) {
-		err = PTR_ERR(dd->io_base);
-		goto err_res;
-	}
-	dd->phys_base = res.start;
+	dd->io_base = io_base;
+	dd->phys_base = res->start;
 
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, DEFAULT_AUTOSUSPEND_DELAY);
@@ -1244,8 +1186,6 @@ static int omap_aes_probe(struct platform_device *pdev)
 	cancel_work_sync(&dd->done_task);
 err_pm_disable:
 	pm_runtime_disable(dev);
-err_res:
-	dd = NULL;
 err_data:
 	dev_err(dev, "initialization failed.\n");
 	return err;
@@ -1294,7 +1234,7 @@ static struct platform_driver omap_aes_driver = {
 	.driver	= {
 		.name	= "omap-aes",
 		.pm	= &omap_aes_pm_ops,
-		.of_match_table	= omap_aes_of_match,
+		.of_match_table	= of_match_ptr(omap_aes_of_match),
 		.dev_groups = omap_aes_groups,
 	},
 };
-- 
2.55.0

