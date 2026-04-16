Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C0D2D1931
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 06:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776321996; cv=none; b=RjR1Na3U+Rb5PGVS85FNXzMquMCmUjSNcq2MQc/7E9azAS7H3bDvFT+eC6UHlbXiiwdhh7rGo3KIkcCb13d07ELWvMp2Cu0JE36dV+sWxN0hewmShi5H9rp3eba9h1Y6bKKVj8R0czZALDrGknkZ14hTGfXet7tauhOJRh2aVNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776321996; c=relaxed/simple;
	bh=4LU1IrL5gyBpEHR7/NLXXJqQW/u2iHDuiJdll/UcfBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=grPTBieiodzwqTimxXnAspbbSq+KYDQ5X8ZQ4CAjpYthIV1ZJuN2Tr0DS4tg6WMiCGNOWs5nqddiXUNZy7XtzKE5pZB6G6HbdK2KX9NWeO1zuNIkO29oVFFDsigZKSO51Th88NnwzhGOu+9IUoqnoweM5GHJa/CIBM7a1ZO4oH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=NnHS2LbT; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="NnHS2LbT"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82f4c3619b0so1720476b3a.2
        for <linux-crypto@vger.kernel.org>; Wed, 15 Apr 2026 23:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1776321994; x=1776926794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/V5ox+79P3LcSxd6wN5P/F1MTZ5N007Bin+MslZtJ8=;
        b=NnHS2LbTE2nBD7EZIhojlzOWoeL1w8mdtIr6zYbbokBYruXQ/UCMV02t5IiT3Crf4v
         ajSzuW39rC2Csxi4HAbzbwqVMZPSV7RZX9EF5LZsgfU4OrQg5BMFjiaQqaGTRgPcysE0
         6KeMeUzOF5jqXOH86ykGbyWOZ2QmXlAxqMasQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776321994; x=1776926794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p/V5ox+79P3LcSxd6wN5P/F1MTZ5N007Bin+MslZtJ8=;
        b=Cg5M1zGvHz7Vz1HKrF0gwkk6g/gLHf41cpKiqmi2baRzBXPf2zCnNQ50Q/Ph1bFRm7
         QyGUTDjXFYm/KdTgtyAzvtKo++l3wPV3uiEQN/PU4O2d34pkrisVYlflx98HBfLZ5UGS
         5qQgF/fBlaJ2y51RYG6NDFf4qYHVO+ncrm9HFXfFZM5ziyqnw+FRWmV4/KDJ4NfdE40l
         COV6t1rRRzHFrs3Ysztnru4wpI2U1cmojP4qwNBIM6sMkUW+IPPMBVLoRu4lcUCeHoOZ
         n+WlrcKMjAT/oMqivhyTFWKga82zfsRCikPjulQ5SausEm1pMqKfjFztV1fxdbOXi2QU
         bzeQ==
X-Gm-Message-State: AOJu0Yzh48L2/ghxFYfTzSiAeeuGYUKaSTS81+fGh5zUr3e48wSoiUtT
	VGxGsfXBHt6y5VlX+iBKQ7JfB9pVeaQdTmaCS9b74f5JqkdfZlFLBJfpVqhwAb/q+P+jiYORDtN
	xCkHrRhM=
X-Gm-Gg: AeBDiesgXjUBNTYhCOPhuhrR8+ou7pOu88O5YSMGrlrtNkyVYbmEcd+G96tjxSAGZbx
	/nv+PvAI1GoQJPYUgov5kq9WfiFYpy31L2RyUHy6OqBbQQ+dqelj9H78AThurGQ+tnsHHzFaQKe
	/g6UuDbU6Or8+BlInu6BnjP6nPUbyofm9CKwA4n7it5TM6uiwGUTazRjDgGZxXEpG2iVIRzkje4
	VF960C28Ad1HY38StSB8wNIvekgEpaS/JErh6UaBLvaDoTDJwXgjm6F8xCmH8YnptxSL/7CZ1wZ
	avP040o+i1JlHCep7BPoGwAEfoeK8qEx6TUCPcRhL/oNahUFlhQURLXbLlGaK4645vxCKvjzzUV
	w18x77DNhJd/TqQdnVZXpC0zPAHgyEnE9z9iv5DU7UF5vHL9P5g/FXQymoGpHpNQKKAJT5GAMXz
	/5mJbaRxjuT7XZFSEzmjeF3mg/MEm3wUzmNdLyJ4zDwu0l+8D0MZgDsos0yhbqXiVMVyx/ZvHK/
	WTe3sgqB/DTjB4KGd8soLcWfl3TNWUfWjvCZYrgsO9y278NLlsuBRpR9uRL8AxxD44=
X-Received: by 2002:a05:6a00:4212:b0:823:9e5:855e with SMTP id d2e1a72fcca58-82f0bea2ba5mr22997415b3a.0.1776321994057;
        Wed, 15 Apr 2026 23:46:34 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f67418a47sm4107066b3a.48.2026.04.15.23.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 23:46:33 -0700 (PDT)
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
Subject: [PATCH v12 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Thu, 16 Apr 2026 12:14:51 +0530
Message-Id: <20260416064451.99886-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260416064451.99886-1-pavitrakumarm@vayavyalabs.com>
References: <20260416064451.99886-1-pavitrakumarm@vayavyalabs.com>
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
index 971f17a155435..2d10ef4321bc8 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -774,6 +774,7 @@ config CRYPTO_DEV_BCM_SPU
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

