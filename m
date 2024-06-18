Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB88199B0
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 00:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671071; cv=none; b=JJHAq3OcRh89bpRf1DE5AxC5TXtCnragpxfGTALBWyodiO1lqC/t47exIHuAtlmSgUN21o9D6HytO8RvGiK4cShwtfZxkgvAKod8Acm4FsF+9Sgw2W/tGReGf4Gr0XXxWRO5hjyWf2BgKrsn5uu2ow+q864Wq4cdoZKE1Uih+IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671071; c=relaxed/simple;
	bh=wlWzDxin5qYXlpQazrMup6eynq5pG66YPpoBw8a9PUg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U5vSBsubLTzKtWU51fQ6786OIvaY8KHRQtZof7QA41e+ZrScC+I8wTRREoCyQyFJDtemtJkq/Wzy44fSHQ22LQNGgss7/NMNhQTFb07RZ2cNrnUKV24UoAHkbIRaOt59kLNmjRIIWWZrqp5Rt2p1MiwK4TPXrgYb2e5+bmYtKeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WFA8rj14; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WFA8rj14"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6f8d0a1e500so3684628a34.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 17:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718671067; x=1719275867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HF3yj9NB+f1P6unzjOcT62NKC0TjmglEhNnCfK/YhxY=;
        b=WFA8rj14LtNgzPrQAwBF4lct3zT3G8IsQy8ljY4m6W09oEsYNwX8dPxozjFE5ykh3/
         UqulAJfowebDYLub9LzsvC9LEPRQVkGQW+V87q/SqBrUL70lI6HQhA5rD8Q3+4bljkr/
         XlLPOcFTn7fXwTpgGWEW3Y6lYSCmPdVG7OI8vaWX5KNEf8rvkXMNtI4ogri01MhdQb3n
         vYKtkO5a2LwfZDIHq5ubTE4e6cJr9CQ684HosuaVd00+ZnHmGeDY1aOFbNV48PVInYYc
         t3HGinQmk3JRVEIUl0BToEqA1e5bxL/dY/NiJgv/AKgHrN6Aus4NEPfFyTiLQ+dJj26j
         rA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718671067; x=1719275867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HF3yj9NB+f1P6unzjOcT62NKC0TjmglEhNnCfK/YhxY=;
        b=HUyFCUdTRSVayfC4oCPGP/883YVTxLGqb/CtU1dd1v2ehtOCA9jrUUt5V1eKZcK4S3
         SfHCmhUarluWcD4hasCeciwAxpkRNq4DZs0CYDEb+QD6qnAzrnRElfR+lsS2dTcEW2lg
         XCOBR0+WTT0hSzgYpmSPlkE7wp2UY6nHwM2IZsQK/8VY/PwlbsRptISpphB/tPjunhR3
         RJw/dIyfuxz/31No0vfJguPINjj62usm+fhyrt3cu2CPwtk0zqL2E5V+hIgg/yFDzgXz
         d8Resn1ZIyclIOJAg9S5yfTqE92AkqBDZkRyemnNPiqE2JQNkJaRKzO/i6GP0TPeTR7R
         ciqw==
X-Forwarded-Encrypted: i=1; AJvYcCXBpIP65qVJVIbqiL20xpEL3B8pXpuMhdxF/ks10vpE0fVzrZUcG0A62knAd+VAsGTQofx0SYvkXwJ+ANaERNray+tZkfp5VixAI60N
X-Gm-Message-State: AOJu0Yxw/PRt9lqQRu68exaCIk57M2QAdvmhlMKk6MtkdgbCafBKrsg/
	zZLLf5BgFu0y6jaT9X/81sEKfkMyC3zN4Ztk0iAto3owHUZXxeOhdYsuRvnb1GU=
X-Google-Smtp-Source: AGHT+IHKCaUtR8KPhYQJdoRvRQDarGdrRA43rA9XABMCQXk9wPvcC+mPa8iPETKzce2FCdEkupbjPA==
X-Received: by 2002:a05:6830:1be2:b0:6f9:ce8e:5da1 with SMTP id 46e09a7af769-6fb9364aa32mr12434212a34.26.1718671067124;
        Mon, 17 Jun 2024 17:37:47 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6fb5afab833sm1686856a34.10.2024.06.17.17.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 17:37:46 -0700 (PDT)
From: Sam Protsenko <semen.protsenko@linaro.org>
To: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] hwrng: exynos: Add SMC based TRNG operation
Date: Mon, 17 Jun 2024 19:37:41 -0500
Message-Id: <20240618003743.2975-6-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240618003743.2975-1-semen.protsenko@linaro.org>
References: <20240618003743.2975-1-semen.protsenko@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On some Exynos chips like Exynos850 the access to Security Sub System
(SSS) registers is protected with TrustZone, and therefore only possible
from EL3 monitor software. The Linux kernel is running in EL1, so the
only way for the driver to obtain TRNG data is via SMC calls to EL3
monitor. Implement such SMC operation and use it when QUIRK_SMC is set
in the corresponding chip driver data.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
---
 drivers/char/hw_random/exynos-trng.c | 130 ++++++++++++++++++++++++---
 1 file changed, 120 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 4520a280134c..98b7a8ebb909 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -10,6 +10,7 @@
  * Krzysztof Kozłowski <krzk@kernel.org>
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/clk.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
@@ -22,6 +23,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/property.h>
 
 #define EXYNOS_TRNG_CLKDIV		0x0
 
@@ -44,16 +46,40 @@
 #define EXYNOS_TRNG_FIFO_LEN		8
 #define EXYNOS_TRNG_CLOCK_RATE		500000
 
+#define QUIRK_SMC			BIT(0)
+
+#define EXYNOS_SMC_CALL_VAL(func_num)			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+			   ARM_SMCCC_SMC_32,		\
+			   ARM_SMCCC_OWNER_SIP,		\
+			   func_num)
+
+/* SMC command for DTRNG access */
+#define SMC_CMD_RANDOM			EXYNOS_SMC_CALL_VAL(0x1012)
+
+/* SMC_CMD_RANDOM: arguments */
+#define HWRNG_INIT			0x0
+#define HWRNG_EXIT			0x1
+#define HWRNG_GET_DATA			0x2
+#define HWRNG_RESUME			0x3
+
+/* SMC_CMD_RANDOM: return values */
+#define HWRNG_RET_OK			0x0
+#define HWRNG_RET_RETRY_ERROR		0x2
+
+#define HWRNG_MAX_TRIES			100
+
 struct exynos_trng_dev {
 	struct device	*dev;
 	void __iomem	*mem;
 	struct clk	*clk;	/* operating clock */
 	struct clk	*pclk;	/* bus clock */
 	struct hwrng	rng;
+	unsigned long	quirks;
 };
 
-static int exynos_trng_do_read(struct hwrng *rng, void *data, size_t max,
-			       bool wait)
+static int exynos_trng_do_read_reg(struct hwrng *rng, void *data, size_t max,
+				   bool wait)
 {
 	struct exynos_trng_dev *trng = (struct exynos_trng_dev *)rng->priv;
 	int val;
@@ -70,7 +96,40 @@ static int exynos_trng_do_read(struct hwrng *rng, void *data, size_t max,
 	return max;
 }
 
-static int exynos_trng_init(struct hwrng *rng)
+static int exynos_trng_do_read_smc(struct hwrng *rng, void *data, size_t max,
+				   bool wait)
+{
+	struct arm_smccc_res res;
+	u32 *buf = data;
+	unsigned int copied = 0;
+	int tries = 0;
+
+	while (copied < max) {
+		arm_smccc_smc(SMC_CMD_RANDOM, HWRNG_GET_DATA, 0, 0, 0, 0, 0, 0,
+			      &res);
+		switch (res.a0) {
+		case HWRNG_RET_OK:
+			*buf++ = res.a2;
+			*buf++ = res.a3;
+			copied += 8;
+			tries = 0;
+			break;
+		case HWRNG_RET_RETRY_ERROR:
+			if (!wait)
+				return copied;
+			if (++tries >= HWRNG_MAX_TRIES)
+				return copied;
+			cond_resched();
+			break;
+		default:
+			return -EIO;
+		}
+	}
+
+	return copied;
+}
+
+static int exynos_trng_init_reg(struct hwrng *rng)
 {
 	struct exynos_trng_dev *trng = (struct exynos_trng_dev *)rng->priv;
 	unsigned long sss_rate;
@@ -103,6 +162,17 @@ static int exynos_trng_init(struct hwrng *rng)
 	return 0;
 }
 
+static int exynos_trng_init_smc(struct hwrng *rng)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_smc(SMC_CMD_RANDOM, HWRNG_INIT, 0, 0, 0, 0, 0, 0, &res);
+	if (res.a0 != HWRNG_RET_OK)
+		return -EIO;
+
+	return 0;
+}
+
 static int exynos_trng_probe(struct platform_device *pdev)
 {
 	struct exynos_trng_dev *trng;
@@ -112,21 +182,29 @@ static int exynos_trng_probe(struct platform_device *pdev)
 	if (!trng)
 		return ret;
 
+	platform_set_drvdata(pdev, trng);
+	trng->dev = &pdev->dev;
+
+	trng->quirks = (unsigned long)device_get_match_data(&pdev->dev);
+
 	trng->rng.name = devm_kstrdup(&pdev->dev, dev_name(&pdev->dev),
 				      GFP_KERNEL);
 	if (!trng->rng.name)
 		return ret;
 
-	trng->rng.init = exynos_trng_init;
-	trng->rng.read = exynos_trng_do_read;
 	trng->rng.priv = (unsigned long)trng;
 
-	platform_set_drvdata(pdev, trng);
-	trng->dev = &pdev->dev;
+	if (trng->quirks & QUIRK_SMC) {
+		trng->rng.init = exynos_trng_init_smc;
+		trng->rng.read = exynos_trng_do_read_smc;
+	} else {
+		trng->rng.init = exynos_trng_init_reg;
+		trng->rng.read = exynos_trng_do_read_reg;
 
-	trng->mem = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(trng->mem))
-		return PTR_ERR(trng->mem);
+		trng->mem = devm_platform_ioremap_resource(pdev, 0);
+		if (IS_ERR(trng->mem))
+			return PTR_ERR(trng->mem);
+	}
 
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_resume_and_get(&pdev->dev);
@@ -190,6 +268,13 @@ static void exynos_trng_remove(struct platform_device *pdev)
 {
 	struct exynos_trng_dev *trng = platform_get_drvdata(pdev);
 
+	if (trng->quirks & QUIRK_SMC) {
+		struct arm_smccc_res res;
+
+		arm_smccc_smc(SMC_CMD_RANDOM, HWRNG_EXIT, 0, 0, 0, 0, 0, 0,
+			      &res);
+	}
+
 	clk_disable_unprepare(trng->clk);
 	clk_disable_unprepare(trng->pclk);
 
@@ -199,6 +284,16 @@ static void exynos_trng_remove(struct platform_device *pdev)
 
 static int exynos_trng_suspend(struct device *dev)
 {
+	struct exynos_trng_dev *trng = dev_get_drvdata(dev);
+	struct arm_smccc_res res;
+
+	if (trng->quirks & QUIRK_SMC) {
+		arm_smccc_smc(SMC_CMD_RANDOM, HWRNG_EXIT, 0, 0, 0, 0, 0, 0,
+			      &res);
+		if (res.a0 != HWRNG_RET_OK)
+			return -EIO;
+	}
+
 	pm_runtime_put_sync(dev);
 
 	return 0;
@@ -206,6 +301,7 @@ static int exynos_trng_suspend(struct device *dev)
 
 static int exynos_trng_resume(struct device *dev)
 {
+	struct exynos_trng_dev *trng = dev_get_drvdata(dev);
 	int ret;
 
 	ret = pm_runtime_resume_and_get(dev);
@@ -214,6 +310,20 @@ static int exynos_trng_resume(struct device *dev)
 		return ret;
 	}
 
+	if (trng->quirks & QUIRK_SMC) {
+		struct arm_smccc_res res;
+
+		arm_smccc_smc(SMC_CMD_RANDOM, HWRNG_RESUME, 0, 0, 0, 0, 0, 0,
+			      &res);
+		if (res.a0 != HWRNG_RET_OK)
+			return -EIO;
+
+		arm_smccc_smc(SMC_CMD_RANDOM, HWRNG_INIT, 0, 0, 0, 0, 0, 0,
+			      &res);
+		if (res.a0 != HWRNG_RET_OK)
+			return -EIO;
+	}
+
 	return 0;
 }
 
-- 
2.39.2

