Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6F0443313
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 10:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785320848; cv=none; b=MVrKAfU+zxJwrqekjxPN9Xkhq3XIZy5/oYq5L1aECFiTi0OLoTjY/jgYUGDt+GTlyAi/T8ZWEM5MK+uGoAcuuqE8liEfJkzNN89E5mkvecUn5HxUzsElz0lOcILD2EcZJoKsYlA5oG8sqi34JPIrFXpzOtx72ISIxv5wJ2+Tqgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785320848; c=relaxed/simple;
	bh=uNB4Na5m6MDJkiE1NyWFnSHm8qpbC6q84MaUkA4Po60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WtK8iRinLCqjurWRF7a8NrmdWYv4pxgWiYu8YYn6cP835uQimhHQ5TF0stw1p8fEDbkpvUz+RVrUNDJ2KEe2FrdBTOCYvZyG4rSIlUyms0ZepBAvTsK09FnqgvBEh53oz+KC/SebI8fs5lnJ239xE9p17SfW7171n4wILlYqOUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=MRk0+gOX; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="MRk0+gOX"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84536ecfc5bso806292b3a.2
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 03:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1785320845; x=1785925645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KoegTloIj0RWdbO/FsMNhxWVDzFLMQxM6I7dHJJDjWk=;
        b=MRk0+gOXD30GLjJK+/vQLdu3nVLj0dP0jcVwbMr7tvdRZlq5nuMwoP3i0ZvG50I1Bl
         L/EN0dGBYs1qtGMk/wuLm6GZ4LwuJa9+TdHhM5EEdmGYZQinpOzxrxQuuO82ZJON3197
         zuIAJhoot92DjfrHFesW2w1Nu8DHPbDo2T0Fo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785320845; x=1785925645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KoegTloIj0RWdbO/FsMNhxWVDzFLMQxM6I7dHJJDjWk=;
        b=YzSV++HRM/vI+uCw6M4kAM50urRM/FCrzhLJs8SSIEJ4h9/+kUZ1/MUd67yMMu/QCT
         WAIuiLTCZqo6DXsxBO2AuHK7Xa+2lefwMg5xxMRA106yACuACThDfsHSYOtgRGZjsPni
         pV4LKSIdJqH8wbWlek+UvaVO+Qck+UcCp0sHV0/Tmz3LhJoBKxtMzhePhX/C2wrN8mrC
         zK7StAgFKgNgwCI7tUrnecLJnY3ocEX3VxB3gKWr+S95mLQcjjX27ICGwnrTdsA6NuzY
         OT6WG73RozAyS8BvRGHXMxVOlmJdBMakhGZXCvNnFkwqE9xN+zrfBtDA0nRtoXW16AfV
         zJ3g==
X-Gm-Message-State: AOJu0YxwtAN37CZ6dOgpyF08vxL1+1hlAeYOhsdkrISS9UVjS9/SqWbL
	jAU/CpziLDML/Q6pT4TluoisnqO7PaJ8hhjlkm7FTl8gpH71fbxrI76Cy0o7hxd8W+2gGgxNOV2
	Sqx0ftaE=
X-Gm-Gg: AR+sD12z+KowQ3QLaoXAkctzG5PxCVZrCd6c0dl5P+ARS0+70NtMbw3QQewQOhUpncU
	587Hbq4xa5t0uZsUTvpvWibk8WYoIe7JEtV4Hm0BP3M2gFeoQiLY3FZ+NPTzm68aUGAap2fTBE2
	ZrEfsk9MN5C3OV9D+TtRSKO1Px14895O0rY4R8z3oCYT0GJ3q1q3RkqBtuPcv7juxoFoQswU603
	3w4GKfIQrOeslBiko7L4FFWQVVJq2ubFxkSqa2zxHZI2UT6ZLw/KwEHgIPLWG8unL0G/MGvuchP
	KgdNVaR78Ko/DJKb4PG6plWoXIIoaoH32v2/1k8s6HMxzW8QcB9wuKJFmjuioDYlZ6LR+msvWzZ
	pikhMrnCGdkl917Q0o0viGo0vNsLNGrqI7cUAvIOxqsWcnaQP0nEziCuezksw9jKE7JrmBvOe4E
	bJuQ10Se4OiqlNQUtH6pTWeO3I2Rnj1LhYHGIxjc5hit/5wvR/gSSj5tqHR1toGPQN8ySucE+o/
	x6l/8fy/oilKovc0DqfsTmBZ30rCuukooxbKwApjjIysb1mN5gmzb9x6Cvv8ocC4mgcxBc0t47Y
	RO/Tzev1ktb6GUZMlceURatOZEfT
X-Received: by 2002:a05:6a21:6009:b0:3c3:875d:c538 with SMTP id adf61e73a8af0-3c8aafa3ee2mr7538237637.8.1785320845537;
        Wed, 29 Jul 2026 03:27:25 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b15f77sm9238958eec.4.2026.07.29.03.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 03:27:24 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	ruud.derwig@gf.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v19 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Wed, 29 Jul 2026 15:55:47 +0530
Message-Id: <20260729102547.159890-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260729102547.159890-1-pavitrakumarm@vayavyalabs.com>
References: <20260729102547.159890-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Makefile and Kconfig for SPAcc driver.

Acked-by: Ross Bannerman <rbannerm@synopsys.com>
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
---
 drivers/crypto/Kconfig            |  1 +
 drivers/crypto/Makefile           |  1 +
 drivers/crypto/dwc-spacc/Kconfig  | 82 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile |  7 +++
 4 files changed, 91 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0189dfdcbbe11..e0a8de643d6fa 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -734,6 +734,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.

 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"

 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 2c33b83f3cfa6..b80f211598bbc 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-y += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
new file mode 100644
index 0000000000000..b528c8e47b3b5
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,82 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config CRYPTO_DEV_SPACC
+	tristate "Support for dwc_spacc Security Protocol Accelerator"
+	depends on HAS_DMA
+	select CRYPTO_ENGINE
+	select CRYPTO_HASH if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_SHA1 if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_MD5 if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_SHA256 if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_SHA512 if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_HMAC if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_CMAC if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_XCBC if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_AES if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_SM4_GENERIC if CRYPTO_DEV_SPACC_HASH
+	default n
+
+	help
+	  This enables support for SPAcc Hardware Accelerator.
+
+if CRYPTO_DEV_SPACC
+
+config CRYPTO_DEV_SPACC_HASH
+	bool "Enable HASH functionality"
+	default CRYPTO_DEV_SPACC
+	help
+	  Say y to enable Hash functionality of SPAcc.
+
+config CRYPTO_DEV_SPACC_AUTODETECT
+	bool "Enable Autodetect functionality"
+	default n
+	help
+	  Say y to enable Autodetect functionality of SPAcc.
+
+config CRYPTO_DEV_SPACC_DEBUG_TRACE_IO
+	bool "Enable Trace MMIO reads/writes stats"
+	default n
+	help
+	  Say y to enable Trace MMIO reads/writes stats.
+	  To Debug and trace IO register read/write operations.
+
+config CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+	bool "Enable Trace DDT entries stats"
+	default n
+	help
+	  Say y to enable Enable DDT entry stats.
+	  To Debug and trace DDT operation
+
+config CRYPTO_DEV_SPACC_SECURE_MODE
+	bool "Enable Spacc secure mode stats"
+	default n
+	help
+	  Say y to enable SPAcc secure modes stats.
+
+config CRYPTO_DEV_SPACC_PRIORITY
+	int "VSPACC priority value"
+	range 0 15
+	default 1
+	help
+	  Default arbitration priority weight for this Virtual SPAcc instance.
+	  Hardware resets this to 1. Higher values means higher priority.
+
+config CRYPTO_DEV_SPACC_INTERNAL_COUNTER
+	int "SPAcc internal counter value"
+	range 100000 1048575
+	default 100000
+	help
+	  This value configures a hardware watchdog counter in the SPAcc
+	  engine.The counter starts ticking when a completed cryptographic
+	  job is sitting in the STATUS FIFO. If the job remains unprocessed
+	  for the configured duration, an interrupt is triggered to ensure
+	  it is serviced.
+
+config CRYPTO_DEV_SPACC_CONFIG_DEBUG
+	bool "Enable SPAcc debug logs"
+	default n
+	help
+          Say y to enable additional debug prints and diagnostics in the
+	  SPAcc driver. Disable this for production builds.
+
+endif # CRYPTO_DEV_SPACC
diff --git a/drivers/crypto/dwc-spacc/Makefile b/drivers/crypto/dwc-spacc/Makefile
new file mode 100644
index 0000000000000..b7125a7797ba0
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_SPACC) += snps-spacc.o
+
+snps-spacc-y := spacc_hal.o spacc_core.o \
+spacc_manager.o spacc_interrupt.o spacc_device.o
+
+snps-spacc-$(CONFIG_CRYPTO_DEV_SPACC_HASH) += spacc_ahash.o
--
2.25.1

