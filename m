Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2313BB9FE
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 20:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785444449; cv=none; b=Z3SmBWkb0du1w7uEGqLGIV5RuEN6avJWrFPagoVACdAOJSN4bydsysXSF6CnRWtzl4vzbxGKKJjXx0+shBupFBLaX/2qAiLUJb085hKHfrH8UiODKrr0tv9VOEmKX8MOYKgta7JlVjd1b3UOv14/gUC4Gs0dAsD2tpjzBb5cqgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785444449; c=relaxed/simple;
	bh=tc6Aor8BIWJggRsEL0/BbUrhcYg+2Fh+f74aCbHKzjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V70tP2gAKuwM0+T17lrl1sfuye7i7bfG5wkYulW9lD7PAkiDRp4CBzI3Eoo68dJsrh0ImtcSwm436dIdCOwdeNN2ONHfGvptcvDObPnLTMA3uO8Y7ooK4IlhnirxEuwuJgQHYlihkECGRcI6NLANNhjP6X61SN8JJe6Q0xqBzcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eT96W2Uv; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eT96W2Uv"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc891373e0so2425625ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 13:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785444446; x=1786049246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kyZerB2mssSUDYfYvPPUJl18+btDjzzEKnSFWLtWvLU=;
        b=eT96W2Uv8ICncBa2r58IIUylNORtuBd7HMFbdnBojgId76hZ1tlPXa9xmO5UQjOFhk
         LJ8OiNz+EIEKbvBY6mI1d62rDkvpm4Zi6ILEa5x5Y5MjBHRC5AkGKFVBQPVLK86ds+Te
         w/bx9m5vSJUtHFvcgKKQrQHAabb37A1LoWN6mbu2FHnyQya4hqP/8XP7vCc0qPIli0R3
         cLSTCCbWEYUPRx2HsGS30YRvQBgLocUqfz1URRPXJU68GrQF8C54LzgzP+CKWzdXQ9jq
         YO4padmMqGZx5iixb/7sx5rXa4DOVPDLj6c2nrTZozH7IvXiuifQStmK3TiydumplWtY
         /K7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785444446; x=1786049246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kyZerB2mssSUDYfYvPPUJl18+btDjzzEKnSFWLtWvLU=;
        b=QOUQdGd/+lWj2fD6iYuPB9tlS1oLjParrtCImybyQNaFTxJfpbyBFHXMW0kexLuCEx
         7F1p1P6zEROoNe/RBF8T+shpP7+PU0d7ForjrWe6J5or2Wlq23NSFYDjAYOTR+jh6uJE
         n8jzaIo//bnvl02ym4pUgsizMtxxN8lQzw+kHpnLTHuJsVACtdk/WbWRWeTq5FFef1Tm
         ESzwwR9L8l+vPEe+hdKd7DymG55HCIDsYmseEwn8UKXCPT1Lk/j1zB2REbV1cQ/5UxX+
         snaKHDnkHziprtf0ZLP7vaXH90/RGXQJ2YOkMIqBA/NBRWOR0ML/mfFNEGnft8K+ct6H
         GVgA==
X-Gm-Message-State: AOJu0Yy4ievnb1KrVY4VK3si4ZLMIguTlxue/trf94eGf8arawa6rXdJ
	tOjb52J13VEzpag0V1xLfFjhUu8AeMsihu0TuFJIfoWNGhawGDMPCTbGrE156GVL
X-Gm-Gg: AR+sD10u/H/IlNafRuJq4W3sZfIcMLcbG20m7liADHcBSNLgR3C66jyLo6WrEZU22kv
	T2zZonvK6FA9CiVI63Y3L2uKGCeuUCIanLLUPQe9HBk/GZj5H02n/20IHc72MwZ7ZGRQ9U3S8nI
	VRULEsvbs/WchIRPth5JY6UWhDSMNQ9ZwUEy6BTZ4KjYDdvh420kGMY7hZznL6ivMgqBgZVHBcb
	NTNu+VF2QcqXfm5IgNJjs/dCy54Bts4Gt7Pud+9JOiLCJLKfZBLZCSc8g0N4nvpTRsJRzNZhJax
	9S4JFUBPOEnfLOhvr/hb6hMEYJ1yepdpQNdnpUGU3Q9UYgVkdEvch42fWFeW7vOROx7o0mfsWuD
	FzAWUN40VCLL54QWJ188m+Ot7g+bY4Yfq5+eAP2pxAbQx14gMO06RbYup5IleWxQ/NqQ5EpHXzN
	IeeUbZouHjO40PdxUPS9lOIjj2dCETtzKC7WhJY8oinkl9YApB/Jfdh329KGz2cZPL1rLQ0w8lA
	MGwCZE8UcEdBFv8jmtl05zCuvFEYwmJFXS/NYiovwiNxuk+EIFYXzoS3xPshrH+LMPVjmARkbLX
	lndHaa3HnI8bSMjoVYQxAh+TTFIEf0Ulk+GdNw==
X-Received: by 2002:a17:903:3b85:b0:2cf:7e56:22c4 with SMTP id d9443c01a7336-2d035d1c022mr33153735ad.30.1785444446237;
        Thu, 30 Jul 2026 13:47:26 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c2da38sm31292525ad.73.2026.07.30.13.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 13:47:24 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: caam: simplify probe resource and IRQ handling
Date: Thu, 30 Jul 2026 13:47:22 -0700
Message-ID: <20260730204722.1101805-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the interrupt acquisition from irq_of_parse_and_map() to
platform_get_irq(), which resolves the IRQ from the device's interrupts
property via of_irq_get(). Flip the error check from testing for zero to
testing for a negative errno, and drop the now-unused
caam_jr_irq_dispose_mapping() callback and its devm_add_action_or_reset()
cleanup, since platform_get_irq() manages the mapping internally.

Replace the open-coded platform_get_resource() plus devm_ioremap()
sequence with devm_platform_ioremap_resource(), which fetches the
resource, requests the region and maps it in one call.

Each fsl,sec-*-job-ring node has a distinct 0x10000 reg region and
interrupts property, so the region reservation added by
devm_ioremap_resource() is exclusive and does not introduce overlap
failures.

Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/caam/jr.c | 46 +++++++++++-----------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index bddeaaaca487..239469f6882e 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -574,23 +574,25 @@ static int caam_jr_init(struct device *dev)
 	return error;
 }
 
-static void caam_jr_irq_dispose_mapping(void *data)
-{
-	irq_dispose_mapping((unsigned long)data);
-}
-
 /*
  * Probe routine for each detected JobR subsystem.
  */
 static int caam_jr_probe(struct platform_device *pdev)
 {
 	struct device *jrdev;
-	struct device_node *nprop;
-	struct caam_job_ring __iomem *ctrl;
 	struct caam_drv_private_jr *jrpriv;
 	static int total_jobrs;
-	struct resource *r;
+	void __iomem *ctrl;
 	int error;
+	int irq;
+
+	ctrl = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 
 	jrdev = &pdev->dev;
 	jrpriv = devm_kzalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
@@ -602,22 +604,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 	/* save ring identity relative to detection */
 	jrpriv->ridx = total_jobrs++;
 
-	nprop = pdev->dev.of_node;
-	/* Get configuration properties from device tree */
-	/* First, get register page */
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(jrdev, "platform_get_resource() failed\n");
-		return -ENOMEM;
-	}
-
-	ctrl = devm_ioremap(jrdev, r->start, resource_size(r));
-	if (!ctrl) {
-		dev_err(jrdev, "devm_ioremap() failed\n");
-		return -ENOMEM;
-	}
-
-	jrpriv->rregs = (struct caam_job_ring __iomem __force *)ctrl;
+	jrpriv->rregs = ctrl;
 
 	error = dma_set_mask_and_coherent(jrdev, caam_get_dma_mask(jrdev));
 	if (error) {
@@ -647,16 +634,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 	}
 
 	/* Identify the interrupt */
-	jrpriv->irq = irq_of_parse_and_map(nprop, 0);
-	if (!jrpriv->irq) {
-		dev_err(jrdev, "irq_of_parse_and_map failed\n");
-		return -EINVAL;
-	}
-
-	error = devm_add_action_or_reset(jrdev, caam_jr_irq_dispose_mapping,
-					 (void *)(unsigned long)jrpriv->irq);
-	if (error)
-		return error;
+	jrpriv->irq = irq;
 
 	/* Now do the platform independent part */
 	error = caam_jr_init(jrdev); /* now turn on hardware */
-- 
2.55.0

