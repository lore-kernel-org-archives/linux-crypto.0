Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B625677F
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 00:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785113630; cv=none; b=Yvbyi5NzTPU2a3SZhKEwepeI/hPe1mAKFGTfxu3M+Q9lsxFYsoAh9oPJVMcDgog1SYyy3d+Ns7uWEPVA8po+Yn8fEOQh7LkwAV3voABAtMRLtuBx1G7WDnBA85I99mVjgB2g+0CRUZcmeU39HVi1NA1ZHZCC/jE6EZDlvXnggvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785113630; c=relaxed/simple;
	bh=H5d/2IpDJ5mSbV2nCWBAdW/aONLsYHfxTefAkVqKfqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WP0lUS1HGqxX3XnfGB7fXBz/KxIuuE7EMHXiaTAeSLkltqx0GVhHdIUTiiuZ8pHhWl8nSrEl+5yNU6PsF9jf9OXiDhwm6pS71xkxPPZ4JCCwxLIrcLDryMmS9xKIIbgVaJCotdlVz4cHrQC6M3h5+FODAOyPJMtE7guVw+zlV/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIET52Wu; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIET52Wu"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c0006ea8eso16644371cf.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Jul 2026 17:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785113627; x=1785718427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D8hT5YG9osvX+mj6IYiZum/vN/YOieTcuoDvay1/Cqs=;
        b=XIET52Wu3dzb0JZvRL23GvsO2IrVARGQPzROLqb9+rIFaaZ6PI2TCm6xSXI2jceMOh
         EbiOLtWo+uX3qOF7Txb77ZMui+xlTRP8QcoavpfVG9R67rbC1BbsWm8fgNFYouMwH8WT
         dE7iGlHbpUa454xGkyBTSZP5J1sMpM19reo3lxOk0jrTtx9+HM+Auy28BoE5MV1LmC5d
         ffdHXi+7XwZkw8cKiFEBWp5M9WLRCQImqYtF9JLKks/xHAzFgxBnuPXpN7a6Kkz5SGs7
         r/XJUp/JtF2/UkUrlac+JYH7gJS3n+Dcmv2/t1vcN39SXAEL0mC4sdolnrYUNXSa674v
         QtWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785113627; x=1785718427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D8hT5YG9osvX+mj6IYiZum/vN/YOieTcuoDvay1/Cqs=;
        b=Px0CNTYKVtu1CYPbDBt3PuqY9X+22AmIp4rm5ad9SOeJrQCJdRQlFAks5VkE2OVT09
         lEK704CfODwI15pRlyc/kAjNGROqaLeexOLagokW7mbhCsr/MMrYCcZqr3AbH+LAvVFP
         PYDDGoI5+Q1KbnUIvapz5eDEOun6o5o6wxXzmJ2EgMKbKu9kEFJYUi0t0RSm1L2ZYGSb
         ei1cgubWbakj4JRgN6qClC8sW/e0sH2wTW/s0s7HiIqiP768CcR5r0yc10NaSNHSZfRE
         RnCVInZuqpG5NrrC8Ecw0gRurnpn236r9yKBWwH2EoGKkYVDT/RGUqlOq6ezGBFCztYV
         YokQ==
X-Gm-Message-State: AOJu0Ywgnt9nE7A3UvD+SKfbmqv4aQ5OrNQzwz9aNC7dtBNmSHEvU7fX
	baFKq3Jptsr+GLvtaAJn/+e1hJDtVTx+PxOU+cuqBOJhW/LXD3rhFbNZqruXww==
X-Gm-Gg: AR+sD11W5bHJSGnZAEzAhF/Mk6jTfRePvm4y1ZA/Batpn8hCGGvajTdNrkLSHMdCSUR
	qyTDvndAEFzwVog6YTLj/gIV0atA5kj3/Z4betcJuU/NesTGxPoFDs/C/8Xwj95w/XtXjf6saQJ
	bA67uvpT6GtfkWQCwUMCwaXjtnizECp/K8SMk7wFRfpFPKb6qfViGJuwEKzssMCDIkWlojp3VrH
	CGKwwDjf4vPMUafSf3FaVuxCjMfFIF7jGWE93a5IJCt7OkiaSZpw+ig6vIELCGH3n05yd33tIAr
	+5WriB2pS8rckl6PF5hbB8Pud3O61Wi5vn9JZ7lg3CbaLFJNYvkNlcjM/g3LN6Luj/MHMA6zgVD
	4f2DDEVUjjz3hRs0Qq4It0q9jsj9ryxS9RAh4dTIX7G5aws+HzB1LtfWYQxfR5LP0ZQT7p/cBeH
	fcr7Gg7buVnZ5kwSI95GMGYmkQW2NsEGQ7F5wYgrGTQDnT/DrxmxihrOotbtHumnzYQc1PK/ZOm
	p3/Txuy09VkGDtr7Yi5shy/RcLS6PrrkfSAXjvXcSFcLOMUUYLw4SET5sNYqAS6fw==
X-Received: by 2002:a05:622a:2586:b0:51c:d1c:474d with SMTP id d75a77b69052e-529a84b9a6emr73328471cf.19.1785113627516;
        Sun, 26 Jul 2026 17:53:47 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529a27f2dedsm42949171cf.7.2026.07.26.17.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 17:53:46 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: talitos: Use platform_get_irq() to retrieve interrupt
Date: Sun, 26 Jul 2026 17:53:44 -0700
Message-ID: <20260727005344.166124-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the need to call irq_dispose_mapping as needed by
irq_of_parse_and_map().

Simplify the function as a result. No need for gotos anymore.

Add a missing free_irq.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/talitos.c | 43 +++++++++++++---------------------------
 1 file changed, 14 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 3a3fd21d2c4d..bff653b87941 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3241,10 +3241,8 @@ static void talitos_remove(struct platform_device *ofdev)
 		talitos_unregister_rng(dev);
 
 	for (i = 0; i < 2; i++)
-		if (priv->irq[i]) {
+		if (priv->irq[i])
 			free_irq(priv->irq[i], dev);
-			irq_dispose_mapping(priv->irq[i]);
-		}
 
 	tasklet_kill(&priv->done_task[0]);
 	if (priv->irq[1])
@@ -3353,54 +3351,41 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 static int talitos_probe_irq(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
-	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int err;
 	bool is_sec1 = has_ftr_sec1(priv);
 
-	priv->irq[0] = irq_of_parse_and_map(np, 0);
-	if (!priv->irq[0]) {
-		dev_err(dev, "failed to map irq\n");
-		return -EINVAL;
-	}
-	if (is_sec1) {
-		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
+	priv->irq[0] = platform_get_irq(ofdev, 0);
+	if (priv->irq[0] < 0)
+		return priv->irq[0];
+
+	if (is_sec1)
+		return request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
-		goto primary_out;
-	}
 
-	priv->irq[1] = irq_of_parse_and_map(np, 1);
+	priv->irq[1] = platform_get_irq_optional(ofdev, 1);
+	if (priv->irq[1] == -EPROBE_DEFER)
+		return priv->irq[1];
 
 	/* get the primary irq line */
-	if (!priv->irq[1]) {
-		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
+	if (priv->irq[1] < 0)
+		return request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
-		goto primary_out;
-	}
 
 	err = request_irq(priv->irq[0], talitos2_interrupt_ch0_2, 0,
 			  dev_driver_string(dev), dev);
 	if (err)
-		goto primary_out;
+		return err;
 
 	/* get the secondary irq line */
 	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
 			  dev_driver_string(dev), dev);
 	if (err) {
 		dev_err(dev, "failed to request secondary irq\n");
-		irq_dispose_mapping(priv->irq[1]);
+		free_irq(priv->irq[0], dev);
 		priv->irq[1] = 0;
 	}
 
-	return err;
-
-primary_out:
-	if (err) {
-		dev_err(dev, "failed to request primary irq\n");
-		irq_dispose_mapping(priv->irq[0]);
-		priv->irq[0] = 0;
-	}
-
 	return err;
 }
 
-- 
2.55.0

