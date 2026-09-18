Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207694E1C9C
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 11:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789729524; cv=none; b=Z/DpyFYoHJsxNQwGqxaFdCfpwOtPvbVSdGQQYPdme5ipPWF3JPQu6XOPKX7yeZeLAN1Pd7GsiJ0hU9Z2bAw3K/QL09hkv0BlWjtgb/4BNKFnt9SuB3wNX3R+AhIpmxrdrUcRW1it1pa4VqbXSbWOjkJiV99Lv/KwweFiQg+TZ6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789729524; c=relaxed/simple;
	bh=hUcoqwH/HxxZ783HKyQpgJVCFgXZ5I76kDE2zpLnBQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QSROixar9q5DoIGuJR79brz3N3yQxOBftz76judZd41lDHy4gDbiYTh5e/6p2SEX/GUrCLdew4bBHNVrCTHxpvjb3dyOXrTwscg+aNR6DfmiYo1OUHYSVPMbeLzVNWYk4w0suig0NEzVOkr8x4EVwX1SBoIz+eYyigsLy/ZLaP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QLi67qLz; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QLi67qLz"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ee1f9bso4891515ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 04:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789729517; x=1790334317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Df5rt+V5n08gio2qwrmwg+kssDbj2qjq7f0a+gBkW+g=;
        b=QLi67qLzXQ85mrbI2AI/wwldKikbDnMDDPtKdofJ77bEJvOxOyQPrdy7YfXX6+RQfl
         nIPEHws/7O9CHcvAeEgTHyA0OFeZHLKtITCQfdWxc5oQwRggl/sK5sNjv5d18pc3+CzA
         V9PMqlqvPmbCGzn9VySQJRjD3tK3d4qs40tBkbNWePhML8IQsOyOJf/ijHwT+/n0ESkM
         AxBE9uw3EBGiOVkPgbLwP41PqHNhz8KbJ0iMhMPu1HnNk5DxlHNKlQNJte8BFPoOmoCM
         IK2eYCRoqDUCBI4C5g0MF1v7fDWNZGLiy+OwJZU2/SO54VRPi8AmsdOAQhHK4YwuMM3i
         LkxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789729517; x=1790334317;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Df5rt+V5n08gio2qwrmwg+kssDbj2qjq7f0a+gBkW+g=;
        b=xMb2diBaGql33NMiAuEC8C58CcU7IuP8s1bKbdiDqZo8+seB0Ae0FSke3MQRIi8bJa
         GIOheF8d4TvAHks8Tqq8mFIVPsw2vj8dO3z5dv7e8i8kQCb9ykcQPz4VXnmQs0ESiLBA
         +vrQdpjZyuqSc3NrEl2+hc34I11Np2BowAySCi5D6K1YRU3g2q1VxSJn5+LpU+tFYEcK
         l6su784fsZydcUm0N3xQRRX7SasxpDDRM/EJW5xIFjE+gSSQ/brq+x4xIS3btOQGvQyX
         pHH7Lhx05c2KSdDmPe0u6rhkYhEVg6QbFqvo90Y/Z/cwweoUsHjhGsISCHBjIZwF9bIl
         sZcg==
X-Forwarded-Encrypted: i=1; AKwUvBw0SOPPolH532ss77zmQlKDZZy8CMI4gkQGcMw3cMWBQEaR/Bn48YxK1d3/gQjpHKfoKqR66J9IM5FX/nE=@vger.kernel.org
X-Gm-Message-State: AFuF++kpHDuTwlE4jWrI/GAXlOCRDVLq5el0Baj+9L/c8wEmFSaU8Hmp
	HsNV+cAWNzWzIgOV88FugPQH25moCuM0fmJ5Aq+FhVoD+jL7/rqMHbuH
X-Gm-Gg: AYBFou2JxRyV6DGnGJWRZKhjZQk40v99MFbPFgVoo4Y5XaajNEKPypN+pL7fjWXlZLb
	ge9ncxKjfl2cxOIKRaKmREoY4IHpF105QsqliPgRGTALLC48a6DaxDw8oFj09TWW75NqiLi2HoN
	l5MJpejJIRF7RJyr7z9UrUPI5DIDo/fnP2ysMlqluO91F+xb712GWpHov5+DR1EHoJwhyOEQWag
	O3tp5rVTrk+gGpSp6WgTbjpZlp4neuBMTPnkXX6ICYqVRT0TEA4Gvhd4g3mvpXD5++JcjrdYqya
	5mRERHYRaKN5mF5OvFhjSh+3K8eqflkC8o0rI1micu1nmaUBFNoVxBN9rzZDV3mb7EV1D72n8VX
	a9ejFY3meKvev/8JdHL0TXvJFnrBfkzhAF77j2loom3W0AzSAJu6ohlaBT6XDQHA7KCWmnpBvIB
	K+rSCqTxi/l1MJYX1m+fC+/cZBvljlXklI+nUdphMo/KKiA6XRDt9ZiAOUx9gsB7PBnjrsMiISG
	/UY5p4jF3QkW4M431k=
X-Received: by 2002:a17:903:3d06:b0:2dd:ad73:5b73 with SMTP id d9443c01a7336-2ddb1d5bd18mr43767255ad.35.1789729516398;
        Fri, 18 Sep 2026 04:05:16 -0700 (PDT)
Received: from kernel ([103.219.206.97])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c28180a4dsm4721501eec.0.2026.09.18.04.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 04:05:15 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: clabbe@baylibre.com,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] crypto: amlogic: Fix IRQ handler return value and fallthrough logic
Date: Fri, 18 Sep 2026 16:35:04 +0530
Message-ID: <20260918110504.7207-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In meson_irq_handler(), when an interrupt matches a flow but the status
register is empty, the driver prints an error but doesn't return. It
falls through the loop and incorrectly prints an `unknown irq` message.

Fix this by returning immediately. For empty status registers, return
IRQ_NONE instead of IRQ_HANDLED to avoid masking spurious interrupts and
allow the kernel to detect interrupt storms. Also use
dev_err_ratelimited() to prevent console lockups during an interrupt
storm.

Additionally, the handler return IRQ_HANDLED for genuinely unknown
interrupts. Return IRQ_NONE instead for unhandled interrupts.

Cc: stable@vger.kernel.org
Fixes: 48fe583fe5417 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
I have addressed the IRQ specific issues in this v2. The other
pre-existing issues mentioned by Sashiko are already addressed in my
separate patch.

Changes in v2:
- Return IRQ_NONE instead of IRQ_HANDLED when status register is empty
  to avoid masking spurious interrupts.
- Use dev_err_ratelimited() to prevent console lockups.

 drivers/crypto/amlogic/amlogic-gxl-core.c | 38 ++++++++++-------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 169c6eeb51e5..d5d84524c110 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -37,12 +37,13 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 				complete(&mc->chanlist[flow].complete);
 				return IRQ_HANDLED;
 			}
-			dev_err(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
+			dev_err_ratelimited(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
+			return IRQ_NONE;
 		}
 	}
 
-	dev_err(mc->dev, "%s %d from unknown irq\n", __func__, irq);
-	return IRQ_HANDLED;
+	dev_err_ratelimited(mc->dev, "%s %d from unknown irq\n", __func__, irq);
+	return IRQ_NONE;
 }
 
 static struct meson_alg_template mc_algs[] = {
@@ -243,34 +244,30 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	if (IS_ERR(mc->base))
 		return PTR_ERR(mc->base);
 
-	mc->busclk = devm_clk_get(&pdev->dev, "blkmv");
+	mc->busclk = devm_clk_get_enabled(&pdev->dev, "blkmv");
 	if (IS_ERR(mc->busclk)) {
 		err = PTR_ERR(mc->busclk);
-		dev_err(&pdev->dev, "Cannot get core clock err=%d\n", err);
+		dev_err(&pdev->dev, "Cannot get/enable core clock err=%d\n", err);
 		return err;
 	}
 
+	err = meson_allocate_chanlist(mc);
+	if (err)
+		return err;
+
 	for (i = 0; i < MAXFLOW; i++) {
 		mc->irqs[i] = platform_get_irq(pdev, i);
-		if (mc->irqs[i] < 0)
-			return mc->irqs[i];
+		if (mc->irqs[i] < 0) {
+			err = mc->irqs[i];
+			goto error_chanlist;
+		}
 
 		err = devm_request_irq(&pdev->dev, mc->irqs[i], meson_irq_handler, 0,
 				       "gxl-crypto", mc);
 		if (err < 0)
-			return err;
-	}
-
-	err = clk_prepare_enable(mc->busclk);
-	if (err != 0) {
-		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
-		return err;
+			goto error_chanlist;
 	}
 
-	err = meson_allocate_chanlist(mc);
-	if (err)
-		goto error_flow;
-
 	err = meson_register_algs(mc);
 	if (err)
 		goto error_alg;
@@ -289,9 +286,8 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	return 0;
 error_alg:
 	meson_unregister_algs(mc);
+error_chanlist:
 	meson_free_chanlist(mc, MAXFLOW - 1);
-error_flow:
-	clk_disable_unprepare(mc->busclk);
 	return err;
 }
 
@@ -306,8 +302,6 @@ static void meson_crypto_remove(struct platform_device *pdev)
 	meson_unregister_algs(mc);
 
 	meson_free_chanlist(mc, MAXFLOW - 1);
-
-	clk_disable_unprepare(mc->busclk);
 }
 
 static const struct of_device_id meson_crypto_of_match_table[] = {
-- 
2.53.0

