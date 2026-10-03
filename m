Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B122773F7
	for <linux-crypto@vger.kernel.org>; Sat,  3 Oct 2026 21:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791062644; cv=none; b=dGCM+kf4pzXujIaFDAfuZYrwCuoYgsB3P5OfOsJ4ckpk2bqjvIQhR0XcTzDKTgFAk1MaWI1ONro2j8CHKQ2AB716xpzeDMRE/Z2ARKYiNAZud4KVxNAEevMu901obr3oNNF3TkNrDJ6NUAetgUyERxZc32fJJOX+HV8v9AJxXM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791062644; c=relaxed/simple;
	bh=CrLJ9dfj2c/eke013I/eMWWMagmxB1FlL5oP0Ukye+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D1rIkhZ6Kt37wrI7jglj931k3AnR2d2Gb8yAbksKh9QCkIsAJ49SddUSJnsFOa0LbxpfNIwlHAjxDBaedoR1vRwfPug3O6UwbfqPACnR1WSVdO/OAWTdcExV8+03EWQFuUfi5/8Zq9Jj9qwoPx1jJ5+Kg34y+gt4LHRXB4CjaoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BYJzxRCV; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BYJzxRCV"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e4ad94ccf0so3676515ad.1
        for <linux-crypto@vger.kernel.org>; Sat, 03 Oct 2026 14:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791062642; x=1791667442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZhsjuLXqM5FY33Q4lIM5AbhdLxpQjvL/gIK2fygQkak=;
        b=BYJzxRCVBYOaJFFmS2NGBWTA0X9Qqxz827ganjWr9dPNgtMc6IJRZERAENKsbc8opl
         ZHgc0QdPbCGrwEPY6YgvuKREnaFiliMVw0ya4daxBZdBfpXPeV8xNKYGGW4Y18udiqfJ
         XeWxbSxFgNl7k9HFnkp3k8LygMm9hVkuqsl5vZI+Q04uFwWJlEizmzKnCPM9nakxmN5v
         EEklcmSbjSg4sZrWCCEeTZntjTYNEx1LJ6itZnu1gUlj71rqAZ3ST3vIw22JkA1/cGQy
         jh4j7DhbZ6fHgIOhRcpEChDyMCr04eZaDNdpSl3N28EChvjnmOAUG/nZj2vZJl7rtEe8
         y+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062642; x=1791667442;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZhsjuLXqM5FY33Q4lIM5AbhdLxpQjvL/gIK2fygQkak=;
        b=n28K2jCBF8TwmBOm4hWd+Gh59KntlcEbjxYW4Z5Yn6iy7riZLNMko1aphxJmaWP6+A
         uHVo3x/23S8rVe2NmJyT+6Ifa5JTNh7iBLfatxNV1vCmrkrRV0YATo5xuYx2W2KIuf1e
         IhMTmUVspf2gsHhjFBykoGHSl8J3kgv7z65kZWwxPKMEfg+z8iALzpm1ntHhkv8WL0P5
         I0zuKvPTKmu29nb5sue3jCdoWcndA0xyTklt1gVTEpOg4TEH5Pcwvs6XgQSRrIBISXfu
         J35lp7biNr3WzwryNUntAby//cyrxIJhzUfOyoFHBDaAF2/hHjmo8R4Wk8KnSsHVo7e6
         lBUA==
X-Gm-Message-State: AFq9FYLGWRb56f//ptr8UlKfeJeH3qqNiFhNzCtHR4Dqaexx5udXKt60
	pQlA9pLBKNwKtFy+JZXXQmnVKtriM/oDKRmc/2RFcTWvgdFTvizWgKgp+BRQ48zM
X-Gm-Gg: AYBFou0jzlGQBNoBqGbopNyz/RHRt47inhG3ablTmfY7STgL/turIE087S/H1rlmahW
	63j4M8ZcaIyFBC8HZg9NXYELCHtAg16lep40f2Q6ivJknUoUJFWGHwHcdoKUVGMJYLTCKubrWW+
	1N/ALjtCX+7FJwEJwWm8YJlM1EhAcJJ0TInhUhPubpYSiuYLSXcHYkRBjX8HmFQD8nSZ+63upED
	Z8GCbw8rQhoe00pbVkm0P3kTTA8IX9er3hHipV+Sx8myGRVUP7ev1vbirjn5PZm/gpvH9//VKwl
	vV0IUb+AJC2HZuDx2etZSovwmb0EYHPD5yEwzl2bPJAoMUkOBz9JedYVYP1mY4zBogItm/9k+Jk
	iIjZ0H3j5QM/MWmd6GZt/uQLGOI3PCXsbFMk9Dzg83RFY1mHZpVq8OeinJKOuEA1u59OeF+KiCX
	MF0H83x+gcneH6MD+jobW9kg1UXhNaWQRGL2mGYQaa3CEoKqt5kLlA4D73MLEaogZA7eX00Pa42
	jXox9BG1/lBrUWhykj90LL8k27XxBm+0CKnlyntjCijg8YIKhbxULm0mBqdpd9NTUswS46N7kXI
	SyXUzYqj7pN69AoiM4fHE51KRyGnh4U101H8O74F9F120VVa
X-Received: by 2002:a17:903:384c:b0:2dd:ad74:ac2a with SMTP id d9443c01a7336-2e5105a57c4mr30118925ad.28.1791062642500;
        Sat, 03 Oct 2026 14:24:02 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6d9a88sm18913265ad.53.2026.10.03.14.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 14:24:00 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] crypto: talitos: fix probe IRQ ordering
Date: Sat,  3 Oct 2026 14:23:59 -0700
Message-ID: <20261003212359.126745-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The talitos interrupt handlers schedule priv->done_task[] via
tasklet_schedule().  In probe(), talitos_probe_irq() ran before
tasklet_init(), so an interrupt arriving during that window (a shared
IRQ, or a completion pending from an earlier transmission) would
schedule an uninitialized tasklet.

Resolve the IRQ numbers before the tasklet_init() calls so the
done_task[] selection can see the secondary IRQ, and only request the
IRQs after the channel fifos are allocated and the device is
initialized.  Every structure the handlers touch is then fully set up
before interrupts are enabled.  This matches remove(), which frees the
IRQs before killing the tasklets.

Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v3: reshuffle again to fix IRQs.
 v2: reshuffle code to avoid NULL derefs
 drivers/crypto/talitos.c | 48 ++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 41a87d7c30a0..70f7ad9e09f9 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3353,21 +3353,13 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	int err;
 	bool is_sec1 = has_ftr_sec1(priv);
 
-	priv->irq[0] = platform_get_irq(ofdev, 0);
-	if (priv->irq[0] < 0)
-		return priv->irq[0];
-
 	if (is_sec1) {
 		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
 				  dev_driver_string(dev), priv);
 		goto primary_out;
 	}
 
-	priv->irq[1] = platform_get_irq_optional(ofdev, 1);
-	if (priv->irq[1] == -EPROBE_DEFER)
-		return priv->irq[1];
-
-	/* get the primary irq line */
+	/* single (or primary) irq line */
 	if (priv->irq[1] < 0) {
 		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
 				  dev_driver_string(dev), priv);
@@ -3379,13 +3371,11 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	if (err)
 		goto primary_out;
 
-	/* get the secondary irq line */
+	/* secondary irq line */
 	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
 			  dev_driver_string(dev), priv);
-	if (err) {
+	if (err)
 		dev_err(dev, "failed to request secondary irq\n");
-		priv->irq[1] = 0;
-	}
 
 	return err;
 
@@ -3404,12 +3394,27 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv;
 	unsigned int num_channels;
+	void __iomem *reg;
 	int i, err;
 	int stride;
+	int irq0;
+	int irq1;
 
 	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
 		return -EINVAL;
 
+	irq0 = platform_get_irq(ofdev, 0);
+	if (irq0 < 0)
+		return irq0;
+
+	irq1 = platform_get_irq_optional(ofdev, 1);
+	if (irq1 == -EPROBE_DEFER)
+		return irq1;
+
+	reg = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+
 	priv = devm_kzalloc(dev, struct_size(priv, chan, num_channels), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -3425,12 +3430,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	spin_lock_init(&priv->reg_lock);
 
-	priv->reg = devm_platform_ioremap_resource(ofdev, 0);
-	if (IS_ERR(priv->reg)) {
-		dev_err(dev, "failed to of_iomap\n");
-		err = PTR_ERR(priv->reg);
-		goto err_out;
-	}
+	priv->reg = reg;
 
 	/* get SEC version capabilities from device tree */
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
@@ -3481,9 +3481,8 @@ static int talitos_probe(struct platform_device *ofdev)
 		stride = TALITOS2_CH_STRIDE;
 	}
 
-	err = talitos_probe_irq(ofdev);
-	if (err)
-		goto err_out;
+	priv->irq[0] = irq0;
+	priv->irq[1] = irq1;
 
 	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
@@ -3540,6 +3539,11 @@ static int talitos_probe(struct platform_device *ofdev)
 		goto err_out;
 	}
 
+	/* enable interrupts once the channel fifos and tasklets are set up */
+	err = talitos_probe_irq(ofdev);
+	if (err)
+		goto err_out;
+
 	/* register the RNG, if available */
 	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
 		err = talitos_register_rng(dev);
-- 
2.56.0

