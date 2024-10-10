Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0FF1D0483;
	Thu, 10 Oct 2024 19:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589705; cv=none; b=eGXiNxDeNGyANeBHOIYvSDhbr8W6kGmb/Leh3/A8fZiMeARrFamU5uRGajrE1XmMz5zY2p/p6e8YL6LBsUd3+ZE3P61PDns8wM/rwyI6MH5W0pCdCeRITdoRe+a6gkAG+mCgJdXNOjFM4yQkM2ji6JS7yA+yUbzdBTVclHB5Rgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589705; c=relaxed/simple;
	bh=87L7pqTgKxiH4T+1YQRRLs5Dylo1XhBRzW1kTCsfRBw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m4NPZQj48FEWfGo9XzixOFelTcfr+VSWZ3b8fCe8s8Q/Ou6tCn5xbSsiOedPXTHgL9HGj+grIAJ9oNwRG/S6jWpKA6J2hAd3XILfI2YoXaiPXXu6182fFlFtJYbzQ/J2CHsPTw8Nb8xq6nSLgGPq8gVh9CmW76hHgqt4D8nX+Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SbtV44zn; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SbtV44zn"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e2e8c8915eso400677a91.3;
        Thu, 10 Oct 2024 12:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728589703; x=1729194503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nqAu2w1h0yw2rQerhN5nolABWHHaIoUYHs4YqP+g4Vw=;
        b=SbtV44zn1b33xlgFCPo9Ymy81vGMJkfAEPUBjvbS8xeaUmNCD6bTmErmiW1ZPWjoGx
         O5IzeEod4HFxJ7FJrMR2+TwhuHk27H09yDBnwAa0TrrH5TmJiKWODNTjCFW6j1OdjEQ6
         RmX6LiJgxteLGJcY8Tab2pcg3ZY83QXsG/68WxpYvIec9I7Z7jx0aruVJ/ZtqUIKvuJe
         O12p0rs+07oP5QZ8qp9dA+GHcGaTMzBLwWPSUAZQmk9vm3NMlUVPESjIL0LvxIZb8Ap1
         WZhUWD/6Bn1ReQClEoW6bHeonXD9a/In6gteG/4WsCmxamuRsC1+IwSCJ2sqNJt2SkSU
         aksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728589703; x=1729194503;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nqAu2w1h0yw2rQerhN5nolABWHHaIoUYHs4YqP+g4Vw=;
        b=wale8JEr+z9cm54Z7RQpoIthHMorEdlWGadMZ0zq95BGW0+lL5y2eyFr2ss1l2BIVf
         +Mr7gvwn2CJyJRv2t6RF17l0Vj1fvtYZpGdJX6bQFAvicGSM22MB8vTSpOIlhvoOZQ7B
         c7WkIQ+MxZ9WuG70IjnXgobBjB8lDWRdSXu8wTjDzw/ZU97wSfg1i8NozoWp7zwRuclo
         1fxXWq5nssPUEEocL3k5tA0XWkE+9FymtyqPcTAQ00T9wsiG3/bfPEUEcRo/kHXShLFk
         eR+HqrtAnnxIGe9iBwi4CqSokqX+uXZP9gWKvlPbphbc+5/z3cf3VIGeeh1o5LceYdxq
         kC8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUzKhoyGSlzUGBj5QY6bUdkxrOGwXIjZhGL5IXVw+TuMrJPt0acjZbOOJ2B6NlcOmBhqf/ZGTfxvjttGgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWQ9JSA/07SHqpOyC/nMsX6R4sGtHZVMgY8CnN7pBxxuX/lHAc
	yyphRL51omjz7HtOwgNfDovA0tKxNmdYeQF+stSR+dz/psmVLSjOTZs4/8Xc
X-Google-Smtp-Source: AGHT+IEKjzGlaLlXASzeYaac0YorNIaCiogPhJSfEV5ecVibUnYpKL+JT9LIcwijxYyoh6FKWP2ewg==
X-Received: by 2002:a17:90b:4017:b0:2e2:edf9:b8b8 with SMTP id 98e67ed59e1d1-2e2f0e905d1mr337624a91.35.1728589702939;
        Thu, 10 Oct 2024 12:48:22 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2d5df0ce8sm1754381a91.14.2024.10.10.12.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 12:48:22 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] crypto: crypto4xx_core: avoid explicit resource
Date: Thu, 10 Oct 2024 12:48:20 -0700
Message-ID: <20241010194821.18970-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no use for the resource struct. Just use
devm_platform_ioremap_resource to simplify the code.

Avoids the need to iounmap manually.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 6006703fb6d7..5ebbf83b4f3e 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -653,7 +653,6 @@ static void crypto4xx_stop_all(struct crypto4xx_core_device *core_dev)
 	crypto4xx_destroy_pdr(core_dev->dev);
 	crypto4xx_destroy_gdr(core_dev->dev);
 	crypto4xx_destroy_sdr(core_dev->dev);
-	iounmap(core_dev->dev->ce_base);
 	kfree(core_dev->dev);
 	kfree(core_dev);
 }
@@ -1333,17 +1332,12 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 static int crypto4xx_probe(struct platform_device *ofdev)
 {
 	int rc;
-	struct resource res;
 	struct device *dev = &ofdev->dev;
 	struct crypto4xx_core_device *core_dev;
 	struct device_node *np;
 	u32 pvr;
 	bool is_revb = true;
 
-	rc = of_address_to_resource(ofdev->dev.of_node, 0, &res);
-	if (rc)
-		return -ENODEV;
-
 	np = of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-crypto");
 	if (np) {
 		mtdcri(SDR0, PPC460EX_SDR0_SRST,
@@ -1421,11 +1415,11 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	tasklet_init(&core_dev->tasklet, crypto4xx_bh_tasklet_cb,
 		     (unsigned long) dev);
 
-	core_dev->dev->ce_base = of_iomap(ofdev->dev.of_node, 0);
-	if (!core_dev->dev->ce_base) {
-		dev_err(dev, "failed to of_iomap\n");
-		rc = -ENOMEM;
-		goto err_iomap;
+	core_dev->dev->ce_base = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(core_dev->dev->ce_base)) {
+		dev_err(&ofdev->dev, "failed to ioremap resource");
+		rc = PTR_ERR(core_dev->dev->ce_base);
+		goto err_build_sdr;
 	}
 
 	/* Register for Crypto isr, Crypto Engine IRQ */
@@ -1453,7 +1447,6 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	free_irq(core_dev->irq, dev);
 err_request_irq:
 	irq_dispose_mapping(core_dev->irq);
-	iounmap(core_dev->dev->ce_base);
 err_iomap:
 	tasklet_kill(&core_dev->tasklet);
 err_build_sdr:
-- 
2.46.2

