Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C968A1741EC
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 20:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718743529; cv=none; b=NsTTlFnU8ObiPiHUwerCErq0/XbkFHao1hQNBaTgGUMyP1z6LdvBaTrYdOaFPM3G7p51yfWUu5liIfaO32Nn8Of4ltfGbLXKMmrWnDzJtKKxmkEGL03+5T3OCwz8EtoEmVdQQJ/pwKDYVJXlgNXsit3e97sWNMGPxJTWvfW4YPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718743529; c=relaxed/simple;
	bh=5evvsN4at6BMrRF8OVlHRN4HocF8R+R/ozNBsMGh+IY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R08R6zZtoFlgxuJ6JHgCa9Xi+L03s8kRFYAXeR33concwoM7I8+9xjgRVOEtlz/AsC+VeW1NnYdwrYUsG4n2EfEsVTVwbST8KXRQQl0LEPT0WTFnXxfTvIdsFiin7iInr62X+iyTeSLRNdA3mNJ9SHwHBYI/NH21xH6QOh3Z5CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=P+u5z204; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P+u5z204"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5bdbbc37664so2842184eaf.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 13:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718743526; x=1719348326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1x8MC9aiceHsiOgibtWuSN+CH2pLi0RJoi6RQX0En0=;
        b=P+u5z204Qbm0CSzbkkRSSWm6QgaoJEiCADHtZd2mJpGxmAZbnuOn8GQl4y+vhV0l1M
         Rj/MC9pP0HKEWkM9KS7cl/2TVQOtMVglIb/LasirBhpglfUZSqSy5OlP5Dj1uULziVkq
         OVVygyqtxjnBwDJCOdpMb8r1WSO64izFnXGuOeQMXo1Z4OWOOHj1DmqVkjYaqydG055o
         8iGVCYECz4n2BaxdqPCtkNa49Jh7LKY9Trkpzq+7B2P47gMbCQhf71gjvd2ZWv63dwSv
         sOjtDnrl8PO2Bs32WxwY9OA0PhAo3cqxGdIWI19U1K6XubI7jthFN9YcIWMsSsmRGryR
         E0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718743526; x=1719348326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/1x8MC9aiceHsiOgibtWuSN+CH2pLi0RJoi6RQX0En0=;
        b=KNhaiVAylkchm8sWu1+GQ4n3psDg3E11k6AvWTrYry0yTp+o4pWMF9LvMMiuXwUeit
         2+qxUt0Wpde2Jrs4kB4J8T9iGeiX5XWMMaixPIz0qGCWeieHtcpZT3oFNh4IgKnwRDAb
         4fr522lRPCuNWggJSLTnd9YQlR6qJ+EhbhvNDbePbuEFHKXpMjpofxhQ5eCZ8KZkzQ80
         5MyrD0avklnGUSgTxFw8evw13ShE1E4m+12WtkFfpk8nNQzNS0geA/jViNZYr1SJjvbD
         iXW/niqVvBcB2q10Pk1n58zrj57M22XmfKGpEBh0fGjg7CiBTa2dGOgrqXRdVgij011j
         M0Ew==
X-Forwarded-Encrypted: i=1; AJvYcCVrtf5PxMjiKN50z+Wzng2r12YF+eQT4MqEpM+MwfOjBCKX5Q4Gy7/mkHfupLA9Lff11jLNl3boEgw5xF+aEZQK50yRQjsaLVVBpTYs
X-Gm-Message-State: AOJu0YwMmxOPbDO21x0EG9QP4fKG2dHT441tj6+mjNSMImliTL0SwJIo
	QjTuva2SdFo5A9ue5Rlh5rwnxUjRZr9o1QB0DfYa44ciVP3P2EmOzJGzSnZllaE=
X-Google-Smtp-Source: AGHT+IHoIqS42kE6h2gsiMCU58NN0xvPF/vSFb4SrpjHZNqEyhPtxGPcglOULs7EmkuqnqSorllKtg==
X-Received: by 2002:a4a:240f:0:b0:5c1:a296:66b5 with SMTP id 006d021491bc7-5c1adc0715emr917189eaf.9.1718743525910;
        Tue, 18 Jun 2024 13:45:25 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5bd5f2a1801sm1432107eaf.37.2024.06.18.13.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 13:45:25 -0700 (PDT)
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
Subject: [PATCH v2 2/7] hwrng: exynos: Improve coding style
Date: Tue, 18 Jun 2024 15:45:18 -0500
Message-Id: <20240618204523.9563-3-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240618204523.9563-1-semen.protsenko@linaro.org>
References: <20240618204523.9563-1-semen.protsenko@linaro.org>
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
---
Changes in v2:
  - Added Krzysztof's R-b tag

 drivers/char/hw_random/exynos-trng.c | 61 +++++++++++++---------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 0ed5d22fe667..88a5088ed34d 100644
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

