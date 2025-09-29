Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FA42C11F8
	for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 07:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759131867; cv=none; b=baBkhFXdVcS8M7EigOh7QolZBdoU1lw+cERyTYseoOBK+q2yJbQ+O6vq1Y9fWcgOrTPJwns7r32cjCNtVtufR4V6IuT+DcixXP3+54XBa6RW7aieVm8Li6Q72neAt+MOcQ+GiOi9Maevqd9q7FH6nV72K+SWlosCoj4zeMaVuzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759131867; c=relaxed/simple;
	bh=aFzi4qxJ7rQHCA8ko/DkWYKE6oWKyST/QbF/RY7wiNo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sLyGZejqchoMRlic63Xeyb805b22kBK/EA24xKAtjRgO1kBr2mToGuu3Zm5Jqj04ejBSMbSV5Cwzvus9TL0SyhoyacC/tGR6ZOMn9Uqoow8DtCP5U2PUCWLDSnJ0vFcsk/xT/UxS74TjgnXqytLq8Q/WmSpEnq9r3Iti26YBZVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=cSLuAtth; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="cSLuAtth"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2697899a202so38193985ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 00:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1759131865; x=1759736665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5y/BDQo5bgkRnqVMmNG7pEhS6NIpKO/OpfTCmrBefHs=;
        b=cSLuAtthEvqDOOjTxExFXLoMFd+t2j/INGJ+Ocqv/EfmYNwomVxtmVTvdcZEeE0wSi
         1N7ArRkvla3kGcf7FZ45qnWSOu0ZQmebCWFitSIdAGxETdjxRdnpDw7YMpeu7Xv5SZ9X
         7W0t27IgnCO+aXxCKOkcE8uyohHQmLzDY1hys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759131865; x=1759736665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5y/BDQo5bgkRnqVMmNG7pEhS6NIpKO/OpfTCmrBefHs=;
        b=Nv5ef49G9j6dnn7zR8+GzmAGMkkwvo5VUUtdlFQ9KcTojeUseAa7k0FxpHplg7k1hn
         DqfnlQOmc+USKshbVbJa5U9zXRdbhIEDl3kZCNCCarpNdKXWL8t6cv8C+Tvcr10tUFje
         Vm5FIWTL9x8ZKHVI6TW/wCco/W8Yt8WpAZAkmLAK2RvJjQ/CJ/JsXN1JCKtd+zaoye4D
         gLrqF30s4AS1l4Y+k6BFDjoMsppZr0GuA0qlpHLjdTiJLukca0etO5fQVx6Dte5G5cgL
         2M0cvS+1Pd1IalMX+KhdixIUwLW+8kAxolElx6XBe1zLR3lHCBQcpw1Pbiu+1RuXSNMA
         TYFQ==
X-Gm-Message-State: AOJu0YxUnuPzpwUUMZic2KFEH2OPJlLTUvm1gXmgwsoVZqmJcu4H7N7R
	0S2crwltjN7QUruCJ/Ra7AX6kae1ZA8vNfly8iPqZXvBYBcX3nc5GztqzhvcqEDPG12T33YKN3Y
	XldKEyrI=
X-Gm-Gg: ASbGnctFx/P38S927FkfOW4P1Co/HqgeQCeevPTqU+L9XBbu3fomu4vFJ1wq8znmqcr
	Wsqnmse7bKXmgpxPj6BW4PSu3VMU5oznCN2ixSVz1NCiQnuLsgfvtfbOqDlTMrTzxMuXRRgTbDj
	5l6lY1R7K7lLNg5qAHHNIph5b0nI7HOX0Wiq9EnCY/GyyQc2iPZ7M5KMLfVh9aNgOQQLHTnRYIx
	mMZ9cdIKRwqA+gjfNhvA/PUrutB9lu0AKCtmpRP8xMVubdnkOPoi6Bx+dNtST/WGJg/09f0wG7F
	+yW0P/6bLQJdIEd9pFQ6MugfIW2S5zMLqGPc/80J5xMpimQqUznHrwfvr+ldvlG73yUDmUm4+Qd
	PA+qiouZrnKZNP7qJerVUxRJ+vjpuh2WeagGMgdagPLxvN9Md7sh819FS
X-Google-Smtp-Source: AGHT+IEDdXtz5qjT/GbVC2bSEbaweaSIC51I+exSyhQsqO8wXjylseRoO6Bbj4eZSqZG/Dc28Q2KUQ==
X-Received: by 2002:a17:902:ce01:b0:267:c1ae:8f04 with SMTP id d9443c01a7336-27ed700e02bmr142895605ad.20.1759131865012;
        Mon, 29 Sep 2025 00:44:25 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed69bc273sm121341105ad.124.2025.09.29.00.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 00:44:24 -0700 (PDT)
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
Subject: [PATCH v6 4/4] Add SPAcc Kconfig and Makefile
Date: Mon, 29 Sep 2025 13:13:34 +0530
Message-Id: <20250929074334.118413-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250929074334.118413-1-pavitrakumarm@vayavyalabs.com>
References: <20250929074334.118413-1-pavitrakumarm@vayavyalabs.com>
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
Closes: https://lore.kernel.org/oe-kbuild-all/202509271802.8KQP38Ht-lkp@intel.com/
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
index 000000000000..736b332c9c94
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,80 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config CRYPTO_DEV_SPACC
+	tristate "Support for dwc_spacc Security Protocol Accelerator"
+	depends on HAS_DMA
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
+	select CRYPTO_ENGINE
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

