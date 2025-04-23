Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAFD7DA6D
	for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 10:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745403375; cv=none; b=u7sQM42bQBYoOtDGPLzHFtVdz95C5Ez+ble6HW5BA6wvf852U8H6nrScYGUbaPbgfpV678VyeJeKqjXXC0x8Exa3Pqv4WmGApq3gX18AgTiE/6iHHHtcWVRTLr6jEl/RD+fMUzElngLEIKB9wEWS5Pg5hkIvVSAs6Nye9Jh+99I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745403375; c=relaxed/simple;
	bh=KELMROMrDZ3Z3RWtB+zIq7WbxTHDJwKrq7yxEw5FKmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bvlk6f4du0CvWqBGjsiYbwgFgppAReZmQUrzsax7fSpFguKz/yYXS/GjAw1IGDOhJzQSUBrwCLdX69EHkw5eInzyMa8Bd9XN7mO7s9VZuMsEl70jSRNx1YKJ+nzeMjcej4H34DgoSLXa4IBvCPvpT86mXG5K/Pwh92xbV7jxuxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=N71YBtHb; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="N71YBtHb"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-af50f56b862so4403298a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 03:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1745403373; x=1746008173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nu/COicFfCSB5+9JirKmC0bo+ZqPUD4Q6JrseA/5KjI=;
        b=N71YBtHb7R4AuBTWbWMOHUdJ1CDxlzRkwu3SlDPxZglk3tTGNn5qTA2+iqVKVZM11f
         vFfetT+7UuIJhIlqyiiUFt44PEBIwBiLZcc1u4HVB5F3oWVXm8UoEu9/sYsck94rKdMV
         7uR9YDQWNB5YaLxldUU/a0ts+lyM5MSps6JAU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745403373; x=1746008173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nu/COicFfCSB5+9JirKmC0bo+ZqPUD4Q6JrseA/5KjI=;
        b=d9UeS9LQn/EgohNBs0hELG/6Ojd0C0V2jrYB1xxokwXYsfeKdtKUYDh8zGIhHe6b+d
         WGHxerMVkC/Ik17R2YscwvyBEYEFevCWdbayft6rGf8hl2aGOcTBlFudqU6ajTXAVpDg
         B4kMhl1WpxOPVCspZxTpQwVa3/gIRdsfooKGBKH4d4njuGQh0+r5MQB3SHfSBy45/9I0
         Z2OrvDGqWwWxDFhQQ5xa/Xz7nXbjsRQIz6h037Z2XJoVExzXTv2Vi3UOE66JnvJHo4kJ
         a/GD7dbz05Yu7itAkS/ZMxXz1w3AthyZcEpWhwiQwGm0FZgT/cEVdJQEgZYjO4q+YsV8
         2X4g==
X-Gm-Message-State: AOJu0YxJP+dgyKxECku8TCRebT3QOiwlLlhxxSz8rk+y0mIkCCfLY5Gb
	+4o4r7fpasjgTTl2TulplxKMUlSkx27iLE1RtxeYo3nCrq81r+wDhhWOkj+sZXVzglCibbPT3jy
	3
X-Gm-Gg: ASbGnctUESLWtN6Upj8TnbOKyfYeduLB5xRtel3IoShbt8EJN1fgw1KQM4WwZhJFDPH
	UialsFkqf6GsJvY0rP6iGn0aNOke1hdh0IasGZjrE196EQ3OosM8ezRJ5p79GaRu/mCln9AE8mg
	PdA6k/Fj/TPu5uyFqZl3twKu6rIw2itGXfDE664yeEFep5WksVRqqWGSmQ5SgvAzQXA0Rh1ryZR
	NHr8QoVDUskoD0HXSXf9SvYNwQjKTzV1arnaveufOY0gNnp65P5Oj8uEwaC/6HYyakkPW5iTUey
	AoPZxeqmZs55dC6dvU+KDHl9XUyN49nhJUhyHQuI48wloSuVpFPEw9biNsXE+7cm
X-Google-Smtp-Source: AGHT+IHoKcL8ham/9hEV64rHjEhHrRumFMfeg57Jm1tvYhBNFeaGtZnW9BOqV2rwOs150uWWMCTbsg==
X-Received: by 2002:a17:90a:c105:b0:2ff:7031:e380 with SMTP id 98e67ed59e1d1-3087bb5331fmr29092987a91.10.1745403372973;
        Wed, 23 Apr 2025 03:16:12 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309df9ef918sm1205765a91.7.2025.04.23.03.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 03:16:12 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v1 6/6] Add SPAcc Kconfig and Makefile
Date: Wed, 23 Apr 2025 15:45:18 +0530
Message-Id: <20250423101518.1360552-7-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250423101518.1360552-1-pavitrakumarm@vayavyalabs.com>
References: <20250423101518.1360552-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

Add Makefile and Kconfig for SPAcc driver.

Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/Kconfig            |  1 +
 drivers/crypto/Makefile           |  1 +
 drivers/crypto/dwc-spacc/Kconfig  | 94 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile | 16 ++++++
 4 files changed, 112 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 5686369779be..f3074218a4de 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -754,6 +754,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.
 
 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 22eadcc8f4a2..c933b309e359 100644
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
index 000000000000..1f4689bb366c
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,94 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config CRYPTO_DEV_SPACC
+	tristate "Support for dw_spacc Security Protocol Accelerator"
+	depends on HAS_DMA
+	default n
+
+	help
+	  This enables support for SPAcc Hardware Accelerator.
+
+config CRYPTO_DEV_SPACC_CIPHER
+	bool "Enable CIPHER functionality"
+	depends on CRYPTO_DEV_SPACC
+	default y
+	select CRYPTO_SKCIPHER
+	select CRYPTO_LIB_DES
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_ECB
+	select CRYPTO_CTR
+	select CRYPTO_XTS
+	select CRYPTO_CTS
+	select CRYPTO_OFB
+	select CRYPTO_CFB
+	select CRYPTO_SM4_GENERIC
+	select CRYPTO_CHACHA20
+
+	help
+	  Say y to enable Cipher functionality of SPAcc.
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
+config CRYPTO_DEV_SPACC_AEAD
+	bool "Enable AEAD functionality"
+	depends on CRYPTO_DEV_SPACC
+	default y
+	select CRYPTO_AEAD
+	select CRYPTO_AUTHENC
+	select CRYPTO_AES
+	select CRYPTO_SM4_GENERIC
+	select CRYPTO_CHACHAPOLY1305
+	select CRYPTO_GCM
+	select CRYPTO_CCM
+
+	help
+	  Say y to enable AEAD functionality of SPAcc.
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
diff --git a/drivers/crypto/dwc-spacc/Makefile b/drivers/crypto/dwc-spacc/Makefile
new file mode 100644
index 000000000000..bf46c8e13a31
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Makefile
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_SPACC) += snps-spacc.o
+snps-spacc-objs = spacc_hal.o spacc_core.o \
+spacc_manager.o spacc_interrupt.o spacc_device.o
+
+ifeq ($(CONFIG_CRYPTO_DEV_SPACC_HASH),y)
+snps-spacc-objs += spacc_ahash.o
+endif
+
+ifeq ($(CONFIG_CRYPTO_DEV_SPACC_CIPHER),y)
+snps-spacc-objs += spacc_skcipher.o
+endif
+
+ifeq ($(CONFIG_CRYPTO_DEV_SPACC_AEAD),y)
+snps-spacc-objs += spacc_aead.o
+endif
-- 
2.25.1

