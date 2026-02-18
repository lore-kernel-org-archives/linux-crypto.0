Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE5331ED73
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771419526; cv=none; b=NTi3MifAIFv9iugPl86MrQPmBNbni5JJBBOtmW3CPi+wErhCWxWMMwhMcid0wMBsc0wGiaHXbXs2Pl9RZEhj7ymdyamjqRYHCpK28+72nFRXzNP/BhxVukItaXcVzdGMdrq2/qYT7JDsfE8EtWFcIMG851spjN+DEJfvbWjpxvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771419526; c=relaxed/simple;
	bh=9+DQjUew8kkumdJA/hrPw0h+aDG9PSARamWRMqx9mNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eFh/RTgp4BczOwF9ayLlsFnAJZrz5jn9ieevMr2x1+5NlmpbtnN+0UZiOetcbWD38iUE2gv6yK5sPsVB1RJR8NYaqi5IgHESIB3Ixs1cWPAquKKbuaOugmtZOreKHE0UNeLPIQJsvV3JM7JC2tva8IUoz3fNNs/+SMOMsGejCgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=dYnVcpzv; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="dYnVcpzv"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8230d228372so3195683b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 04:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1771419524; x=1772024324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KlFofjEDBgXa43lzOJCQ6xEpdr+n2zK1FZuaFtwkHQA=;
        b=dYnVcpzvbhqfKce5khUDrmSx/0VYWv8MHGkZjhMn4KeNkT1Po9KHUTmOXsb04o01Dj
         3yyZR6U2mFI7COpVaT33UEEbq2oJYa2G27zndBoxXngqQH7keWYVPnhUl1EX211O53Hg
         SUokxcg9Dj25aJYxD6DqbMOXYXIpNXljo2mwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771419524; x=1772024324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KlFofjEDBgXa43lzOJCQ6xEpdr+n2zK1FZuaFtwkHQA=;
        b=J8M+gIbs3lVwTzZEqnk4F78j1tAXLkMOt6JzVdoPy9S6HWpXg6QVWZuV575xoDCsBl
         ETOavSpMfwO0BbUxqujGgRrpNAuyxv9vFSZRsQRtG+eXQHKT22fI2kzQXttF3Xv6vdr5
         tfwCtEDptoSX6rXpckMtt4EuvBWPk6w2L2PD4lMJk61QXKiyAB2080o1UOY4tJBtoXVs
         Q4UnfEj/bSXJd8e+aH4H1nnuG64TTsG4uZypeEvpxibAHFKWE9zAzfALkqZd/evdD61T
         tUDt8RZXzQPHhcnRMkM3hBnXJZY187uwjOOzH4bdgqa681x0oxDHZk4rp3golot8elFc
         rSjA==
X-Gm-Message-State: AOJu0YypdOniUy8xlbkLSzteVFQ8vCO8RxJiwMzQFcAtlXTSIwdYro6d
	xrZ+9aGcVNIH+y9sConymggjGvdx/pu/uepLHOD1XIl0oCIoVPpHo8Dv5Ivz4XIQrII+hgOceOS
	oJFWS+ww=
X-Gm-Gg: AZuq6aKg4dteh+HlvZ+PAMoxjTrG3wB9dXZD3R9M+oCp7noD543toHKXmxvQBKTBdh8
	CIfh31e/TZPblUO8tecqyQ8Vo/AyqD/SnWW+VnaSFUsa34YRz/ulH1JZT0JyZ6RhEmjKPa3eG/K
	MFGsJ+A4ORgsmxDxEVO6vZVBTNvJVrxZ4vkJ+AcBKO06NL6+M8TeACgs2bG1HqDT0cmBeCMOqmW
	/u5Qi5MSMhMkzrEBeMxkBrhcGdiYBt6E5+vZPn2If/Wdpkz1kq2msrhlomEgwvMASP9XIXCyq5h
	8YgwXgNNH9A4l9+PHb2f5mSowiI4e0HkTB1sSU0t3iiFL11g4gEBc85waAYC1vbeCeJb91GaKFw
	jDpMZlFpZPLZ89We8IhBPvfA3d4a9/PjpAOHhrj/fkDWAFDxgNzxJyhHFKqeT837D87NRTDEOjD
	hw0kOiA+45wxTB5GkL42uWMdzk3bgYvaN32aal2o8ApXAfcZzq0NvU9K32N7RqCSuiKbs5wbjow
	6rQcRaz03SGqhn+dy1xUQZSPljR7RW2OqlNNczhzQAJBy8EET/QkbjcMYHlzQmeSRs6qRfy2pUF
	+A==
X-Received: by 2002:a05:6a00:2354:b0:81f:8084:7ead with SMTP id d2e1a72fcca58-82527460776mr1819433b3a.5.1771419523896;
        Wed, 18 Feb 2026 04:58:43 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2afeesm19227464b3a.2.2026.02.18.04.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 04:58:43 -0800 (PST)
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
Date: Wed, 18 Feb 2026 18:28:05 +0530
Message-Id: <20260218125805.615525-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260218125805.615525-1-pavitrakumarm@vayavyalabs.com>
References: <20260218125805.615525-1-pavitrakumarm@vayavyalabs.com>
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
index 322ae8854e3ea..89f54b3faeb56 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
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

