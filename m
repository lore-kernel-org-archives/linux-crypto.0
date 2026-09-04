Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD3144A40F;
	Fri,  4 Sep 2026 10:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788517712; cv=none; b=uoWoyEjFSWpFg1Jl8udECi2YCPIn4SSI9/ZMdazngNemttXYxus3pRgaJiF5VsTx9nuOHCmSGsjAAlbdO9b6A3v0fW7xWeUStnjdj38XVNC/yyZWF+8i+7ZCGuc9Iglt6jLbUc5PxhDKBIIBqrr9JREHkaqPSbOMFOS0fftWPaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788517712; c=relaxed/simple;
	bh=VwG46Gp/XoiLsGNlDYkbSmVmIWuzR2igKIrFYd0lTX4=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=rCHlLWBOl/8kO6t8nK7laV2FuiwzGXO8SGJ48GxwjB7k8oDHkGyOLFBPUtuRUtGS3FOhhcHVEenqi91nsTK5pwt2VS4VIjX0hIvTJVaZv7pgfP7M2Gfv/Z1e8OnSCg7v/PWKJ+z3YBgZ3scC6q0NvINf/i5yPTvQwmUjf8ZzrIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=aIajdNzb; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="aIajdNzb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1788517703; bh=7LEq0udsdRFSQfGgzguwffOKv7bCMQnMZP/17uLi6go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIajdNzbA+5ZKvSm6q1lelyq3zABEFUivSlT64LOCwcHzVFnnMj690RyED/GTQJ0R
	 Ej0NNrkmOC1qXbguIJ54xdMriclIzZ8uoHXKJo/8GXm0PAamq79tMTvB6FxIm0J8Os
	 s2fZAwlSz6ayHJagYZIA9ZN0s7BkTeJIZvS8eT00=
Received: from ws006419.mbzu.ae ([5.195.0.150])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 6BA1EAAE; Fri, 04 Sep 2026 18:26:58 +0800
X-QQ-mid: xmsmtpt1788517618t5vmfugz9
Message-ID: <tencent_0D4EB3807DBF6095A7F5A9455D902DBA9708@qq.com>
X-QQ-XMAILINFO: OFpInORavztRyQdl1JiXuVC0ttpYKudvrsd0yTM3j58+cRNhGtvI0OUgLakqEe
	 XoR1cxEtaMRllVnFD7q1rF8C6oDzmeCTimWdVhGZlRnc8nUnMM2FzdIGJBV32HhLLABdR1J+bolR
	 WYeM1CBOYXKjH3N4yy0xD+3u2TCRWKXXdd2vos4KYSW3K8EyCuArr2pLMMJjicbu4X1h+tkYp0yp
	 PTCfFQfdJfKHyRfqsjAQMrEizvwWg184DajnQgAeQi/L36TQu/ccO9T8fwdSYKN1CLlPxAxBkvZu
	 9NUPsBGNMQ5exD77qOFVPg6e9n+c9UfsxablKEYzNGGBbsIKc07EpS8Hz/2J2nNytefpBguV/c+1
	 e1dRdxT98vZQ3t5M+7vpiStAUUvr0jexLd1rdsBBAVF/JwYc1PocBYY8iTrfNbwr/fJ77WNEGu+i
	 DHNJXysQTpAmSigjMpMgCD/RALMfo+XO+4eKKSGqSHoAJU7Kp3Al+TEgNmKrjbt8FXPL1UiC2wMs
	 GND3ImU11ZogLnl4qUBR9lSPbkTiMCIZo4K9eWCJC79c771iuukw59D5FK3s00IXjzjE2U1Pa+02
	 uAvr3TPsHyYweZV19G2YTr8mZiINnlxh5rweY+bAwXau//yTVdfOZT0nVdxodFcg3KpqsmTbNZIE
	 +l6wBVBBmyzFeXQVtRBV0p9wz/o7YIOBomKhbZ2ujkVwWcVMQR8KzNcipW2mpsRUEUCqv4bvc5Tf
	 OhpMQVlsu6fdze0tgdBUMcwDQZsZrYrPJE+I+vD1UU9DIrsxFkIiRVfEPRym7MHak/mF99bdrlq8
	 9+Al3vkVMX3DYK9XyDtaf4WmDly7NF1CITPy8vn6I822TpHfKCBI36Ssj+++tyBNTazKLahSDda8
	 1/fDiUd+n/q+OI20qDNDF18sEZRSSwQ4jltjKDf685gw4HcLuV3GW0OGa6N79n8MbEfgI2MLnfV7
	 T/Lelf/ZVzZhst5hKi96VsZlnl+/CmMi0qHm+WgdmVgLmW6iE2VSsEPLsVR7l+U1iRkVTLRwONhd
	 IdAIiO/EX+WWgZrgYglxSw4HS1swbXMoOQJZBVR/vdDJvNG4t3gjho6fa8hG86jBCtednP5gXF4R
	 mISGL2
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Jiawen Liu <1298662399@qq.com>
To: Deepak Saxena <dsaxena@plexity.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
	Jiawen Liu <1298662399@qq.com>
Subject: [PATCH v2] char: omap-rng: fix runtime PM cleanup
Date: Fri,  4 Sep 2026 14:26:54 +0400
X-OQ-MSGID: <20260904102654.394495-1-1298662399@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_1DBD00BAFF365506D40F166D40DEE8F63B0A@qq.com>
References: <tencent_1DBD00BAFF365506D40F166D40DEE8F63B0A@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

omap_rng_probe() enables runtime PM before requesting its optional clocks.
If either devm_clk_get() returns -EPROBE_DEFER, the direct return leaves
the runtime PM usage count elevated and runtime PM enabled. The second
clock lookup can also leave the first clock enabled.

Route each deferred-probe path through resource-matched cleanup. Return
directly after cleanup so normal probe deferrals remain quiet.

Fixes: 43ec540e6f9b ("hwrng: omap - move clock related code to omap_rng_probe()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Liu <1298662399@qq.com>
---
Changes in v2:
- Use the full author name in From and Signed-off-by.
- Return directly after deferred-probe cleanup to keep deferrals quiet.
- Add Fixes and Cc stable tags.

v1: https://lore.kernel.org/all/tencent_1DBD00BAFF365506D40F166D40DEE8F63B0A@qq.com/
Sashiko review: https://sashiko.dev/#/patchset/tencent_1DBD00BAFF365506D40F166D40DEE8F63B0A%40qq.com

 drivers/char/hw_random/omap-rng.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 5e8b50f15db7..c22d70a031e2 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -459,8 +459,10 @@ static int omap_rng_probe(struct platform_device *pdev)
 	}
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(priv->clk) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_pm_runtime;
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
+		goto err_pm_runtime_clock_1;
+	}
 	if (!IS_ERR(priv->clk_reg)) {
 		ret = clk_prepare_enable(priv->clk_reg);
 		if (ret) {
@@ -497,6 +501,16 @@ static int omap_rng_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_pm_runtime_clock_1:
+	if (!IS_ERR(priv->clk))
+		clk_disable_unprepare(priv->clk);
+	goto err_pm_runtime;
+
+err_pm_runtime:
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	return ret;
+
 err_register:
 	priv->base = NULL;
 	pm_runtime_put_sync(&pdev->dev);
-- 
2.34.1

