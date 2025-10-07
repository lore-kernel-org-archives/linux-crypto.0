Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F2823BCF3
	for <linux-crypto@vger.kernel.org>; Tue,  7 Oct 2025 06:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759819867; cv=none; b=I9gga8k7lnkhgowM3pkkRlAXulKsZWD+xFxRd2QeQY1Hk1ifR8Tha5PI8rdDoCeuDVEgpFfXza7DCFhTxbk98eZDidD7bJAHFw2M+sWyGjBJ1bfSOArb8lHIvytXUQH9RZ/aqZHZWq76oKhUjALbmwr56o+OnLFKUsbBjcg4IAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759819867; c=relaxed/simple;
	bh=PzPp5lh4w9MAIVL6Y3lW3zsso39XiIKfrNvEK/RYtJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GH6OlBS3dkcnLGpxqJmLWH/S8nKuDa3shY7M6zuyr5U28SmXvIFKxcxr5q1Xx3nmSjdY7PIaRkzcRCgyGs2To3kq5G2lEguRx6AuiGed5G5Gc/QtBajYhm71tublFNypr2atnR/XQEdL7FRQYzmRlbfEufk7gZxi5luoly5IuGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Iow1UycH; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Iow1UycH"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b62e7221351so2879377a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 23:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1759819865; x=1760424665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x1JvAAk4cJnEamYn3QhmqYlNG1sfQI/VEnnjVQb6AzA=;
        b=Iow1UycHOMUL7jid1e8QJpV9hAgyKrlOJG2uLUTuAE1wFcKcxSWeFOJoU/J+9WJap9
         usSaINIKdj630BrR+KKDxO1r6HrtNYDvN+QCdC/nwFJOjZuJDVAp58mcaZREK6cYPXsy
         GzSWHEJzCVCc/pAv9innZT4mIYounYQZFOJ1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759819865; x=1760424665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x1JvAAk4cJnEamYn3QhmqYlNG1sfQI/VEnnjVQb6AzA=;
        b=AMAR7qGBN2lYnepK/+v/aQGv6ApHhmk2b2AN1pNZWiVqy2d1CXenyRIkm9wLt0xP6Z
         VAwebV0hzPwbBYHGnghsru/3SvKqQr5sn/+C67tM0UbMKSLoPJw1srTiOqLGFJ9/oqcl
         /G2QKeQXDM4aMmtfJVIiuidf86wsBPuABtp6xEsqjbHR8XLCbELpaF09kXLCONSmjYBK
         rPx5+ejZnTC38NzBVo8OL7Qijs3uy//+j8jRjv4K9Lzd9zlBXbQQbtPx4vm9soKER3J9
         BVJLA0f8WSZRANyanYK/w0I+7qFL283K2ZVZifyJXC10j0+pyCmh4fiSnE+v4I1dWmHr
         mydg==
X-Gm-Message-State: AOJu0Yxp/qHGhg0bjaEoQcEA2G5xYboA+EXh5/lZFmOCdoQEx1t2Z5NM
	jexVOozOqdyb6wHi1eLpCxYUVBNQ9FY6kKyeAmeZKSZ+n1lh1oiWVGuD0BeCkI+cSgH/7HscfSf
	dwuVwQQY=
X-Gm-Gg: ASbGncu9oZZU+icdQ+uyXFD/Sh5gKHCMU3eNr8U9Os966ddmIrp1U2YQywVkZcE/jQF
	2z39UT268EHH7NKIRdS8dvoxLl9KY6uceHdar7CHrLaeMvQartlrvzHS7f61t06GEKvnarMEVnU
	6GeURZRau3VxV5tlQ3NyWj9Mh98vWxjCGB0a93/D+gRS/W3pTBKe7Kqyb8pxAkpjL4smjP1ZfBx
	ieDewKu+mTel/9pNz3v+ZBUVGkphn3wLc0JNu8Gu5fQvxWdga81CS6q8xXpNxH5uSGFvtRwLedE
	EHczNug+kRV90tk7fQO0ivi+InWpZJvoQ8rKLDo2Y9BmkoaM9Wd/tevM5fdmRRpVwHSkXwID7Wu
	n+SnvHGNxra9kTy2CgVoFAl4J0MFe9OiiQpPIjXtliXkwBxQfY0Cs0+ailyiFwmbKLDe23Q==
X-Google-Smtp-Source: AGHT+IH/Mv8ei/4xdbbFNwnpkB2DI8J/Gdq1XPNmETcnbdutsxPo4WAgyfoB4/wa01Wc9l2mpIRYkA==
X-Received: by 2002:a17:903:196b:b0:271:479d:3de3 with SMTP id d9443c01a7336-28e9a5609bfmr187778975ad.12.1759819864927;
        Mon, 06 Oct 2025 23:51:04 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d111905sm153287745ad.24.2025.10.06.23.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 23:51:04 -0700 (PDT)
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
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v7 4/4] Add SPAcc Kconfig and Makefile
Date: Tue,  7 Oct 2025 12:20:20 +0530
Message-Id: <20251007065020.495008-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251007065020.495008-1-pavitrakumarm@vayavyalabs.com>
References: <20251007065020.495008-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Makefile and Kconfig for SPAcc driver.

Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510040852.qK4TiL4k-lkp@intel.com/
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
---
 drivers/crypto/Kconfig            |  1 +
 drivers/crypto/Makefile           |  1 +
 drivers/crypto/dwc-spacc/Kconfig  | 80 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile |  8 ++++
 4 files changed, 90 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 657035cfe940..ada04311c370 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -780,6 +780,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.
 
 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 170e10b18f9b..e0d5e1301232 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-y += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
new file mode 100644
index 000000000000..e254a1bf9cbf
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,80 @@
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
diff --git a/drivers/crypto/dwc-spacc/Makefile b/drivers/crypto/dwc-spacc/Makefile
new file mode 100644
index 000000000000..45d0166dfc8f
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

