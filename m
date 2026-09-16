Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC69F4D794C
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 15:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789573797; cv=none; b=PE0p8/2i9+tB9W86REr3fKoS0fziuMdC11Lcp94RgkWuNe5wyWvcWUmTJ14FlSUGlQFxD6tfWyXT6E4aJll5rY/OLc91YpDGt3B1Sr9Lrk0vrrf1Rx10gSFQnC7Ulk2CZoOxyh9JFFh3DF4hCujVLgZpMfDAFTNlvssNcv/0hHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789573797; c=relaxed/simple;
	bh=HLDCXegOyd54ksDVqnMJgvrMjU4iOiyP5Lz7wYJEsn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eArYrsSoBz44ug2g+735YxkIYD7X5b35atj7DKau0y9bp2UudwNqy/OPveGCpZK583A4iWCLNxTZUNfNfx5D7Sib6KXobeaYqIDtNebdsMgzKt5/hwP2nk6SgfzEtQPrRETxqeQlqoC/sUt7SeJIlU5d1o1RyktYltAwoqk0+/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WIPGPO30; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WIPGPO30"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-398beb616f5so418187a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 08:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789573793; x=1790178593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XIWCqUJ30TP1pyF27y3sPeUzqO5qqMNYk7Psxgwew+I=;
        b=WIPGPO30SVxlFYxBAgSuF88CCgTKSpReIkG5fNdK+nqvMhCwACD5GXHjwkMKkgcxRv
         /AFNnp2BWvuiU8QrUmJ9bfUfK1JKYMRboYwJyRjmo6pgcxR53XbciNpeZLx1fgSztAIc
         6VIE/Kg/TtSJK8+NZ/S3CJEFs2rcpJYVeyXAFh+Q/5eU1RPQPpJY+Tw6RMI0u9PTavPd
         89ZHtZQ46doyvdaR6Nb97oiStHBhJZcbrARRGBKvRvlXS16zEHuI7LgWVzuM4yECKr9d
         7oyL+ARsShawLcAEE1/jKWSQGAx+OMP4Uei0ov9cyY6q6fXjYDBwyHN7Uc1REnx4Nl0t
         URDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789573793; x=1790178593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XIWCqUJ30TP1pyF27y3sPeUzqO5qqMNYk7Psxgwew+I=;
        b=GVqvL3tuyfzHkz/PuF2ebMMG6PLBiQ7yS7GiRVNXjLfsnnII+MdgEkiZksZdpafiXG
         8vc2A1+HjuyI/XmtDTOnN0ajH7kBSYsOpX+MuPURyqbmDWLIs4MC7ih/uWfjuaI5Y9oy
         gzYw0NzqOY9Wkt1/J13uJjBTu6WRG8S9aMTRC+qnEE78UwiS+UkikFURBWJudK4md8CZ
         Xz5GEd9pSPCOtCU6cTeNwoVIzz5vCaflFQWAYDoY2GALqUQsD2oPrrnOzJGf7f6ft96Z
         5TbQAS2HcRYS8nuM7+DGEvLRO3ebjFjedKPqF4EFrUBOHmsxsTq9lPCh0yBOaeskDnRq
         3Q8Q==
X-Gm-Message-State: AFuF++mlNPop7FYqo2OzArotsZ9Lob/xG2KAaU3m8gX/nXGGmyw2f0Zu
	TcXgLx2yIRWQRtLYF8zIyEA47g61i6vop9S2rdB98wvXLlqPbLjJecgZ
X-Gm-Gg: AYBFou3IFjb58PVFWEfefoMIzn3UoXtOT3y1S7KOH4tuFxkpxhXl+blGn0ykMvLCIlN
	NYETvhBbfW8h7WavuJ4jSqqMJPiRW/D3tzF0nsc1ylPFUF+EebSDlqjG9jegbn7Y8pexRHC8YaJ
	DmZVN0vx+6I0+Oc4C9Q7a95r3AlxMZrckkfkdJ/78jAGO/9ATLpptiq/iZdFVZC2j5yvMV9V9OE
	0se/sM3RweVmhkp/pPR4O3NLkhApXjtqPaElkFIGL/cGe2HNnQc5BplxQWi/CwIyjJrdI7bhSJK
	FFtVzsBJ+GYkY9lkypMMyrkLMWlfmJtrrb6OJroQuYMvQEC3tg4lZTHsNPzHc8ao6OzK+J8+23C
	IGhtZsi2L3UasWZrAVI2NX9NLw9gRYmbXphOgNBPxURsxbQS1t3sWGMLIlRe+kAF+bvR+6Z7Qdy
	wb2QToNteftNT42oobJJOvV8tj2fs07z8MNa3xop0+EiGQ4jDi5Ce63w7hfJXZxksx+rj3TvDif
	OhDyFTe9we4ILVWsw==
X-Received: by 2002:a17:90a:d446:b0:39d:feca:f48d with SMTP id 98e67ed59e1d1-39e35daaa88mr113481a91.3.1789573792950;
        Wed, 16 Sep 2026 08:49:52 -0700 (PDT)
Received: from kernel ([45.251.35.123])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35dab2e9sm142687a91.1.2026.09.16.08.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:49:52 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: herbert@gondor.apana.org.au,
	clabbe@baylibre.com,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	jkoolstra@xs4all.nl,
	lkp@intel.com,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH v3] crypto/amlogic: Use devm APIs for clock management
Date: Wed, 16 Sep 2026 21:19:41 +0530
Message-ID: <20260916154941.7254-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver currently gets the core clock and manually enables it using
clk_prepare_enable(). This requires matching calls to
clk_disable_unprepare() in the error paths and remove function.

Switch to devm_clk_get_enabled() instead. This lets the kernel handle
enabling and disabling the clock automatically, which allow us to drop
the manual cleanup code and keeps the probe function simple.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608310329.QgxCCMs1-lkp@intel.com/
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
Changes in v3:
- Moved IRQ requests after channel allocation to fix a null pointer
  derefernce and use-after-free.
- The IRQ return value issue is fixed in a separate patch [1].

Link to v2: https://lore.kernel.org/all/aqpmOzURNFOm78ls@gondor.apana.org.au/T/
[1] https://lore.kernel.org/all/20260908160120.4805-1-raizudeen.kerneldev@gmail.com/

 drivers/crypto/amlogic/amlogic-gxl-core.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 169c6eeb51e5..d2d23a443c53 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -243,13 +243,17 @@ static int meson_crypto_probe(struct platform_device *pdev)
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
 
+	err = meson_allocate_chainlist(mc);
+	if (err)
+		return err;
+
 	for (i = 0; i < MAXFLOW; i++) {
 		mc->irqs[i] = platform_get_irq(pdev, i);
 		if (mc->irqs[i] < 0)
@@ -261,16 +265,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 			return err;
 	}
 
-	err = clk_prepare_enable(mc->busclk);
-	if (err != 0) {
-		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
-		return err;
-	}
-
-	err = meson_allocate_chanlist(mc);
-	if (err)
-		goto error_flow;
-
 	err = meson_register_algs(mc);
 	if (err)
 		goto error_alg;
@@ -290,8 +284,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 error_alg:
 	meson_unregister_algs(mc);
 	meson_free_chanlist(mc, MAXFLOW - 1);
-error_flow:
-	clk_disable_unprepare(mc->busclk);
 	return err;
 }
 
@@ -306,8 +298,6 @@ static void meson_crypto_remove(struct platform_device *pdev)
 	meson_unregister_algs(mc);
 
 	meson_free_chanlist(mc, MAXFLOW - 1);
-
-	clk_disable_unprepare(mc->busclk);
 }
 
 static const struct of_device_id meson_crypto_of_match_table[] = {
-- 
2.53.0

