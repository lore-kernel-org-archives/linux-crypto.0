Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622320;
	b=T3QCj6jKH9dOEtRM7nKCDDbvPZMKWig4qGdC7wjqobK1bMkqxBb8gHNMqzDo7PKPzf8s
	 xCJZCqC/wt5RWJiylDpCJyRq6z8J/+GfXGvBkQL5GocVWq0ksjaa6WHpQNxfyRqux78Cq
	 uu/P5YzuDSnP71BgvgtpD/4v6foC+d4oAWxqjOQK0WqkxLjGyCwg45TlMH/GMRxLps3jO
	 5t6BZEl1NVRarZ2sNmc8uE8bJYIIgQttRJdH4rn46/ONKCsbAcrL52Nft1ByG0XzQhhfc
	 nEnA+VvSyTQTCw5eFq9P3zB/4aovOmPr3GvAaTy+7GEHVpHKurMUKqr5sP9mh9Z4SBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622320;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=qnxaTAkpwcOidnWuLl/cJuwzJ/f4ZOoVnf34DWpLrVk=;
	b=5Lq6ODlwZi7rCssZIqTGegwCe118MGZ3PNxjOwaLRDKUyGzPrOvnSZVeXj/HXURToapH
	 RwS73Y0oThZGMq96uaksCLdNWmBFd9s4J/HPl3BkwJ4xmPLEkzU3AODe4mshS0GoiOknY
	 rO+uSQPMIeI/ZbbhNcILOnDL4yYMaqKgjZE6UctZaNwyZ2bRCjXtuw348nERIBw3Yq2TG
	 NsCKs4gAUbtXbm3YZtKaCqfFo35Ojdef87v2Zn87DP0hgaj8TSR2iKcU0OaW6QbPwQt08
	 PHKI70W1q/nTTEvmlzn6/Baq//3J71f+I75ajDVRSqHW1lc6kNpDs5Ib4GXcWUfYvTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=thegoodpenguin.co.uk;
	spf=pass smtp.mailfrom=thegoodpenguin.co.uk;
	dkim=pass header.d=thegoodpenguin-co-uk.20260707.gappssmtp.com header.i=@thegoodpenguin-co-uk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hD0T4KxY;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE31606D246
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 12:25:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FE31606D246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=thegoodpenguin-co-uk.20260707.gappssmtp.com header.i=@thegoodpenguin-co-uk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hD0T4KxY
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so2985807f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 04:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20260707.gappssmtp.com; s=20260707; t=1793622318; x=1794227118; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qnxaTAkpwcOidnWuLl/cJuwzJ/f4ZOoVnf34DWpLrVk=;
        b=hD0T4KxYPfXkyRuWEcYoEWKFD2kJqqOFy3vaCMKHs+/Mmgyyg2YIT/wT0cRBH5Pogd
         DNvyxYnMhsqwh3h7Jlrus+o8qbSMB6aUaTi8hpbEl04p/sq4hSqsGOu6dRs1OaJBDBu7
         vP9XKQCeaU8W1guGCHAL02MUuw3cokAq1O87Yov1EXFOro5IwaBGVo01sWATj6vvnrGu
         fwuu+TBr0CQYVMu4zEXGlYSh4pFeMLFSKOwxL9rnY/0tXZqwWC2lNV7YgvomedHo1RNX
         /0e0jKkZflb8FhTwupIf9PMnZUP4kRgdE4EKZWDKTsVQkaONogrib8L1+uTo2zkyewnJ
         wXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793622318; x=1794227118;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qnxaTAkpwcOidnWuLl/cJuwzJ/f4ZOoVnf34DWpLrVk=;
        b=mFx7X46HBU8nSfhCG3qBKD24TEfm+2MaPctNvY4EAdLsYMKwAndRj1RXqZDTxpJIll
         B8zI0k0ctbQDG4qV5KZqAWxIdEJJ7jXrru4eI42UP7dC50uQIsyGQQCR9dlkVmCTJPip
         ndEfzuPpTN46f+Y3SsbNIvFTqndlQZMEzVB1+zPunA9t2e5SS+rG2dL3KatTHpGO2jVX
         JbKo9gc/nuKiHUSLtRv7oztiokm9gzca0/iPNsLqXohz5Nd+j4YMtvwMdk3PHAnDDM1L
         QZOEDKqcoGHZRDPXCTfA70C0MdV7hJd1mdWsDHkFThT956VXDwBDBNHNSWe4q/IlflRX
         3rXw==
X-Forwarded-Encrypted: i=1; AKwUvBymmBJioLzDxm5DxbIjewAkO61eRGg6FBeMxoejiY8aPQV+pkH/KTG/5x0MmMbBdS2MzkfQrBjogP1GA/M=@vger.kernel.org
X-Gm-Message-State: AFq9FYKV7WXPNhehSVqT2lmXtdRGx9x2ky5ziwJbquGi7T+P1zaXt1Sb
	Dz0Molwz2oZ+J1cx9xXqf5qR1Bs7V4RGVd58ZZHYhHzbFSE442iELHmGRmo9Stbqj9I=
X-Gm-Gg: AYBFou1sLHuRuz2EFTIOKSWgq94gBN2nPiuEH5f5xz4EEgL3Beb/C+8FghB+xQ7RODp
	S/t+/QhdoAES2WnPNZBbjDKEZdCA+lxnNudWdPQxSWuIxcj0h8A8nKDJIp6hkD9uYQQ2C4gBbqJ
	3GwzHwcLVXbvy5WsKAAyDBlARrn1p2U0wDTaTpBokeOA/LsOnRG0sh1Jbu+F/F1/96pzRWOKH5R
	2Z7Lqn546UkC5j5kbXbUWDZq4F4smkfTtwhE12ThFwT1yKRYFqWxuzu55u86V1QRDRhbFIS8OQ3
	ACvSuXukYvrI7+PloisZL0VFoEnHr1RNp+e2todYc0V/0p/Gxo58rieqxAEeTeLsE5cjw80efxN
	aVF274Uv3nmRG1EEzMYLXKn1HpEDH3aP/jB4UiWPTuiFcQ9gU+olP0ROpeZ+YgQaZzd5GzKW9bN
	NWEChFOZ/d6sZgLeR6uKDoA3b13RCIthzml1RczecSmL7ge82wVNS2zSzo9ITR/dg4K6XiSWV1P
	XLd84raqG2iXvFrdF978fv2LGlM03ox8xpC4UESqMzTuu6/X67bTR/OBfASDkLF19rhCqIgN+YO
	ObkVTSHS9heMYoqqlR+wyKZIu/sRfwESxsGGYDcOUR7QKA==
X-Received: by 2002:a05:600c:8b66:b0:4a3:5a91:5f61 with SMTP id 5b1f17b1804b1-4ac1793f8ddmr236704555e9.14.1793622317763;
        Mon, 02 Nov 2026 04:25:17 -0800 (PST)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:a898:4bb0:ad55:e439])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf6e63e0esm346783795e9.12.2026.11.02.04.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:25:17 -0800 (PST)
From: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
Date: Mon, 02 Nov 2026 12:25:14 +0000
Subject: [PATCH] mfd: Use named initializers for acpi_device_id
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-acpi-mfd-v1-1-d61029971be8@thegoodpenguin.co.uk>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMywqAIBCF4VeJWSeogVGvEi28jDVBF7QiCN89q
 +UH/zk3RAyEEdrihoAnRVqXDFEWYEe9DMjIZYPkUglecabtRmz2jmmlbeOEUrUwkPMtoKfru+r
 63/EwE9r93UNKD5T+/9VsAAAA
X-Change-ID: 20261030-acpi-mfd-a6ac9d16671b
To: Lee Jones <lee@kernel.org>, Chen-Yu Tsai <wens@kernel.org>, 
 David Rhodes <david.rhodes@cirrus.com>, 
 Richard Fitzgerald <rf@opensource.cirrus.com>, 
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 Mika Westerberg <mika.westerberg@linux.intel.com>, 
 Zha Qipeng <qipeng.zha@intel.com>, Qunqin Zhao <zhaoqunqin@loongson.cn>, 
 Thomas Richard <thomas.richard@bootlin.com>
Cc: mfd@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-sound@vger.kernel.org, patches@opensource.cirrus.com, 
 linux-crypto@vger.kernel.org, 
 Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793622316; l=12397;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=1GEV7hhED3325gUvci85Sx4ni8Bu2o31ERMO8HWKgdg=;
 b=TfJYQo/tDyoJ4oEXab/+yXykW74+6dCOZLOexoiVY+aut/lFWDgbPgx2UZ3yEy2Q98u8N3K2g
 zPnoyn/64rvCTGQ9n6NjPvqV55EA0zPBd/LU/cF6gL4gUeQd6cch6CN
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

Use a designated initializer for the acpi_device_id fields which makes the
code more readable and consistent with how lists are initialized in the
rest of the kernel code base. Also drop explicitly setting fields to 0
where it is redundant.

Unify the list terminator to have a single space between the brackets and
no trailing comma.

Signed-off-by: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
---
This series is converting lists that contain the acpi_device_id struct,
which is defined in the include/linux/device-id/acpi.h to make use of named
initializers (which they do not use currently). This work is part of the on
going effort in the kernel associated with device-ids [1]

The plan is to convert acpi_device_id::driver_data to have an anonymous
union, similarly to what was introduced for PCI and I2C device ID tables.
The goal is to increase type-safety (most of the existing casts are gone),
to improve readability and to make use intent a bit more clear:

```
union {
	kernel_ulong_t driver_data;
	const void *driver_data_ptr;
}
```

But for that to work all lists containing the structs need to use named
initializers first to avoid triggering -Wmissing-braces. I already have
patches that implement this and touching a lot of kernel subsystmes that
use the acpi_device_id struct and that list keeps on growing. Therefore,
I have decided to split the series per every subsystem into:
- pre-clean-ups that convert the lists to use named initializers
  (which is this series)
- actual implementations that make some of the modules use the new
  driver_data_ptr member

That way the task can be fragmented into manageable and independent chunks
of work and makes this effort easier to review.

[1] https://lore.kernel.org/all/cover.1780048925.git.u.kleine-koenig@baylibre.com/
---
 drivers/mfd/axp20x-i2c.c              |  2 +-
 drivers/mfd/cs42l43-i2c.c             |  8 ++---
 drivers/mfd/intel-lpss-acpi.c         | 58 +++++++++++++++++------------------
 drivers/mfd/intel_pmc_bxt.c           |  2 +-
 drivers/mfd/intel_soc_pmic_bxtwc.c    |  2 +-
 drivers/mfd/intel_soc_pmic_chtdc_ti.c |  4 +--
 drivers/mfd/intel_soc_pmic_chtwc.c    |  2 +-
 drivers/mfd/intel_soc_pmic_crc.c      |  4 +--
 drivers/mfd/intel_soc_pmic_mrfld.c    |  4 +--
 drivers/mfd/kempld-core.c             |  6 ++--
 drivers/mfd/loongson-se.c             |  2 +-
 drivers/mfd/upboard-fpga.c            |  6 ++--
 12 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/mfd/axp20x-i2c.c b/drivers/mfd/axp20x-i2c.c
index 5c93136f977e..c5d0d35c7fb0 100644
--- a/drivers/mfd/axp20x-i2c.c
+++ b/drivers/mfd/axp20x-i2c.c
@@ -97,7 +97,7 @@ static const struct acpi_device_id axp20x_i2c_acpi_match[] = {
 		.id = "INT33F4",
 		.driver_data = AXP288_ID,
 	},
-	{ },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, axp20x_i2c_acpi_match);
 #endif
diff --git a/drivers/mfd/cs42l43-i2c.c b/drivers/mfd/cs42l43-i2c.c
index 2f1862199618..89dca295cc57 100644
--- a/drivers/mfd/cs42l43-i2c.c
+++ b/drivers/mfd/cs42l43-i2c.c
@@ -73,10 +73,10 @@ MODULE_DEVICE_TABLE(of, cs42l43_of_match);
 
 #if IS_ENABLED(CONFIG_ACPI)
 static const struct acpi_device_id cs42l43_acpi_match[] = {
-	{ "CSC4243", CS42L43_DEVID_VAL },
-	{ "CSC2A3B", CS42L43B_DEVID_VAL },
-	{ "CSC4244", CS42L43B_DEVID_VAL },
-	{}
+	{ .id = "CSC4243", .driver_data = CS42L43_DEVID_VAL },
+	{ .id = "CSC2A3B", .driver_data = CS42L43B_DEVID_VAL },
+	{ .id = "CSC4244", .driver_data = CS42L43B_DEVID_VAL },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, cs42l43_acpi_match);
 #endif
diff --git a/drivers/mfd/intel-lpss-acpi.c b/drivers/mfd/intel-lpss-acpi.c
index 720adb0ee21f..2f46a85066bd 100644
--- a/drivers/mfd/intel-lpss-acpi.c
+++ b/drivers/mfd/intel-lpss-acpi.c
@@ -137,38 +137,38 @@ static const struct intel_lpss_platform_info cnl_i2c_info = {
 
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
index 6daf33e07ea0..49f4138961c8 100644
--- a/drivers/mfd/intel_soc_pmic_chtdc_ti.c
+++ b/drivers/mfd/intel_soc_pmic_chtdc_ti.c
@@ -162,8 +162,8 @@ static int chtdc_ti_resume(struct device *dev)
 static DEFINE_SIMPLE_DEV_PM_OPS(chtdc_ti_pm_ops, chtdc_ti_suspend, chtdc_ti_resume);
 
 static const struct acpi_device_id chtdc_ti_acpi_ids[] = {
-	{ "INT33F5" },
-	{ },
+	{ .id = "INT33F5" },
+	{ }
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
index 627a89334908..d39f73ae6773 100644
--- a/drivers/mfd/intel_soc_pmic_crc.c
+++ b/drivers/mfd/intel_soc_pmic_crc.c
@@ -252,8 +252,8 @@ static int crystal_cove_resume(struct device *dev)
 static DEFINE_SIMPLE_DEV_PM_OPS(crystal_cove_pm_ops, crystal_cove_suspend, crystal_cove_resume);
 
 static const struct acpi_device_id crystal_cove_acpi_match[] = {
-	{ "INT33FD" },
-	{ },
+	{ .id = "INT33FD" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, crystal_cove_acpi_match);
 
diff --git a/drivers/mfd/intel_soc_pmic_mrfld.c b/drivers/mfd/intel_soc_pmic_mrfld.c
index 77121775c1a3..531d8b8be44d 100644
--- a/drivers/mfd/intel_soc_pmic_mrfld.c
+++ b/drivers/mfd/intel_soc_pmic_mrfld.c
@@ -139,8 +139,8 @@ static int bcove_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id bcove_acpi_ids[] = {
-	{ "INTC100E" },
-	{}
+	{ .id = "INTC100E" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, bcove_acpi_ids);
 
diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index 47062f876e5d..399f1c97320c 100644
--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -470,9 +470,9 @@ static void kempld_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id kempld_acpi_table[] = {
-	{ "KEM0000", (kernel_ulong_t)&kempld_platform_data_generic },
-	{ "KEM0001", (kernel_ulong_t)&kempld_platform_data_generic },
-	{}
+	{ .id = "KEM0000", .driver_data = (kernel_ulong_t)&kempld_platform_data_generic },
+	{ .id = "KEM0001", .driver_data = (kernel_ulong_t)&kempld_platform_data_generic },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, kempld_acpi_table);
 
diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 3902ba377d69..49a95b8e4ca3 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -233,7 +233,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id loongson_se_acpi_match[] = {
-	{ "LOON0011", 0 },
+	{ .id = "LOON0011" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, loongson_se_acpi_match);
diff --git a/drivers/mfd/upboard-fpga.c b/drivers/mfd/upboard-fpga.c
index 9a9599dcb0a1..37c3c50aa6e4 100644
--- a/drivers/mfd/upboard-fpga.c
+++ b/drivers/mfd/upboard-fpga.c
@@ -300,9 +300,9 @@ static int upboard_fpga_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id upboard_fpga_acpi_match[] = {
-	{ "AANT0F01", (kernel_ulong_t)&upboard_up2_fpga_data },
-	{ "AANT0F04", (kernel_ulong_t)&upboard_up_fpga_data },
-	{}
+	{ .id = "AANT0F01", .driver_data = (kernel_ulong_t)&upboard_up2_fpga_data },
+	{ .id = "AANT0F04", .driver_data = (kernel_ulong_t)&upboard_up_fpga_data },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, upboard_fpga_acpi_match);
 

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261030-acpi-mfd-a6ac9d16671b

Best regards,
--  
Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>

