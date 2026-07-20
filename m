Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D84A3F7878
	for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 11:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784547557; cv=none; b=nUxn+0wHT/TTHZ4rX195JICfz45E38aR3jsGyMyxICs3WIQWoTIw9R8Mxxy9Py1iw/80uYNhBYvJpuQkNpx2lAP9hrNnRZ7cNAkb768KuVU/kNJPLKNNEbKKX5l+Z7cipMdWp+hC0+Kwkxjcv6BH9OsFaQg12HQV9hVsEhLBml8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784547557; c=relaxed/simple;
	bh=xTz3yEd8t4v3/U4yrl4P5+bV8vigviXxE5aIF8OTQPQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M4U6kAWRuMK5lZVUHoCqa0iv77P/Tibp7XQWyF5xLnjNDcp6KUSJWFaaJKQL6gFkCqlJkNI91ACeR18fSWVAMLu4TSES3zWcxSr7Sdm2NMCbMTLJilkCl2jX8eY3X9liNKM/DLfosHgquPLRXJywA5CNjyv3KH3Juu5Saoz5pDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=ZRPjV+1A; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="ZRPjV+1A"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c998fd549a8so6649355a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 04:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1784547550; x=1785152350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1NXr2phHnfz8YKmbh9LAE4yktpAw0f6xAv10feVt6yc=;
        b=ZRPjV+1Aqs7GJrOkRA0cgWHWs+hYr6BphLl9WN4FOczr5tFRBsqceZwrKX2bL/uE9S
         I0HkapGFay0bGfedDgM9t4u8B8xqb5+m4l2XxmqiwcP4AGgccJvIjncepLwbUoF3iJHH
         I8o7VGlHU5HlaopZU4KMwj7ZvHfa5iij+rEvI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784547550; x=1785152350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1NXr2phHnfz8YKmbh9LAE4yktpAw0f6xAv10feVt6yc=;
        b=pp0ICzumuW5LmfUHhgkGEYz1d6VO17zVOgNaZSK5dzj25+vVYL/9UEoWsH48BmAdHG
         Cs6Ksj7jzF5WUwwc6I2p5z9X8XtR6nF4TD55IDOzGK0IaixcoJGzmjw+o8IWQlNwPyon
         cYYmb4jfm4ZraS7cHdOKfN5xeb33pxzMoVkw3j1GqUjfEXaG2K/+mvQIjIV8gP4Rnqtf
         L0C0AxbSOTxfNt1Ey0M/hX615VRD5dWUTEdBFP62jLSAkqVqPxLkrtGu5XjHhf3TiyJa
         GCWBRIvVYDVCH7N9m5XnfEi4vZQQZoZkdJNrGbWgbNduZyf8UDi/Gn05TSdGLwHStW6d
         0WxA==
X-Gm-Message-State: AOJu0Yxh0YaT9xiTV47t+HA8hUx+oHENXt2FdmoYxYtKpWbuYa2F2LJ6
	o2ca5cErSjyKQU+g7gIymnpUvxveAhu+EEa4X8hOuqWbkL+aRMH74w68Fg6rfem6zBlaZ88gCoV
	HMDV8tE8=
X-Gm-Gg: AfdE7ckrMs2lMsaAoyPihoJu1OThyKgJSx3on5ca0lT9D7e87dU9tPJiQ1w/4PJro3B
	5NFxztWkGY0pBD41Y/a333RCOvJDhfnC5g8hmjushj4StPEKBt2W50j5fWWKN77OPw7PdNyNzQJ
	aZZfU3xJYKcFEUr1AD9Oev2JV2HtOWjPH33if8kuy5m/HuzSNv116oZ1zZKpfhyrTVrzdqoA58G
	iFCufMMI8Z8q/fHC8cp5Qe3shOqCqbHx48NUJdgvlDGTW7O+sN9nJFN90SWGr6PjVMDSGPgpiCw
	n92YRXFujs1Ulhoq9SOp/8ErSMGlA3K3xsab39cWsmOXaV6z5zDgvtd+C3z7OW5pIusHHddK1xS
	P7qg6dCrrUEQB+m4o/XhuZJhchAKohJtrr3tGrEMJPfOEHYUD483YC5V+unHdosdI29YlfAjd23
	YYHIl+mXazFe35mVpEa2TFVbvCwoEen1+I/has1XoIFYc9bzVvqYD5sGO80cAeg06M1AektF5ol
	AZ5oPdGjQy7FlH+LL4pSoX8omSL88hW72vvi47HUrINvol1IjwKFJzg
X-Received: by 2002:a05:6a20:da14:b0:3c3:94a8:7c18 with SMTP id adf61e73a8af0-3c3ad947dfcmr15251382637.37.1784547550640;
        Mon, 20 Jul 2026 04:39:10 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm61824393eec.21.2026.07.20.04.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 04:39:10 -0700 (PDT)
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
Subject: [PATCH v17 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Mon, 20 Jul 2026 17:07:40 +0530
Message-Id: <20260720113740.64960-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260720113740.64960-1-pavitrakumarm@vayavyalabs.com>
References: <20260720113740.64960-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/Kconfig  | 83 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile |  6 +++
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
index 0000000000000..edc550562235e
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,83 @@
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
+if CRYPTO_DEV_SPACC
+
+config CRYPTO_DEV_SPACC_HASH
+	tristate "Enable HASH functionality"
+	default CRYPTO_DEV_SPACC
+	select CRYPTO_HASH
+	select CRYPTO_SHA1
+	select CRYPTO_MD5
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	select CRYPTO_HMAC
+	select CRYPTO_CMAC
+	select CRYPTO_XCBC
+	select CRYPTO_AES
+	select CRYPTO_SM4_GENERIC
+
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
index 0000000000000..d7010644c3dbc
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_SPACC) += snps-spacc.o
+snps-spacc-objs = spacc_hal.o spacc_core.o \
+spacc_manager.o spacc_interrupt.o spacc_device.o
+
+snps-spacc-$(CONFIG_CRYPTO_DEV_SPACC_HASH) += spacc_ahash.o
--
2.25.1

