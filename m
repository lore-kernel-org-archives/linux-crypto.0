Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC181B2EE2;
	Wed, 21 Aug 2024 18:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724264024; cv=none; b=GDL5swA4SFWinUtOkq8RpPrcYJCjd4l8S4/fD56AglVXHS4Cx0ffuwPu+rkzpflSdWViCsydX4jdnnqL8CdPH0WoKsYmewKcOKI5EWZzvqf3GgB3MdWrWN9ON2llpAs32XOh9dpd8lWSbL0ypqJ9LrXRO29iCL7+ZmOe4GV9A/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724264024; c=relaxed/simple;
	bh=a8oMqtkelC/jixWzgDqOG+8byLU8ABEKUsQ9l8bCFNw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cQuZIBlG8kcUuP2VB41a8tg/WAD/Z+S8JXQ+ZKQ4/tRiDFxPoqxXoOsSOW5IE/sA8KgGlnWg2onVYKF/VfRWq5iwc00ZOD/Pv48QzyNW/WuPGXaC4bhBxenG9Sws6WLNihEBbM2WM9vOsfD9Y4/rZKsKU3Y0/odLu/Cvlxpeqd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from dslb-178-004-206-174.178.004.pools.vodafone-ip.de ([178.4.206.174] helo=martin-debian-3.kaiser.cx)
	by akranes.kaiser.cx with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <martin@kaiser.cx>)
	id 1sgppQ-00227j-2L;
	Wed, 21 Aug 2024 20:13:04 +0200
From: Martin Kaiser <martin@kaiser.cx>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Daniel Golle <daniel@makrotopia.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 1/2] hwrng: rockchip - rst is used only during probe
Date: Wed, 21 Aug 2024 20:12:34 +0200
Message-Id: <20240821181235.22270-2-martin@kaiser.cx>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240821181235.22270-1-martin@kaiser.cx>
References: <20240821181235.22270-1-martin@kaiser.cx>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver uses the rst variable only for an initial reset when the chip
is probed. There's no need to store rst in the driver's private data, we
can make it a local variable in the probe function.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/rockchip-rng.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/rockchip-rng.c b/drivers/char/hw_random/rockchip-rng.c
index 548e2f4d1490..0dff9de64bc5 100644
--- a/drivers/char/hw_random/rockchip-rng.c
+++ b/drivers/char/hw_random/rockchip-rng.c
@@ -52,7 +52,6 @@
 struct rk_rng {
 	struct hwrng rng;
 	void __iomem *base;
-	struct reset_control *rst;
 	int clk_num;
 	struct clk_bulk_data *clk_bulks;
 };
@@ -132,6 +131,7 @@ static int rk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 static int rk_rng_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct reset_control *rst;
 	struct rk_rng *rk_rng;
 	int ret;
 
@@ -148,14 +148,13 @@ static int rk_rng_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, rk_rng->clk_num,
 				     "Failed to get clks property\n");
 
-	rk_rng->rst = devm_reset_control_array_get_exclusive(&pdev->dev);
-	if (IS_ERR(rk_rng->rst))
-		return dev_err_probe(dev, PTR_ERR(rk_rng->rst),
-				     "Failed to get reset property\n");
+	rst = devm_reset_control_array_get_exclusive(&pdev->dev);
+	if (IS_ERR(rst))
+		return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset property\n");
 
-	reset_control_assert(rk_rng->rst);
+	reset_control_assert(rst);
 	udelay(2);
-	reset_control_deassert(rk_rng->rst);
+	reset_control_deassert(rst);
 
 	platform_set_drvdata(pdev, rk_rng);
 
-- 
2.39.2

