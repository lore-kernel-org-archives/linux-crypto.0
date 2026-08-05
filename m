Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DCE483BF6
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785948552; cv=none; b=d8ydiAfTVJkz3m5xW+vEthssHZ7BEeX+ESUyhtTOJADQeq8OK2rMMO3PpnbO1k4JkcTWmaSQMuPA6uIsuZB1mDzKyrW5zAt08vzGW0wrzYYQYo6ugP+kIZtgUJx4AHTLTuoyTcnXVUdmHyIGyrCoRCvSpw7zxOmaU8PRu5sp+ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785948552; c=relaxed/simple;
	bh=cYTRcuw8s2nKWOkANUTFereN4SknbpQEr8kU6/03/AU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aBZ/ZWEVtlv1uUX2QLx1FNRizZ1I6hc7C6KOHe+SOTt3xeBXGLKfzcH4m3Jh7Sr49H0xu+sljvnEMRjAQecy8uHFfMwcDAuTWn2Zd6onWFujgKk2quxbbK+URODoZVWFbCPqNjTvkhoERDl/qz9oZmTmOFXP4IFxLiRLvymBs08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=F2gYBlBI; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="F2gYBlBI"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e041ea211so1426754a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 05 Aug 2026 09:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1785948550; x=1786553350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q/CboWqdLgwW2C7HH93E7s0JF/082hXtsQbCCJh3598=;
        b=F2gYBlBId1UHWdoxRWyg3R3n6kJvh/tQX+zpys/aZ+rjW3j8+30m07H/65kE7yrseR
         wQwyUEd4ffgFSI1bFvCWSp+pex7xrAog+tJvV8CUuXUvcMLKoyUbDmyUi7ejx/hOGVw5
         5zgz58VmkBk8i2ijr9/EaYg4BLnJKhlloMxgA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785948550; x=1786553350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q/CboWqdLgwW2C7HH93E7s0JF/082hXtsQbCCJh3598=;
        b=raiYoYIBbZgfTrY17yGmRGlNxCiutlNt6aP6nyTdT0KpCISnZYQge7UO2t030+4dJf
         ftk0BrUyaZEEIP+bhBI1fVoKBCVgHP/AjOtYU2M6ZvIEWTmbl758G/dA3ylxFHrVpZHZ
         vum72kN2TUhdYn6bs1n3hDU0Whq43lISWKxzIpGwuF5MaZGRXCwg1LyyD9vXGXyIwkG/
         Iu8lSdZmTa1F2xv68oG20ao2Up9JdSHGW2UA8mK1yQPOlxCbDqygimUXzOcK8cnEYPEr
         cGm2gnZqDN2OEaAhhy0HZdq9UW/7LdHV+d/v81AABTGREmIfw+VHr9lGtQCEzz+gAntR
         Gkjw==
X-Gm-Message-State: AOJu0YwhzM175eoq+VTn0FIE7lrO8NNqwvpClZmn9iKsq2t2mzFEJulM
	AuE6jz4GJXAve7Nm8V6NwMAPPQK9KzEkKeFMk/iKxURYwh0wfhfRpaWU5d95ntzEbQwSj5n0R5x
	JrXIg0H4=
X-Gm-Gg: AR+sD106mckbcfSD/tCvDLPaOZjQnX63ysedeCRHSSwYLgT6JEXckAHSDszs796FRhH
	WIpY/jYMeHqSvZw91+28WHz/tL7IkkCEGQ+Z1Ez25XbAhv5PfjvNZ6a+8msTe2nIl+OdBcAz+wm
	s73jtcWDPq7aL+tNL2JmbXJJ2TM7rlGFbRYspOS+yOM7RMtM52gOj1cZA/aW04oNXyA1n/umomh
	8+wFmvy7LCPJlqZSbSvvKF/M/+2D0dM4OCKVyUcx+QygYMcmp2tW+HiDqW8JarZW1uSfjpN7T7J
	Aq9mF9KEC6N2tqrxuMLShJrTCpsVROvwfwXIgepZcJayZQRNUrWSHxFviit9r+vrniQak0QMpGT
	5r3Wh1Zvy3f1c+pB6XHx3+ZGvVjs0I2eDO0D4A7YRS9z+DGqWHg3SLGdtMqbjyPgKLJJaVFY5Be
	zQLhThBEPykk4St/WC6JxomGLd2xOVpC59VNWRrSRWWEBxF6FgAOKoRR6Qp+H6dNeNeE20qlg8p
	TzAnfNasfrR+m7TtHpCVAnPtFDgArrEP+d6odvkbIHAZyETDf3QAAkZbY0s/ir0tTpl1HAfakpX
	9Iy3Nu/SDMOwkKW4BTPReP4TCikbp8g3bh/TQaU=
X-Received: by 2002:a17:90b:28c3:b0:381:bc4c:da56 with SMTP id 98e67ed59e1d1-3903c6128c6mr8900908a91.19.1785948549676;
        Wed, 05 Aug 2026 09:49:09 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867d7e4csm18358677eec.31.2026.08.05.09.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 09:49:09 -0700 (PDT)
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
Subject: [PATCH v20 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Wed,  5 Aug 2026 22:18:15 +0530
Message-Id: <20260805164815.249328-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260805164815.249328-1-pavitrakumarm@vayavyalabs.com>
References: <20260805164815.249328-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/Kconfig  | 64 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile |  7 ++++
 4 files changed, 73 insertions(+)
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
index 0000000000000..40f7190d7980e
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config CRYPTO_DEV_SPACC
+	tristate "Support for dwc_spacc Security Protocol Accelerator"
+	depends on HAS_DMA
+	depends on HAS_IOMEM
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
+config CRYPTO_DEV_SPACC_CONFIG_DEBUG
+	bool "Enable SPAcc debug logs"
+	default n
+	help
+	  Say y to enable additional debug prints and diagnostics in the
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

