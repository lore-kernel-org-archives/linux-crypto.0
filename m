Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6634C33E348
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 06:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773815559; cv=none; b=lna0SMPfjOiMeYsj+2O+1oXkAd8qDF65WGo+WiCDxIUtFAnzD+RCz5AoWzmkTqy6BAQ/48+lS5qogBIj5CUX54acNsvGeowCxakgAEt8qMw3XeciY8GhA2XQbpBtFac1uqfbANoioatQt+jEQOjzzoWM2k+cuLh4rDCDkopA1S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773815559; c=relaxed/simple;
	bh=zD+neBIaLn25buSkXOiOMDlEitHsQGHr2PhaQ1S9Jo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p9Mq7tZGkquAvVTJhEuaWzUe5Q/iRrpNqSC7Zz4x8CaAVKvr1HqByTuHZztMu+5DkMou6EVFjxgT0Gg4E1scDA4aV8pbtIG2x2+Skrs3TvW+QtO94xg+By7Oh9JTIT79CmLJUl8qeSHT9L49jwHvl2gAgTiTB6N3M6ylOCsUCCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=SqH7uYKp; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="SqH7uYKp"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35a1f3f07ebso2757488a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 23:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1773815557; x=1774420357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gFX7q4zLow3FVt1OZdVBMtLthNdfCp6eUiWqYB1YR1E=;
        b=SqH7uYKpau+AwGbH876wP0SZLfCedGpCJqVhBhhpENygPefve06WhL54aMZFD6iGih
         jhtKhNirJkFAx2JiTU7N7LHyfmZ9ewDN/IkP/TDDe5zy6lXtpRT1Hzi9g067WZ9qjm6U
         hDYhItanLxDdXXkWc1wiBqXymQfEEWM2dn40c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773815557; x=1774420357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gFX7q4zLow3FVt1OZdVBMtLthNdfCp6eUiWqYB1YR1E=;
        b=M+ubtHuyHGJKYig23GE7QTOTR0w2noMP6ueWSOwxHwQhAhQ0rOxu1aNPgorUZ4dKdG
         0oSezRnL8PGfCigFR+VaAJq2ud1qcV/AOteQhro/4CGBktnHSKLl668LVJwKJlsmmNJD
         G2a29o1PX37HUcN5zxkt3h2ExsYHd7LtUZvPPoViSLgs+EOEEVMyNWjL/HrIJ5qNEzyN
         QJA+AuEjNyL38UFyIo7QLgqXK22kESUX3K69cZgQM77UrB9rJFgudyWHmGI0c7Mw0h4s
         bpU1dZt4zf98L0o5UatUV7fkaZ2QXZXAYYj565PNdmTYTGDcK4ymjHt5D7DwERROsPZd
         3cAw==
X-Gm-Message-State: AOJu0YyO96hZrghBXervMe8TBeExhQU+xEdy55FKyicOxqT45+WVMxJ6
	eSS3+jiDUsX292PfVyWB4q+80p8E5S3/DIqIvdbFdZAGOEEIhXzwW34he3pIBO1TB969nfOlcQu
	UdfRO
X-Gm-Gg: ATEYQzw6plbHEeZaZ7Co14U28BmXiWYkmm//YTCCNFQRnf5tyIY67vcqr7GkZFEKYzq
	eRampT9P0y1jgXpWHMtAiaK9q1SC/wqbKMfbtd6s7KS2zbUroeNcLOleWaE5Jw77fGDFTR+5PI2
	QenKlFWsgX2Jycen3Cfd10GudHl4qfMcUF2YGnNtZTsTIhFM7tfHWN67z3X+VZ+Quzbe3x2Pr0Q
	muhlGB5WgPXQeGt/Th1NgXCPdzSZmMeFWdq4iRtN2oNJ5gY4l6VfCHTheT/u1A0So6cZs/K0TJ4
	7YrxP6V4/KEh7bU6q0rQxa6yosQ66iihuqioG3sNpREnWtc9PXrm7czDq6iKI4J1ZqdWbHza3hb
	hkDMB8kUKvFvW/M63svoL2pbQQ9/+0WAvoTG9RfKTWC34RNQ11ARRn02DF3tnySzQO7ZGuEEgRn
	EEUQRvKJD0+elO0+31Y3vncXMAGmKCtB0lrvv+us2bg4KwgYOY6iGOvkLgemwVBzTgY7ztsbn0r
	451d+8BdPYYzfo86Jp6EEsrj+ir7fcFsI1c85PQ6DO67hOPDmOicNnUesYV9wImYDQ=
X-Received: by 2002:a17:903:2f0c:b0:2b0:6a3d:36e9 with SMTP id d9443c01a7336-2b06e3d2d33mr22406115ad.33.1773815557547;
        Tue, 17 Mar 2026 23:32:37 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e5ef3d1sm13620235ad.38.2026.03.17.23.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 23:32:37 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v9 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Wed, 18 Mar 2026 12:00:12 +0530
Message-Id: <20260318063012.816060-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260318063012.816060-1-pavitrakumarm@vayavyalabs.com>
References: <20260318063012.816060-1-pavitrakumarm@vayavyalabs.com>
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

