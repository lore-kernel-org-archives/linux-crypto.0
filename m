Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB40D10A1A
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 00:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671070; cv=none; b=S2C+WDLuk7wEvfzyP/cfhoHYuDnWyvEjbN8mPyz5tuL4ctVqiU39qYlJz5fkVd5kpsesWYHIe0TMblYe6I5Fupfr24cw0Gr+xcXXLZWI5LMhv7ci+aocGnqta9BHEazv+AKbgvTgi+ZsWlzSBLov+AczuZf5py5KgMNiBG1LCYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671070; c=relaxed/simple;
	bh=147GziLrLX4hdx/jk6i77bJo/QV+4RX4Z3/r1jgnsUk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oHHHRBvUn4iilZlVihrJUX4POcpn6B3SO6F8gSJ5sGtG8BIS6s/LVWfkmHb9pqjM4s7uZAmHbM8gdo4fw9/CvZpKuTZB+LNvfHac1N/3EHExcmloTFqxhFFNSxJQwijQP3jXjMQARTonfqZ3vsEp5ipmr85Wzhwu2qK70JsZhCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FmvKCRLS; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FmvKCRLS"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6f96f8489feso2762077a34.0
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 17:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718671066; x=1719275866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K0nRAEwRS+Kqa+xFeL/UdK1/42jrpGZZ3oW8XiNINwY=;
        b=FmvKCRLSpPZUuqMdd4YvMJHF6FQv6vOAqWRdWJuEOlwyuXukmk41d57if6bSs/Jl8K
         x7HXDY413PBCmrDUvfZO5haBLmK/AniB3cxcGoXvYj/yA8a8fR07VQsotiP3tS4C+t34
         oOSuL1b1Q/5Q01qzwtAThgrF5PQcT3/7Fy5uoIIzEgQEycd4ai0KrZQ5OrFUsXHoiEU8
         82AlZXQv7FzntktB/ZxEOArnsyyMr02hgECo4gBmlMwkjhGI4gXoxuEztT78uWIdc3uY
         ox9y0NrKpAXGjPOHs85Pcuy0DGd7fz9FCTsFuRnjziqINflGtyhLnAfVg53Qlo+jNAta
         ZGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718671066; x=1719275866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K0nRAEwRS+Kqa+xFeL/UdK1/42jrpGZZ3oW8XiNINwY=;
        b=DoRBSob3S2dSaW1cO2rjkHgUel6v9t5QCTixac5dauZCSoJwnhpAL5L47BivGydSe3
         RBsCYWUDhT9mFHA86Bi/Obbhj5hDqp0/R4zdb5KxC/pnvhNOtqE3V/ASCcfwJpz2nLdi
         RG1z0BOWC4CmcsXbCG49xZLs/Ffz/91LCSX4T9kCQveGYciS/c2CHVIJlH0Ylb1eSHPM
         rUQ+NBQA11N5tPC/CAIA/GkMol9CTNDjWdbeYcULIFOX6ngLpAzSvTQqdQHkhwoQvy+f
         iurJBkWcSy/HWJMX3KcoHi5V0iU1NaecWLQxneGxdnThSFOjeBO1CgJNhfV7DWDJWsyR
         WSPg==
X-Forwarded-Encrypted: i=1; AJvYcCX4Y28ztNvLX+VZZYUCPI3doZivvshj/WwIEn4TRNAm0kiT5U5crldCsEKiPUg8a9HnGnGyyTV0HL0V3Ed+9t3z1FMLFfpW8pxCxLS0
X-Gm-Message-State: AOJu0Yx7NKyNjm8kyKnOaejdQSW5W+V0kKXzBmki1uIWJ3F+L+RLPtr0
	sRLP6MJpvGzjD9PKSo2NbrkJ2rL22CsUrQHNxhEDmQzoedfy7kd5jgpARuAMttAoQvjiPZagqAC
	IUeA=
X-Google-Smtp-Source: AGHT+IGJdLC4WFJwxFevTuE9JllHcgHxe3B4leT9QNXKwBCjfTWKffWwR3974mIIt9gULbt3K2lVdg==
X-Received: by 2002:a9d:66c7:0:b0:6f9:6f4b:f5ce with SMTP id 46e09a7af769-6fb93297d78mr12526107a34.8.1718671065819;
        Mon, 17 Jun 2024 17:37:45 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6fb5b1eb6c8sm1738540a34.43.2024.06.17.17.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 17:37:45 -0700 (PDT)
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
Subject: [PATCH 3/7] hwrng: exynos: Improve coding style
Date: Mon, 17 Jun 2024 19:37:39 -0500
Message-Id: <20240618003743.2975-4-semen.protsenko@linaro.org>
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

Fix obvious style issues. Some of those were found with checkpatch, and
some just contradict the kernel coding style guide.

No functional change.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
---
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

