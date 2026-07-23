Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1A047DF98
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 12:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808193; cv=none; b=rFcAeJzZp9pZ4HtFeZ1RpGA9wszCoURbKBppbFrVsCjGxQczZxdZBax/PtgRwzRIUjjjxbsC55hnKjifXRHaDhdMXPHdv0tYOazGkIdzR7uhIJ2HIvXSokrcYNf/6qpgOmpStJQQNaHSSKsX6StY2tkjeaZpYkv9kedq7pOEmFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808193; c=relaxed/simple;
	bh=UIW2ukgKIySaDQTv4socc1nn10xiRiOnSqw40FjaZ8M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VkPrw3kDwEhENQsD8BwEEvWbgT/E0Ycoo/NnhOezn//BA+cLhxH1JtZNq90DBsKUt6KP1sdrZj4sz5OKDElv9ss1cVoRt2HxGzMecG9q3FdUc3e7W9zFyhQiHwC6LS/sMGwYqujABnudJlvBvz3jns+Hcm3hTXnXxEZT+O2igGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=g/9py92s; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="g/9py92s"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8487b7b3fc8so512362b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 05:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1784808181; x=1785412981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7sZV4euPXFPzPbpKN0UebnOT4DNBz+cy1h/z2qNpElg=;
        b=g/9py92sB7patRKkYAYV2ks554dwtpI6fw+Tetn/dYgLt8QqwlxJw6lDhCtVQsvbHp
         lArqlU9okVW3L4DctYrzcXPR3puO4TNfBwfHMXbB5SPCfE/oduatR6L+VxauaLZKfM6C
         o5vLpgdBhW8YHG5wzkuzKcvU/PVClHcM/PeCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784808181; x=1785412981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7sZV4euPXFPzPbpKN0UebnOT4DNBz+cy1h/z2qNpElg=;
        b=bxRhaTo3DXAsHLU8l2KVQC8W8A8XTAwcUfADjRif01EohamSyfza2wcbGyig7+qdKb
         a1otO5cIJLHNCEBt5o4qQKKKsS3cDwvwEwEg4XE6F/m+j/CaitIeAdLq80cQGri5uNRd
         Q1H5uR0q5b5BNiE4EDCYxvb7551QshuKqHB1xB+m5hXSrV0PUXba7R79dJMyy/9Y8KwK
         xIUn+MSIg34/Jpn7LH37lzv4ZHqvxi1lAdXS9qr499lk1rpMTk+2ugMBSKBmoItsHfdj
         /Z2rPLcTmu49b5ZCo3YaPbbm/Uqqp6fSr9amAfBelVStu08Cr5hnCOZE4gY+Inc0LWzC
         5Ajw==
X-Gm-Message-State: AOJu0Yz1Fe1wcRmB1ADaY15+ZHi2+19Tv6opIiQeq4xA7qbnPOAF8ZgN
	iIH/0Ws9vFa9i5soedfyomtUYmyDfQ0+ZfxWH37ABxmrPhieyrvBiK5HVsp6WaDyn/C7KnHHgAe
	jECMmlrs=
X-Gm-Gg: AR+sD13KNENLcjru/FEYcNevfrq82ESQNvQUXf6DcpG8NHZeuaFlNxwwsBRJwNPG/pn
	llXFJr8YOKRhCbkYcFoHi7xYTUo3EtHNtXtznz6n0NxOI2Sm3JYAYv3lfyRt1ZPKnQ1rFBkg7He
	iCWsJzg23zZyZVnanbn/5oxxovYOX6Ui41TXkcr9v47wjjZu94suFkIZmhT7gltNIL3/L2QWeet
	4OGDnNq2S0/Qqd3m5AH0jUJ1VDe+pJjgyqGf8fSY2bTFPEsVvGEDnKBdMezVz8/v+RMGuuvTNrA
	bdu51uoh7AzkW7iZoBS+QbHzdP+VaMsRZvWfGLH/ZlS0eKzrNumoQr+VtVUxffZNvAlteCet9vV
	m+BvlbuvDHLIjyDvssOLU/FFpMOSev96ryhUI9Pxj8UopuZ6BRj9xbAinFZTK6/bv8eB3GGoe3I
	p2BHo4/mjN92kOT9koVeZHVQl06+8xk+fRYw3umtPuQH0Cbm9uHi36a9dmRmBSTTWTpkf3fMdRY
	m7VontpWr0lHO22ymrmvltlbZLFeKfPJkphXaiz5XNmfw==
X-Received: by 2002:a05:6a21:2d46:b0:3c3:83e8:c211 with SMTP id adf61e73a8af0-3c44b25397fmr3017899637.63.1784808180993;
        Thu, 23 Jul 2026 05:03:00 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147df06864sm19359125eec.15.2026.07.23.05.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:03:00 -0700 (PDT)
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
Subject: [PATCH v18 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Thu, 23 Jul 2026 17:31:56 +0530
Message-Id: <20260723120156.285270-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260723120156.285270-1-pavitrakumarm@vayavyalabs.com>
References: <20260723120156.285270-1-pavitrakumarm@vayavyalabs.com>
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
index 0000000000000..bf70adc1a2084
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
+	bool "Enable HASH functionality"
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
index 0000000000000..0bcd2705a60cc
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

