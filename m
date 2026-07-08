Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088A043F4A7
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 11:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783509421; cv=none; b=qP6pR5arLzBEiBu+d8P15aVJ+KWJcViVm1+vEgJD1zycMscGFK0VC0mUeUz5rqk76fW/JCRLasGxBdk4D3Gm0lEq73yfHl2B+oK3i0DvFWMPLZWAhsC1bTmQml/5QDEPhamRtbFnPgixg3HIG49kL0TCFPUa2R6QJOmLPI+ymX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783509421; c=relaxed/simple;
	bh=J3BCIbaF8e4vQqw/PDZunyp9IDodwLegq1o3eYSO0mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KdC65EDT1jdll1mzEXwr1dujvgZy2RkHQdDdOJbn9vzJd1AkG1e1nWvoU9id7weOvX4a4SHWto3e4uYjU2QnRtc1SBQcsG54RCWNlUG4prMW9IG4rMvvfHltJcWmEYUm/VMzNpDbuIq+zO+QcHqPfdroGLdLdreIYZcwM3NFMS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=TbVh9Fmw; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="TbVh9Fmw"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-475881b9a4bso487435f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2026 04:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1783509414; x=1784114214; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gH6dydwyPFNhRyuhfNaMmzRjgqUkiRmdKn131qVwoZk=;
        b=TbVh9Fmw7fn1qHczBSELWxWoK6CYmKRUkhPLn2uETmcxm2VHoiM4weFe74Yoc2BD4x
         eH9na7d0DucbJ4OS7YQ0imLPa0JXRfTKJxm6CKZukqW8+hZtjAPpf6xvKxDH1ib/upeE
         Jy5klAp/uDayy9JUPZfkCYv6CDjmnisWmpeD0kXuW1REtnXnl4pGG+vUYDW7brkORqY6
         N6lAu0OKPZ+kcazdAABKS/bkynHnRYqiNSW9AHSxYncPHiMa7oOJZb+fe5cl+KWqKxH/
         YbXQTjWP/Axo56TpSZTNA1SsGO5HidQF+7yBlQTeGpKVmaH/GO34+dzOAmjqEdcdJp3x
         kX4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783509414; x=1784114214;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gH6dydwyPFNhRyuhfNaMmzRjgqUkiRmdKn131qVwoZk=;
        b=O/yT93psq9iuqhEpBymXz3JJfQlcA3WQj01ZJoqqJryCPqZM1k+YkvXjCSsuTYf8n+
         6FziUY1yeuZW/3JIN18InBSjbhrlPdJO8545orcQWaIpbzlqxbzHbrglJonedfS/G0rr
         GVyYLUIbhhl7PPPKnmXXSQZGjt4y7IWNfQMMqWOa4Wqt3TR+aC6Zr+kPMD4s+9d4nrqa
         c+fnFqERDXL8o+iHgxfrYOtEajHhHz0SBPP89kTRsUixjIkdeP3ETcxdUbv4xIHZDeJw
         xIG0XOsJjhQxrcZZ5ONG+bAwRuXtEFdxPBLEdiXHLfW1HZ8UXkVV0cCWsQG3kPW+jMR0
         nrdw==
X-Forwarded-Encrypted: i=1; AHgh+RoIKT08IUY0kzkc6mz+IXbISYohSZFEY4Xdrm+Yqmq6/2nCQLenV+ZYKqgitCwCg+h7X7mB0Pjo03Z54Ek=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPLnlBf9krwIc4eflXjr01+fLvih6o6eAF/UIyyI6EPDnvbXrU
	4eUQ1qg070Y5BY+eJWKC5ljgfWUANMZQUuOvBm2RrN3ar/8CKE4vW7lWS9K9wJl+rEE=
X-Gm-Gg: AfdE7clTmVN62EH1tnfLBN6KhyA1+QIN9Xkx3P0lSwfJaoGQ1AVS5G+j32e/F/EwciM
	rklX+tpdN1ABv6S8Wg69rEkIWZxm4vI5i0qxn4V2dYmZvfjZSjgCECmiRiQR/U02UiRcPIGfLzN
	fH6nHM9TB0eeJqM9/ieHKwWZYIsh2HGDHaLSkpocim2ZQjJm0Bv8E6DGrCAAKR4EPzYOiRBAAIB
	cK4w94E2lk8bb1odzjj3k0EiGZO3W/wFjWInvdD63LKKu4lHpFK7XnKmFpbrD+YIWgpGlFzhk/2
	X5+FN4Jo3wB6xnM9rQ3jXAKSEz2otcuc5G92gZXFkh3kz9rNV+V+B/X/WSF+PtbbFm9Cde4131i
	VbgkgIuKOKevIjT1uI9GQXCVJbAaI6QyinWqVRQqrwc0mCPVUhv4Ckf2xx+7prJGmc3GAQXdQpW
	regZmbAJcAR2Uwhoz2lEAGtr0wibkAU2tIvQwlXrZcB+5NmmDgW0n+ipzlgHLvcREnhFyJ/aYNQ
	l14
X-Received: by 2002:a05:6000:711:b0:474:2929:474c with SMTP id ffacd0b85a97d-47df075c5fbmr2017777f8f.36.1783509414164;
        Wed, 08 Jul 2026 04:16:54 -0700 (PDT)
Received: from localhost (p200300f65f47db04930dc5bd4534e1e5.dip0.t-ipconnect.de. [2003:f6:5f47:db04:930d:c5bd:4534:e1e5])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-47aa0960816sm40327132f8f.29.2026.07.08.04.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:16:53 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Lee Jones <lee@kernel.org>
Cc: David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Zha Qipeng <qipeng.zha@intel.com>,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Thomas Richard <thomas.richard@bootlin.com>,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 11/23] mfd: Use named initializers for acpi_device_id arrays
Date: Wed,  8 Jul 2026 13:15:18 +0200
Message-ID:  <8c8ffcd41b59446ebac377341971d6572f79c842.1783507945.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.55.0.11.g153666a7d9bb
In-Reply-To: <cover.1783507945.git.u.kleine-koenig@baylibre.com>
References: <cover.1783507945.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=10158; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=J3BCIbaF8e4vQqw/PDZunyp9IDodwLegq1o3eYSO0mQ=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqTjFeXiedhVGv/CjI38AbIgdYW1305yn5X+5Uj R++VCSddGKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCak4xXgAKCRCPgPtYfRL+ TmnzB/9mwObEejDkn1ndeET/GQnhsVJ7ddHuPe2KW+N2CZuHtDk2mlZj9i9//MA8srzP91Ji4j0 Uwsy+CgX8wJSDJbQiYRhVmxsaoDPuBCRT97IBFK5DbAyiRWj5i9IQFanDi74qNo8DcWi4OClHz0 Hj5n5ne5AS/CnTQILaezvnpzHHS2AGlpz8z43bYfXfLPWs9QFXdu54R1A7PfbouEiqsMYMRimsD U66SuYs0SCOnh6sv0Rbb2X42bRap4VWnzH1OGcEDk3jaXbxZCzm7KbMoeuYCGPlfg3LegasFhi3 l7SdjoVGnElr32HPpqLtQvMDB0qK3AoyaLGClYD2b5LuunzB
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

While being less compact, using named initializers allows to more easily
see which members of the structs are assigned which value without having
to lookup the declaration of the struct. And it's also more robust
against changes to the struct definition.

The mentioned robustness is relevant for a planned change to struct
acpi_device_id that replaces .driver_data by an anonymous union.

This patch doesn't modify the compiled arrays, only their representation
in source form benefits.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/mfd/cs42l43-i2c.c             |  4 +-
 drivers/mfd/intel-lpss-acpi.c         | 58 +++++++++++++--------------
 drivers/mfd/intel_pmc_bxt.c           |  2 +-
 drivers/mfd/intel_soc_pmic_bxtwc.c    |  2 +-
 drivers/mfd/intel_soc_pmic_chtdc_ti.c |  2 +-
 drivers/mfd/intel_soc_pmic_chtwc.c    |  2 +-
 drivers/mfd/intel_soc_pmic_crc.c      |  2 +-
 drivers/mfd/intel_soc_pmic_mrfld.c    |  2 +-
 drivers/mfd/kempld-core.c             |  4 +-
 drivers/mfd/loongson-se.c             |  2 +-
 drivers/mfd/upboard-fpga.c            |  4 +-
 11 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/mfd/cs42l43-i2c.c b/drivers/mfd/cs42l43-i2c.c
index cbe05c3ea910..e9cb4fb9854a 100644
--- a/drivers/mfd/cs42l43-i2c.c
+++ b/drivers/mfd/cs42l43-i2c.c
@@ -65,8 +65,8 @@ MODULE_DEVICE_TABLE(of, cs42l43_of_match);
 
 #if IS_ENABLED(CONFIG_ACPI)
 static const struct acpi_device_id cs42l43_acpi_match[] = {
-	{ "CSC4243", CS42L43_DEVID_VAL },
-	{ "CSC2A3B", CS42L43B_DEVID_VAL },
+	{ .id = "CSC4243", .driver_data = CS42L43_DEVID_VAL },
+	{ .id = "CSC2A3B", .driver_data = CS42L43B_DEVID_VAL },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, cs42l43_acpi_match);
diff --git a/drivers/mfd/intel-lpss-acpi.c b/drivers/mfd/intel-lpss-acpi.c
index d4b24a717848..19fc36164d89 100644
--- a/drivers/mfd/intel-lpss-acpi.c
+++ b/drivers/mfd/intel-lpss-acpi.c
@@ -135,38 +135,38 @@ static const struct intel_lpss_platform_info cnl_i2c_info = {
 
 static const struct acpi_device_id intel_lpss_acpi_ids[] = {
 	/* SPT */
-	{ "INT3440", (kernel_ulong_t)&spt_info },
-	{ "INT3441", (kernel_ulong_t)&spt_info },
-	{ "INT3442", (kernel_ulong_t)&spt_i2c_info },
-	{ "INT3443", (kernel_ulong_t)&spt_i2c_info },
-	{ "INT3444", (kernel_ulong_t)&spt_i2c_info },
-	{ "INT3445", (kernel_ulong_t)&spt_i2c_info },
-	{ "INT3446", (kernel_ulong_t)&spt_i2c_info },
-	{ "INT3447", (kernel_ulong_t)&spt_i2c_info },
-	{ "INT3448", (kernel_ulong_t)&spt_uart_info },
-	{ "INT3449", (kernel_ulong_t)&spt_uart_info },
-	{ "INT344A", (kernel_ulong_t)&spt_uart_info },
+	{ .id = "INT3440", .driver_data = (kernel_ulong_t)&spt_info },
+	{ .id = "INT3441", .driver_data = (kernel_ulong_t)&spt_info },
+	{ .id = "INT3442", .driver_data = (kernel_ulong_t)&spt_i2c_info },
+	{ .id = "INT3443", .driver_data = (kernel_ulong_t)&spt_i2c_info },
+	{ .id = "INT3444", .driver_data = (kernel_ulong_t)&spt_i2c_info },
+	{ .id = "INT3445", .driver_data = (kernel_ulong_t)&spt_i2c_info },
+	{ .id = "INT3446", .driver_data = (kernel_ulong_t)&spt_i2c_info },
+	{ .id = "INT3447", .driver_data = (kernel_ulong_t)&spt_i2c_info },
+	{ .id = "INT3448", .driver_data = (kernel_ulong_t)&spt_uart_info },
+	{ .id = "INT3449", .driver_data = (kernel_ulong_t)&spt_uart_info },
+	{ .id = "INT344A", .driver_data = (kernel_ulong_t)&spt_uart_info },
 	/* CNL */
-	{ "INT34B0", (kernel_ulong_t)&cnl_info },
-	{ "INT34B1", (kernel_ulong_t)&cnl_info },
-	{ "INT34B2", (kernel_ulong_t)&cnl_i2c_info },
-	{ "INT34B3", (kernel_ulong_t)&cnl_i2c_info },
-	{ "INT34B4", (kernel_ulong_t)&cnl_i2c_info },
-	{ "INT34B5", (kernel_ulong_t)&cnl_i2c_info },
-	{ "INT34B6", (kernel_ulong_t)&cnl_i2c_info },
-	{ "INT34B7", (kernel_ulong_t)&cnl_i2c_info },
-	{ "INT34B8", (kernel_ulong_t)&spt_uart_info },
-	{ "INT34B9", (kernel_ulong_t)&spt_uart_info },
-	{ "INT34BA", (kernel_ulong_t)&spt_uart_info },
-	{ "INT34BC", (kernel_ulong_t)&cnl_info },
+	{ .id = "INT34B0", .driver_data = (kernel_ulong_t)&cnl_info },
+	{ .id = "INT34B1", .driver_data = (kernel_ulong_t)&cnl_info },
+	{ .id = "INT34B2", .driver_data = (kernel_ulong_t)&cnl_i2c_info },
+	{ .id = "INT34B3", .driver_data = (kernel_ulong_t)&cnl_i2c_info },
+	{ .id = "INT34B4", .driver_data = (kernel_ulong_t)&cnl_i2c_info },
+	{ .id = "INT34B5", .driver_data = (kernel_ulong_t)&cnl_i2c_info },
+	{ .id = "INT34B6", .driver_data = (kernel_ulong_t)&cnl_i2c_info },
+	{ .id = "INT34B7", .driver_data = (kernel_ulong_t)&cnl_i2c_info },
+	{ .id = "INT34B8", .driver_data = (kernel_ulong_t)&spt_uart_info },
+	{ .id = "INT34B9", .driver_data = (kernel_ulong_t)&spt_uart_info },
+	{ .id = "INT34BA", .driver_data = (kernel_ulong_t)&spt_uart_info },
+	{ .id = "INT34BC", .driver_data = (kernel_ulong_t)&cnl_info },
 	/* BXT */
-	{ "80860AAC", (kernel_ulong_t)&bxt_i2c_info },
-	{ "80860ABC", (kernel_ulong_t)&bxt_info },
-	{ "80860AC2", (kernel_ulong_t)&bxt_info },
+	{ .id = "80860AAC", .driver_data = (kernel_ulong_t)&bxt_i2c_info },
+	{ .id = "80860ABC", .driver_data = (kernel_ulong_t)&bxt_info },
+	{ .id = "80860AC2", .driver_data = (kernel_ulong_t)&bxt_info },
 	/* APL */
-	{ "80865AAC", (kernel_ulong_t)&apl_i2c_info },
-	{ "80865ABC", (kernel_ulong_t)&bxt_info },
-	{ "80865AC2", (kernel_ulong_t)&bxt_info },
+	{ .id = "80865AAC", .driver_data = (kernel_ulong_t)&apl_i2c_info },
+	{ .id = "80865ABC", .driver_data = (kernel_ulong_t)&bxt_info },
+	{ .id = "80865AC2", .driver_data = (kernel_ulong_t)&bxt_info },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, intel_lpss_acpi_ids);
diff --git a/drivers/mfd/intel_pmc_bxt.c b/drivers/mfd/intel_pmc_bxt.c
index e405d7513ca1..6a9ad1f135c7 100644
--- a/drivers/mfd/intel_pmc_bxt.c
+++ b/drivers/mfd/intel_pmc_bxt.c
@@ -414,7 +414,7 @@ static int intel_pmc_create_devices(struct intel_pmc_dev *pmc)
 }
 
 static const struct acpi_device_id intel_pmc_acpi_ids[] = {
-	{ "INT34D2" },
+	{ .id = "INT34D2" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, intel_pmc_acpi_ids);
diff --git a/drivers/mfd/intel_soc_pmic_bxtwc.c b/drivers/mfd/intel_soc_pmic_bxtwc.c
index 117517c171b5..08fedf3d3fee 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -606,7 +606,7 @@ static int bxtwc_resume(struct device *dev)
 static DEFINE_SIMPLE_DEV_PM_OPS(bxtwc_pm_ops, bxtwc_suspend, bxtwc_resume);
 
 static const struct acpi_device_id bxtwc_acpi_ids[] = {
-	{ "INT34D3", },
+	{ .id = "INT34D3" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, bxtwc_acpi_ids);
diff --git a/drivers/mfd/intel_soc_pmic_chtdc_ti.c b/drivers/mfd/intel_soc_pmic_chtdc_ti.c
index 6daf33e07ea0..ff6223d6f54b 100644
--- a/drivers/mfd/intel_soc_pmic_chtdc_ti.c
+++ b/drivers/mfd/intel_soc_pmic_chtdc_ti.c
@@ -162,7 +162,7 @@ static int chtdc_ti_resume(struct device *dev)
 static DEFINE_SIMPLE_DEV_PM_OPS(chtdc_ti_pm_ops, chtdc_ti_suspend, chtdc_ti_resume);
 
 static const struct acpi_device_id chtdc_ti_acpi_ids[] = {
-	{ "INT33F5" },
+	{ .id = "INT33F5" },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, chtdc_ti_acpi_ids);
diff --git a/drivers/mfd/intel_soc_pmic_chtwc.c b/drivers/mfd/intel_soc_pmic_chtwc.c
index aa71a7d83fcd..413d2fd4f86a 100644
--- a/drivers/mfd/intel_soc_pmic_chtwc.c
+++ b/drivers/mfd/intel_soc_pmic_chtwc.c
@@ -261,7 +261,7 @@ static const struct i2c_device_id cht_wc_i2c_id[] = {
 };
 
 static const struct acpi_device_id cht_wc_acpi_ids[] = {
-	{ "INT34D3", },
+	{ .id = "INT34D3" },
 	{ }
 };
 
diff --git a/drivers/mfd/intel_soc_pmic_crc.c b/drivers/mfd/intel_soc_pmic_crc.c
index 627a89334908..d3db727c08de 100644
--- a/drivers/mfd/intel_soc_pmic_crc.c
+++ b/drivers/mfd/intel_soc_pmic_crc.c
@@ -252,7 +252,7 @@ static int crystal_cove_resume(struct device *dev)
 static DEFINE_SIMPLE_DEV_PM_OPS(crystal_cove_pm_ops, crystal_cove_suspend, crystal_cove_resume);
 
 static const struct acpi_device_id crystal_cove_acpi_match[] = {
-	{ "INT33FD" },
+	{ .id = "INT33FD" },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, crystal_cove_acpi_match);
diff --git a/drivers/mfd/intel_soc_pmic_mrfld.c b/drivers/mfd/intel_soc_pmic_mrfld.c
index 77121775c1a3..9d7e1881d693 100644
--- a/drivers/mfd/intel_soc_pmic_mrfld.c
+++ b/drivers/mfd/intel_soc_pmic_mrfld.c
@@ -139,7 +139,7 @@ static int bcove_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id bcove_acpi_ids[] = {
-	{ "INTC100E" },
+	{ .id = "INTC100E" },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, bcove_acpi_ids);
diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index e60736380cfe..bf02189b9a70 100644
--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -467,8 +467,8 @@ static void kempld_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id kempld_acpi_table[] = {
-	{ "KEM0000" },
-	{ "KEM0001" },
+	{ .id = "KEM0000" },
+	{ .id = "KEM0001" },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, kempld_acpi_table);
diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 4c668e2d2241..49a95b8e4ca3 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -233,7 +233,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id loongson_se_acpi_match[] = {
-	{ "LOON0011" },
+	{ .id = "LOON0011" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, loongson_se_acpi_match);
diff --git a/drivers/mfd/upboard-fpga.c b/drivers/mfd/upboard-fpga.c
index 9a9599dcb0a1..6674f4a1d2fe 100644
--- a/drivers/mfd/upboard-fpga.c
+++ b/drivers/mfd/upboard-fpga.c
@@ -300,8 +300,8 @@ static int upboard_fpga_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id upboard_fpga_acpi_match[] = {
-	{ "AANT0F01", (kernel_ulong_t)&upboard_up2_fpga_data },
-	{ "AANT0F04", (kernel_ulong_t)&upboard_up_fpga_data },
+	{ .id = "AANT0F01", .driver_data = (kernel_ulong_t)&upboard_up2_fpga_data },
+	{ .id = "AANT0F04", .driver_data = (kernel_ulong_t)&upboard_up_fpga_data },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, upboard_fpga_acpi_match);
-- 
2.55.0.11.g153666a7d9bb

