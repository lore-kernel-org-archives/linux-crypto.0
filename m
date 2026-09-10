Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC7A471D04
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 11:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039467; cv=none; b=HAn8NQfbTQB+XwFYMhyzxRsPdFLfqJI5+60wJ54k1YQ0s4O6shIAlJ10HObTP7+AN5kcOr/DMKWRyq2SU48Yxt1kScMJtE8ZvY1O+EDV1E+elzS/LQdhDCFrpuUQ9CyVPkXRlYdIwLTIEImZz0LDZbQrH/BYdcCELhFaMZ7UAgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039467; c=relaxed/simple;
	bh=uLHDkONy+KiNWUq7mE9L8IgwyvZNTO3uaZUoWwWk3C4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LNXwU8JeoguMqaRa0bU7tJ9jrvj9Nf5XCSvQ1oJN5yUsMacNsEyPrH5LsNs/RStXkoLlb19/1H/dCeBpuDYNWdcVBK8xwPZr+lHnGKP2nCOcrk5dPSIKF93sBdIFARQO4G/kdgZVyFJAkJkkDJBxXn9GhehWvE1KQAMG2f9SbbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LsRRv3lP; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LsRRv3lP"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747eb79f7so9032595ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 04:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789039465; x=1789644265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0qWBsl55Jcuvgx7Kq+dRwJ1UDbnv4Oi/wL4tnPnY7Gw=;
        b=LsRRv3lPqNljkSRiTeZSw7fHHiQpWHJBmSM4aHI6/7ai4B6ydkcPFZfc7yDQiLl0OI
         jx9gyg4i6Xs4EjRbXOFeEFfH59UaIuuqvPS+3ET0iY5d5BQduO+REA/VPOlv1GtZMIZT
         D05ESvuU9RkPBC0suDLSqqmbo2swX3awkuE7Z0i9trblbTrZ5naTP9kPCmjrlKZXQjkT
         0StcAdFZXmpLzT46TyL75Zv5gFV8uVbZaAI2IMvblPlnrZPn8I4KA2rNHOmMGkFtcpOV
         QMZxc3CxKjKrg3K2r8ViF4tCDYYUO4FMYlM8tZKIU41AQ7c+XJAxx2dXPd+n2B7pP3Pu
         Z5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789039465; x=1789644265;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0qWBsl55Jcuvgx7Kq+dRwJ1UDbnv4Oi/wL4tnPnY7Gw=;
        b=iqTmAmsqXbl2fDoB5RIjO+M8KPYPN6dTawZQQvPwPoNQcTBIAtEzAGJfYTN0frzeLm
         7w5uY0JWdacYK6hhLrGKTsteC8xvDAdElcjkExDGiSuuzqc2gLElfhv34EglKlqSjLIe
         jmfyuGvMowenY+219NxOI4d2lmHW4l0RXXBy1pKriicnM2ym0IPT1vHJgo64gYLjo/lk
         3f2MTsgZLRv90XrPd7pZk7GQO+49zrxjY47peE7dGcswqcGWCSFxZNTXXqziDYUvLjXn
         YXwddcSiIsb1JgtBq4x5oW10vbzpDnfy7GdOla9Qx1AZO8baLzo7Q3rSKHHap7J4YaPS
         S7cg==
X-Gm-Message-State: AFuF++llCmXdns/qgzDKxJhSA2HpEWY1y3G/PbUNDBlWoCQOAYNv3z9y
	leLxhInlUslwCmXHLYty3wuj1ErUf7ykNTUtuq11exojqw8p1GmnxM7AVjaYlS7N
X-Gm-Gg: AYBFou2GcqwBjJeT3KTjG2YSTChSiGD9QzMCQQgJoIbjgJghpUPQMXa+VjciEapiCGH
	I6gjTV+QKui5SP+VnExeA13zI13BC9vxEZNUShFVkC/AV3ma07EK2duAhQeTGiLyaRsfD/51ScF
	ZdeUMxLnaSYPR/x40WPokPEI0KgPnc0Kw7oPu6ZtleQFIHOZL9euyAdoUfDHbJPq5tUPmZ9zpb3
	6oK3k1EZ9vo1Dm4csCRV0KO2Xa04J7NIeTc2+rYuGhRZB6U3xZbdMwZRHPANiGPXrzc8rRTSpKH
	7tn6Dpz3K1hsl7W/p1C0735dM7Bfup9Z4ij9vFh/2LEf5hadDL8uh6vDGmVryjUiyAKHM+GPJSZ
	+fWOydAt3QOh1ZADTyVtHmvd2LDswNz7sAbR+bblVZbDs4+aEmw+aUoLxemt2xSvAo1d6VJcRR8
	zVUUQOijSHSJtYSymC3zbRH/WZT/G36xZJEArXkZGfyOSqEmcp0vR30qVb4zfzqe2AI/cptpHRF
	wZ2yK0O7aNRhgAmOyx79EKqU8H69rR11xshYAQxAg==
X-Received: by 2002:a17:903:3c24:b0:2d9:33d4:a910 with SMTP id d9443c01a7336-2dd0780d87cmr107860155ad.4.1789039465487;
        Thu, 10 Sep 2026 04:24:25 -0700 (PDT)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db2bbcc0c5sm73122895ad.53.2026.09.10.04.24.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 04:24:24 -0700 (PDT)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: dsaxena@plexity.net,
	olivia@selenic.com
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH] hwrng: omap - fix runtime PM and clock leak on EPROBE_DEFER in probe
Date: Thu, 10 Sep 2026 19:24:21 +0800
Message-ID: <20260910112421.39372-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

omap_rng_probe() calls pm_runtime_enable() and pm_runtime_resume_and_get()
before requesting the optional "reg"/functional clocks. When either
devm_clk_get() returns -EPROBE_DEFER, the probe bails out with a bare
"return -EPROBE_DEFER;", bypassing the err_register cleanup that does
pm_runtime_put_sync() + pm_runtime_disable() (and clk_disable_unprepare()).

As a result every probe deferral leaks a runtime PM usage count and leaves
runtime PM enabled; the next probe attempt then hits an unbalanced
pm_runtime_enable(). The second deferral point additionally leaks the
already-enabled functional clock.

Redirect both -EPROBE_DEFER paths to err_register. clk_disable_unprepare()
is a no-op for the NULL/ERR_PTR clocks on these early paths, so the cleanup
is safe.

Fixes: b166be004491 ("hwrng: omap - Fix clock resource by adding a register clock")
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 drivers/char/hw_random/omap-rng.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 5e8b50f15db7..84e2542c570b 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -459,8 +459,10 @@ static int omap_rng_probe(struct platform_device *pdev)
 	}
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(priv->clk) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_register;
+	}
 	if (!IS_ERR(priv->clk)) {
 		ret = clk_prepare_enable(priv->clk);
 		if (ret) {
@@ -471,8 +473,10 @@ static int omap_rng_probe(struct platform_device *pdev)
 	}
 
 	priv->clk_reg = devm_clk_get(&pdev->dev, "reg");
-	if (PTR_ERR(priv->clk_reg) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(priv->clk_reg) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_register;
+	}
 	if (!IS_ERR(priv->clk_reg)) {
 		ret = clk_prepare_enable(priv->clk_reg);
 		if (ret) {
-- 
2.43.7

