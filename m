Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F3E14387F
	for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2024 23:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925224; cv=none; b=eit6mUCr/qAb+khP+N1xFjMv8TbjJEXMAlOeoRcNSN1bb5vz8Q4zlNaoJ2xio+/Bdd1XcSo/mfVY6CRo09EEBPuB2yhgD3lRWmC9xsXMut00e9fRzoyQe9pjtF0xmVHAG25oFTZNj3ZQ98Ur1fK86T3s05XLwMWDGkoIj3klNi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925224; c=relaxed/simple;
	bh=0NJAlAhjPxHb78Pwy3uSoG6ChmdliSLy1tTMW6140b4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpe+6Z/33Mra2LMSnNF9KkbxGZIfvtnH3V1VR7JXeoXlQiAc1nSLTG0myhzD3AFe+m/6ZfGkTeemfivFkQ9b21BkpuM1/UqXSudmATJmfRKa0IQTpq6UgPNruNBkrBYqXjFKUMPVWAao0eTQ4LYbFn00oFs5mCtMwW9I5StsuZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zLoT0FUk; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zLoT0FUk"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3d23a0a32afso684617b6e.3
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2024 16:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718925221; x=1719530021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BATlvT+ON6RviBgwB4syCf5hzbCPLHDaJ0daEPb1cT8=;
        b=zLoT0FUkKhmjWtlgiQeg5Law8XfyukHjyp+Y7PFSXQQAGp+mZdhFd4ltroqv+Wq8V5
         9mfmi4SCqZuswGzfIzZXHpBOuetTwfbr3BOtPjvJhOB3tzIn7sxQPe+Vg8xoOxl+mSmI
         O4/cY2GafsJ83mxjgOCy24HG2JTxyJpAUbYfWUPbr1kRZhQEI43IXxWPdKygWhSuFqjk
         rvZx2DeXuv4Pv3cmv1/H4TLR+VdNnntWL3xdw3Wbd5G5Ei9/LPj/nj8WTlci4DBA3D7i
         J+XuhAYj0T3NTcgnlLUgw7ha/+ELwEAI1PK77owc4BKA8MDHq5IaCnKklERXbCjGaBW2
         wvfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718925221; x=1719530021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BATlvT+ON6RviBgwB4syCf5hzbCPLHDaJ0daEPb1cT8=;
        b=ar0b8BbNZl/UaXG7rYOgd1S83QFCY7Lm4gOeAgRrfy67NAl5YgMy9knYe4dfrDLf6r
         wQAy1KEYPFQWV5202rw2AWvYq67C5640kX1UJ+KtpeFgn+vatKoFgR9WD7CCr6Fkiwxk
         1PjWAU0ZczUMVmVUY6PZ9X+DkVHZk9Y4Jcux+XXRm43dJefl3+5WCOaFc5xeVH+d3kSu
         BlLzO8IkGylT3a2oOJmnNA/g+8a0mYzjw27LLWolZMwno8VXuyZFkHlsOffhulDueUbi
         nFSAMxl5WGPmm7JM7kxxgCVPwPszxJxntvApvFfRgBc5a/wkLcBwQh3j3bekDLLPRmrF
         TMaw==
X-Forwarded-Encrypted: i=1; AJvYcCX+pOhtfxIf4HL3bS6KO5wGFrcScYFdxg3LWS7V0U5M6hlc00MlBsG73CAomX146/a3EeMKS+XRDcyYYWkLGCExAMoQnvmnvhD+mift
X-Gm-Message-State: AOJu0YyCuyuydbd2+BlYZRO9eFJZOJokQyQkbS4Xipi4JiX8blIOCe/T
	zrDnSDDw4CQZwQg+F7Gm4OBrqF7+E5Z7zuwynzhuH10y3M5mrEPs3zI5MC0FA8M=
X-Google-Smtp-Source: AGHT+IEKb6IknyNKfozPN/QAZLLLGaOcrLym6h7VLNCVPFwfAvcGLmQyegTh/tAgk3vnZ27Ac09bFw==
X-Received: by 2002:a05:6808:2391:b0:3d2:2f52:c617 with SMTP id 5614622812f47-3d51baf8f68mr8339992b6e.47.1718925221409;
        Thu, 20 Jun 2024 16:13:41 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d5344de334sm86675b6e.8.2024.06.20.16.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 16:13:41 -0700 (PDT)
From: Sam Protsenko <semen.protsenko@linaro.org>
To: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Anand Moon <linux.amoon@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/6] hwrng: exynos: Improve coding style
Date: Thu, 20 Jun 2024 18:13:35 -0500
Message-Id: <20240620231339.1574-3-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620231339.1574-1-semen.protsenko@linaro.org>
References: <20240620231339.1574-1-semen.protsenko@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix obvious style issues. Some of those were found with checkpatch, and
some just contradict the kernel coding style guide.

No functional change.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
Changes in v3:
  - Added '\n' in dev_err("clock divider too large")
  - Added A-b tag from Łukasz

Changes in v2:
  - Added Krzysztof's R-b tag

 drivers/char/hw_random/exynos-trng.c | 63 +++++++++++++---------------
 1 file changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 0ed5d22fe667..266bdad84f3c 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -23,45 +23,41 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 
-#define EXYNOS_TRNG_CLKDIV         (0x0)
-
-#define EXYNOS_TRNG_CTRL           (0x20)
-#define EXYNOS_TRNG_CTRL_RNGEN     BIT(31)
-
-#define EXYNOS_TRNG_POST_CTRL      (0x30)
-#define EXYNOS_TRNG_ONLINE_CTRL    (0x40)
-#define EXYNOS_TRNG_ONLINE_STAT    (0x44)
-#define EXYNOS_TRNG_ONLINE_MAXCHI2 (0x48)
-#define EXYNOS_TRNG_FIFO_CTRL      (0x50)
-#define EXYNOS_TRNG_FIFO_0         (0x80)
-#define EXYNOS_TRNG_FIFO_1         (0x84)
-#define EXYNOS_TRNG_FIFO_2         (0x88)
-#define EXYNOS_TRNG_FIFO_3         (0x8c)
-#define EXYNOS_TRNG_FIFO_4         (0x90)
-#define EXYNOS_TRNG_FIFO_5         (0x94)
-#define EXYNOS_TRNG_FIFO_6         (0x98)
-#define EXYNOS_TRNG_FIFO_7         (0x9c)
-#define EXYNOS_TRNG_FIFO_LEN       (8)
-#define EXYNOS_TRNG_CLOCK_RATE     (500000)
-
+#define EXYNOS_TRNG_CLKDIV		0x0
+
+#define EXYNOS_TRNG_CTRL		0x20
+#define EXYNOS_TRNG_CTRL_RNGEN		BIT(31)
+
+#define EXYNOS_TRNG_POST_CTRL		0x30
+#define EXYNOS_TRNG_ONLINE_CTRL		0x40
+#define EXYNOS_TRNG_ONLINE_STAT		0x44
+#define EXYNOS_TRNG_ONLINE_MAXCHI2	0x48
+#define EXYNOS_TRNG_FIFO_CTRL		0x50
+#define EXYNOS_TRNG_FIFO_0		0x80
+#define EXYNOS_TRNG_FIFO_1		0x84
+#define EXYNOS_TRNG_FIFO_2		0x88
+#define EXYNOS_TRNG_FIFO_3		0x8c
+#define EXYNOS_TRNG_FIFO_4		0x90
+#define EXYNOS_TRNG_FIFO_5		0x94
+#define EXYNOS_TRNG_FIFO_6		0x98
+#define EXYNOS_TRNG_FIFO_7		0x9c
+#define EXYNOS_TRNG_FIFO_LEN		8
+#define EXYNOS_TRNG_CLOCK_RATE		500000
 
 struct exynos_trng_dev {
-	struct device    *dev;
-	void __iomem     *mem;
-	struct clk       *clk;
-	struct hwrng rng;
+	struct device	*dev;
+	void __iomem	*mem;
+	struct clk	*clk;
+	struct hwrng	rng;
 };
 
 static int exynos_trng_do_read(struct hwrng *rng, void *data, size_t max,
 			       bool wait)
 {
-	struct exynos_trng_dev *trng;
+	struct exynos_trng_dev *trng = (struct exynos_trng_dev *)rng->priv;
 	int val;
 
 	max = min_t(size_t, max, (EXYNOS_TRNG_FIFO_LEN * 4));
-
-	trng = (struct exynos_trng_dev *)rng->priv;
-
 	writel_relaxed(max * 8, trng->mem + EXYNOS_TRNG_FIFO_CTRL);
 	val = readl_poll_timeout(trng->mem + EXYNOS_TRNG_FIFO_CTRL, val,
 				 val == 0, 200, 1000000);
@@ -87,7 +83,7 @@ static int exynos_trng_init(struct hwrng *rng)
 	 */
 	val = sss_rate / (EXYNOS_TRNG_CLOCK_RATE * 2);
 	if (val > 0x7fff) {
-		dev_err(trng->dev, "clock divider too large: %d", val);
+		dev_err(trng->dev, "clock divider too large: %d\n", val);
 		return -ERANGE;
 	}
 	val = val << 1;
@@ -122,7 +118,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
 
 	trng->rng.init = exynos_trng_init;
 	trng->rng.read = exynos_trng_do_read;
-	trng->rng.priv = (unsigned long) trng;
+	trng->rng.priv = (unsigned long)trng;
 
 	platform_set_drvdata(pdev, trng);
 	trng->dev = &pdev->dev;
@@ -175,7 +171,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
 
 static void exynos_trng_remove(struct platform_device *pdev)
 {
-	struct exynos_trng_dev *trng =  platform_get_drvdata(pdev);
+	struct exynos_trng_dev *trng = platform_get_drvdata(pdev);
 
 	clk_disable_unprepare(trng->clk);
 
@@ -204,7 +200,7 @@ static int exynos_trng_resume(struct device *dev)
 }
 
 static DEFINE_SIMPLE_DEV_PM_OPS(exynos_trng_pm_ops, exynos_trng_suspend,
-			 exynos_trng_resume);
+				exynos_trng_resume);
 
 static const struct of_device_id exynos_trng_dt_match[] = {
 	{
@@ -225,6 +221,7 @@ static struct platform_driver exynos_trng_driver = {
 };
 
 module_platform_driver(exynos_trng_driver);
+
 MODULE_AUTHOR("Łukasz Stelmach");
 MODULE_DESCRIPTION("H/W TRNG driver for Exynos chips");
 MODULE_LICENSE("GPL v2");
-- 
2.39.2

