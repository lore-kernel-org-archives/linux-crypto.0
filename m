Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA8D4908D5
	for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787325193; cv=none; b=kahFX9v7sFVHP+qqAsQfdjgscwxvK7JTtevXlfe7Jqc5p8N0/L9d9AP5huOzE0anmJWf3NVXrqA3lNDoWJWR5WFe2EnuHhb7TBqg4woMkycYWY8gkvoRyWlr5Lw9aVLM2cTTIpZ5drMtwEZLU0FqBUap9yfe4r0xCU+ZroMLJMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787325193; c=relaxed/simple;
	bh=4znrndmYCirp6Jd+ENe3pr1q1vEyMeJ/JKR75ZjudZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AUSxYR3XKcIlWg3+qLP5NlLj809+29rjAoKeIvSLEu8uP4C7ye+HZKZ6YnSUYWlLmdqcR3SaozOE1ZS1IvPeiMBoInmo5JPJN0EQ6fJyVII3iIj0mVnpK02PGilDkGOzCUJYdacnR2qW5i8qSG8bwEBvjgLJzLimOdMoAB7CDYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmTTqENC; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmTTqENC"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d5655cc850so14002275ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 08:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787325191; x=1787929991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pNfd98g7NohQi3HTw63l9CeOQLM+iGLJoEq3pvm3KGI=;
        b=jmTTqENC+vD+NxQNYDueZtxq96n5fg+zBAa3loCM+cW0FNLy4XG+XmVwG6K8YuG0T2
         pVH3s6prvlapvUCkHR6AAHmBLPugEL6JMVfiFX+XFwyf9GyZZebgNUPqGM/rQ6VbLNbr
         VdkNtSqT0k2UGTBBTQ4FIJhlVr1CC4Uo9tghaJ13XMxa1VQLp95CBC5VmjwT5QgOLqyj
         PpkpTMdBH0w2GzzD5oaNtgSAyjlNoXFHJWecs4OS8MwGHKSqYKLK6P4pvyzc6QeNtRhF
         o8NUeyzlBW/9LAh7O9M08fJhcmCPwnVXjxPx12eR76BgjIy0eo/JvJsG0/odO2FFPUGL
         s+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787325191; x=1787929991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pNfd98g7NohQi3HTw63l9CeOQLM+iGLJoEq3pvm3KGI=;
        b=m2LiSiw8VKv5ayuEdQfRtSDZC9B05VVEcKveiKRJlZo+r2RIAHwgh6AdGUc4bEfg97
         1X7157I3CI29GbM9HC0Oia/H/OGvccB8207adWTiKTu1Ev+64PriJ+LszsxLiP6XUAJc
         iY86rfcuXQXouRcmDRjPSN1Up2sc4CrW4VrF0T82A+QIx3V8VO9nP/UUDZEhkhVLZKjL
         YQFOApwg1VyvANFbkQi++cTwHib76v7M5+GYFj6czZkqcAYk5i8ooJbPRSpQb7aCqk0+
         uWnRqI4uVOu6jYj4jT+H2J1FLdzvnYB5O9izePHKrCWGOtTy4I3vRWNvS7sEWaoktrHA
         XCKg==
X-Forwarded-Encrypted: i=1; AHgh+RpLNPFTAW/vXtownrccG/9tRcIE40ZiQ7tZLN+miPfmaTmkfpN766s1gdOD6kmHQAzQN2ofHgFk0ftZNQs=@vger.kernel.org
X-Gm-Message-State: AFuF++nzritkZNAX+nCmXJhl4jxOS2bMwxhX68vhSV8dpTNUfsQZp5Dz
	GB8GPOP8I8Ion+1JELulk6+iM2EDuQjUzRBy4lg9HH8gTHzTdlFqkSHx
X-Gm-Gg: AR+sD12MyPpqdOpIJs7PmJ3mmLxGyRV9646H4so2j2sOZVrw6hIwa95KSJCq6w0P/Jv
	uFzqk/gQg7IoJDKQQ0TR6p2z7g2Gpf/wIw4F0tQgAgGHJXrb4YQ7Kg+BuQHqkb4y3MUMDFxL+7d
	EincqY/YXrHg7Vpfe5Ye1MXatMrLBVGJoxFUfbuC2s5U/IQn4yH0wVhZAwxpfDiuBakjb6qhGcX
	lyaYcH3FNiqEexmMub3x2/u9dKQ4V8kGOPknsxkjJ20iBYKyjKuCuj6uf+n8fpQyyj5UTcV6YhN
	OJ7vkgzl+Z76jd/4htwgSM593jK40i095XYJtOujO7n5UH1QxdfdeaLoWDy3cBR+OtZcxNBu8JJ
	YAJIU8zudoZsCqjv8ZX4/bA0bXqr4GlGFvfGPK35RvRu6CwBXrJsRoN0rz7+362Yv2cihzveAZa
	wQ0izFwmowo6X4l1PFbM5Y/Tt5+YXOwbGhMDvhaobK98+njWfMkR+629JHdU7ubEyOWrFLxulCw
	lnq+ALY
X-Received: by 2002:a17:903:390d:b0:2c9:fb11:1bf4 with SMTP id d9443c01a7336-2d64af4eea9mr143169085ad.7.1787325191275;
        Fri, 21 Aug 2026 08:13:11 -0700 (PDT)
Received: from kernel ([103.219.206.63])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62d5912f4sm21059155ad.29.2026.08.21.08.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 08:13:10 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH 2/2] crypto: amlogic: Use devm APIs for clock and engine management
Date: Fri, 21 Aug 2026 20:43:03 +0530
Message-ID: <20260821151303.8150-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the probe and remove function by utilizing device managed
(devm) APIs. Replace devm_clk_get() and clk_prepare_enable() with
devm_clk_get_enabled(), and replace crypto_engine_alloc_init() with
devm_crypto_engine_alloc_init().

This removes the need for manual cleanup in the error paths and the
remove function, eliminating calls to clk_disable_unprepare() and
crypto_engine_exit(). This simplifies the code and prevents potential
resource leaks.

Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 302b398405e2..950735f620e9 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -140,7 +140,6 @@ DEFINE_SHOW_ATTRIBUTE(meson_debugfs);
 static void meson_free_chanlist(struct meson_dev *mc, int i)
 {
 	while (i >= 0) {
-		crypto_engine_exit(mc->chanlist[i].engine);
 		if (mc->chanlist[i].tl)
 			dma_free_coherent(mc->dev, sizeof(struct meson_desc) * MAXDESC,
 					  mc->chanlist[i].tl,
@@ -164,7 +163,7 @@ static int meson_allocate_chanlist(struct meson_dev *mc)
 	for (i = 0; i < MAXFLOW; i++) {
 		init_completion(&mc->chanlist[i].complete);
 
-		mc->chanlist[i].engine = crypto_engine_alloc_init(mc->dev, true);
+		mc->chanlist[i].engine = devm_crypto_engine_alloc_init(mc->dev, true);
 		if (!mc->chanlist[i].engine) {
 			dev_err(mc->dev, "Cannot allocate engine\n");
 			i--;
@@ -244,10 +243,10 @@ static int meson_crypto_probe(struct platform_device *pdev)
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
 
@@ -272,7 +271,7 @@ static int meson_crypto_probe(struct platform_device *pdev)
 
 	err = meson_allocate_chanlist(mc);
 	if (err)
-		goto error_flow;
+		return err;
 
 	err = meson_register_algs(mc);
 	if (err)
@@ -293,8 +292,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 error_alg:
 	meson_unregister_algs(mc);
 	meson_free_chanlist(mc, MAXFLOW - 1);
-error_flow:
-	clk_disable_unprepare(mc->busclk);
 	return err;
 }
 
-- 
2.53.0

