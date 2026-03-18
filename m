Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E36369988
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 07:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773818376; cv=none; b=qegZ0IVmurISN40HGiRlw4Cd8vIhxm6xKnTQy/lCy97OW53Meb5JLWH4a5OnKrxqizpsdqMc/rTa2d/YqcXo/y7V9j8nFvoC6KS2CemwjQfeJUlEayTDcNa4Jfp3/mYobVReiXZJlIbcBYwM+xp3NmgFtf/+/XpbTHoDeOtCTmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773818376; c=relaxed/simple;
	bh=zD+neBIaLn25buSkXOiOMDlEitHsQGHr2PhaQ1S9Jo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BKxtCEKREFPqI0Qdc3tUHOPfWwmfYmbfM4nEUICnqA7u9yrmbZ2TpZB4eOFmk75vrf+Gc/tWXQPRqDJR1Rdc9gEoa85+fr7sXlYGIdBUwsFSXIxSblcrgXPpT+nk342O4xPy8jgZ02PLnEV8ZlMxmYGRYZO014SU+TjsLvcZLnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=VYZ8K1zD; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="VYZ8K1zD"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-829928e512aso3405643b3a.2
        for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 00:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1773818374; x=1774423174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gFX7q4zLow3FVt1OZdVBMtLthNdfCp6eUiWqYB1YR1E=;
        b=VYZ8K1zDPWtRKaMWlaQyy8QW+G3itbRBKpESXAmLppCnBLvgbUqogBMXsBQtYnanZ4
         cor+84sC/WDJgY5SyGv2woKNNQPRgYNv+bDIP92sWvxRV32fkeCVpA/Wec+ZuM4hINcG
         0lDsjeTETmNAKsKTJRjwcIx1t5myzisvhB/8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773818374; x=1774423174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gFX7q4zLow3FVt1OZdVBMtLthNdfCp6eUiWqYB1YR1E=;
        b=cMJGKXsV8hn2g1AQaVAHLZmlUgm4//JN2VnhyBA4w8lFG4fMyu6MDNw704XdjsMNYB
         8R2W17Yu1qzfnBLfi+B658e6+AdLiX/TirIZ5RlR8bg1JrkiiemTaSGBK9EPclvjBnuP
         SY8Ns1HLojS39ji4FuwWdIkJArddcH43UZk1iVtBsP/qP27z3bGpL+2VXu7eoZcveoSa
         6tBj4/bu5b8DmWH2JTmRDXzxacefN5uXBAjz4z6gxXCohSVf/UcVZztvGVLaBxjc+nuB
         BJPfVT3jTHUcSPxS39fRtLZ0Us67HFrqaJO9GKVoVDjVJ1gwll+tAb4z3REFQO4qk154
         eHHw==
X-Gm-Message-State: AOJu0YxFMnqqd8OBLajQxEhB+OsZuJP159vAELkc5NTEbeT7MmsDFDSz
	OLD+tJw4VUmCrdYujVMGsy4zX/JYBsE4Bn/fVN7VRYFZmtvqdWpioctpPBRGSrBPXc/aQEf9mFr
	FyWPU
X-Gm-Gg: ATEYQzy6nWegRWoUyVOxpYI3NRsDbfssPebeWkrUVZ5vId/O/ca1i+kLneTpOdyr8nT
	9VeWS9p+Gd8LmBpXG8m5cy4Ks3CYkSsXoOvWzzV4f8QmurhJ5OMC1ln46hyVSGRvr0ReHBB+KEs
	vv2Xm5mjQql+3KHLmIUD8QiBbaudMoVil9sMlbm7LDTgoph2UnvUa4/1L1NOpNUg8CjVDT4alr2
	BkleNxpyP72LrGh1plEnENAacoua3Yu85KFLP3tGcazZIShJ2NfX57TItG37M8PT1Saxtwaj8JJ
	w207bUN2ARW46J516qMiTKoy2GihE6wyF/+76jKU+mC6JsiYkQeRcNmBmIvF78jI06aSPvK51ZM
	lywaT2ZBD9s9W4jJTAY7fXnhI2giOlIQvFYS2htqj2Lw/i2FlM8Khwz4dyjvKMOTmjM5IrYUCxs
	QSs0lI7ulw+KfPv/09aBzkKrx+EjnoSmGbNXouLKwuaQR6OH5pz0ZIjtyIdawsBLvEqzl+pIrb+
	tf6PUhT4INwMNeqkN5YxdarGhHqSMN42CyA6LHuVW8+fLsw5Ju/Jar4xShi3R0jP4g=
X-Received: by 2002:a05:6a00:2da1:b0:821:7d7e:41d5 with SMTP id d2e1a72fcca58-82a6ae85509mr2286973b3a.52.1773818373896;
        Wed, 18 Mar 2026 00:19:33 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6bee89d5sm1613669b3a.51.2026.03.18.00.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 00:19:33 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v11 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Wed, 18 Mar 2026 12:48:08 +0530
Message-Id: <20260318071808.817074-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
References: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Makefile and Kconfig for SPAcc driver.

Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
---
 drivers/crypto/Kconfig            |  1 +
 drivers/crypto/Makefile           |  1 +
 drivers/crypto/dwc-spacc/Kconfig  | 88 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile |  8 +++
 4 files changed, 98 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8d3b5d2890f8b..b644f80ed40d4 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -781,6 +781,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.

 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"

 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 283bbc650b5b2..d106c1c729060 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-y += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-y += loongson/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
new file mode 100644
index 0000000000000..f9752e6f664b8
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,88 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config CRYPTO_DEV_SPACC
+	tristate "Support for dwc_spacc Security Protocol Accelerator"
+	depends on HAS_DMA
+	select CRYPTO_ENGINE
+	default n
+
+	help
+	  This enables support for SPAcc Hardware Accelerator.
+
+config CRYPTO_DEV_SPACC_HASH
+	bool "Enable HASH functionality"
+	depends on CRYPTO_DEV_SPACC
+	default y
+	select CRYPTO_HASH
+	select CRYPTO_SHA1
+	select CRYPTO_MD5
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	select CRYPTO_HMAC
+	select CRYPTO_SM3
+	select CRYPTO_CMAC
+	select CRYPTO_MICHAEL_MIC
+	select CRYPTO_XCBC
+	select CRYPTO_AES
+	select CRYPTO_SM4_GENERIC
+
+	help
+	  Say y to enable Hash functionality of SPAcc.
+
+config CRYPTO_DEV_SPACC_AUTODETECT
+	bool "Enable Autodetect functionality"
+	depends on CRYPTO_DEV_SPACC
+	default y
+	help
+	  Say y to enable Autodetect functionality of SPAcc.
+
+config CRYPTO_DEV_SPACC_DEBUG_TRACE_IO
+	bool "Enable Trace MMIO reads/writes stats"
+	depends on CRYPTO_DEV_SPACC
+	default n
+	help
+	  Say y to enable Trace MMIO reads/writes stats.
+	  To Debug and trace IO register read/write oprations.
+
+config CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+	bool "Enable Trace DDT entries stats"
+	default n
+	depends on CRYPTO_DEV_SPACC
+	help
+	  Say y to enable Enable DDT entry stats.
+	  To Debug and trace DDT opration
+
+config CRYPTO_DEV_SPACC_SECURE_MODE
+	bool "Enable Spacc secure mode stats"
+	default n
+	depends on CRYPTO_DEV_SPACC
+	help
+	  Say y to enable SPAcc secure modes stats.
+
+config CRYPTO_DEV_SPACC_PRIORITY
+	int "VSPACC priority value"
+	depends on CRYPTO_DEV_SPACC
+	range 0 15
+	default 1
+	help
+	  Default arbitration priority weight for this Virtual SPAcc instance.
+	  Hardware resets this to 1. Higher values means higher priority.
+
+config CRYPTO_DEV_SPACC_INTERNAL_COUNTER
+	int "SPAcc internal counter value"
+	depends on CRYPTO_DEV_SPACC
+	range 100000 1048575
+	default 100000
+	help
+	  This value configures a hardware watchdog counter in the SPAcc engine.
+	  The counter starts ticking when a completed cryptographic job is
+	  sitting in the STATUS FIFO. If the job remains unprocessed for the
+	  configured duration, an interrupt is triggered to ensure it is serviced.
+
+config CRYPTO_DEV_SPACC_CONFIG_DEBUG
+	bool "Enable SPAcc debug logs"
+	default n
+	depends on CRYPTO_DEV_SPACC
+	help
+          Say y to enable additional debug prints and diagnostics in the
+	  SPAcc driver. Disable this for production builds.
diff --git a/drivers/crypto/dwc-spacc/Makefile b/drivers/crypto/dwc-spacc/Makefile
new file mode 100644
index 0000000000000..45d0166dfc8f7
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_SPACC) += snps-spacc.o
+snps-spacc-objs = spacc_hal.o spacc_core.o \
+spacc_manager.o spacc_interrupt.o spacc_device.o
+
+ifeq ($(CONFIG_CRYPTO_DEV_SPACC_HASH),y)
+snps-spacc-objs += spacc_ahash.o
+endif
--
2.25.1

