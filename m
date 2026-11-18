Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794983756;
	b=mZnr14q/hsoKqpPl7KjN9ocxv9N6Q5+7TqTpn41GCLxQPwDN027jlq3NytGpYek9Sy35
	 VkjAkcFH9lmgaNd8qy3fE8dV8c8Wp6dd9BI0ysU3xtX74+ZQUtv2qeZp4vfqs+inJ9YWw
	 c/IhFIQbboMZqYb5bh58oaAkHeiV+4bpVxEAOzRyO5rVGf/O9GozuiMyWl5jshY7dGwN5
	 fZBKe5M4IAxsf32xT+GESkzyE2K0n2KQ9iyuv+sFSkkQ/RHg9VwtDuYqIrrO68bG4al2y
	 ZPPDOdU+QcQqrb1YiXztYDzuG8W/rh2/f4+J7laOmE0XD2JX5BsHyg492Vo+u+9Pp9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794983756;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
	b=OTCgYfJvSo3vMwtnBGfmuOdty4dECZpprMknqXD14tHPaGsRj9rm6MWvmjwMR0+I/QgW
	 5vEl+jnJLPJKmD6hZnTKU+NPjBRrMla09ksqpYdozI+saJPksH8H8CtSsNeDnufgeD7xO
	 kdB7oJgcfVrtTOjxb+qvn9U4qVNbXrpTbKWnMFbBtC3jlxb3nx/O7jok90zdbtaL/2OKU
	 F3HMH5ZbY5chgKUR8aVGT+1iWTIxziTYT+Y6yxVg1myVOh8b2LFAqyVel/LJnv0j0OXyr
	 zoL5lAmW0werZl83S0pXEww47NvFArOIeG4JjsW6vVK8z2rm+BaGVqKZcq8H3D4UwbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b="BUGIq/fI";
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C715606A331
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 06:35:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C715606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=BUGIq/fI
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-380c28f9e35so1922427eec.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 22:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1794983756; x=1795588556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
        b=BUGIq/fIO9uIOIrlMQDHeKoCPKKxf4/yFsMrJpX1DTpgJZx3b4wOoHjQ+P3MMABBUm
         xGQr341C8zrbAG7AjCtmuqzMUM4tPmT3y2XbSZzSs8zx+83mZzYu/gVp1YPII4eWhP+b
         1+I6Ax3+vs0vJKIMDFgv6JTGJSvfP5ex/gJpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794983756; x=1795588556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
        b=x4Gi+HOaQ/lpf5aQLL+atdKLjwliUjlrTyQzhpOsbxxzu/bA4zqczkeRR/lPaHJuGQ
         r2YztT14Bzivc+SULMjw9ZFcVqsYBvOtMTqjEZq8Uld9/xdR1K8Nzy4fB4DiWuh61VD/
         wyVkwb3D0mIh+oQHoWIb2PJ237HOB0g8uQJx8APh7xp8VoDkwlVkKmjh7N+evRthgx1a
         kifgU3cPefY/Ivn6bKNQNECHz/luZxd3KVefgUZ7X5v7ZVNwAoayLYHCHmLItKG33UQk
         GtQ7OHchh8O2JCxNhluo0sSTAP5Ih364xQmssnQMi0/FVNpmU0oOj1dKIOytFKLF/zkL
         9itw==
X-Gm-Message-State: APuU4Z/P+hEFDtvs13WR8VT29pkS/PBGCxLoLvFv6/X590ri7DLpWpCx
	vVw2yOEE0q5+J7rZPxbqglvTQ2NGmp6Yi2oY1Pk0sRN9rSiBaB/QaA6aP1WXIRyWU+ttQiFNXYa
	h1IZpuyU=
X-Gm-Gg: AZFdTZeCHxemQ48Pd7LQuYARUdUbrf+HmnLsi4nGtGBl/eC9NTJuUO7imJiJwOJKb3w
	ouVTZmzvz79MzeSIYEGT+nao//YlS+nikPurlBZxzSD/aAqguqX340PhHfgQ4BbXk+Upk5V+Ev6
	9kpMNuFH/yXbpFfvHDIC7SpR5dmHdDz/DtU3CHiBoNwHQCBZWVJdqOz7r3gnMp6FZB62jJjioo8
	xbJapR8qDBlB/IxWMyCwpd05i2IqTOYjUdZWklYAcYEt2YBVlnDp1QBuXfFYMEzo5bxQVZYgFKk
	HlJjayHag7fxKi/OK99+SGuicLv8Qu+eDc4ySMCMil1oH4ZY6J7+57gmuKtB+ZybYUVzPwiJbEB
	W4POsOZhBmMTHqhaqd1hZzIb2X8fYSnOvYfqfaVKFsIotENRBscDnB4v6HK4sbo7SwXQxd3mQCG
	EwPr7NQSaQGPxFzFKZUH9oDcu6pZB4PO4JMvQT7Jx+Td7CfbvL2f7I4p+ML7c10yp280S8u+/+u
	lJU3PLL2wNTGqbrs5fzWABi2qETB7px1MgsEW21W3M7s6TCsIzWlFX4VTvX5Qqwj9DAqS0s0Z/S
	wBSlzT8MhTfQI7KtfW+Rh4rLmyrcsZ9uRZ9RjO4v9x+GyoH9SIsMl7881pnE9eTJux200dpYUQ6
	Ai4zU8GSWvK5cUpza+J9b2A5cjD9ZhjuB7J4QId5SnwfPwFM8pFddIWjL8hb6bxsa5DVK
X-Received: by 2002:a05:7301:2019:b0:36a:2f6c:490e with SMTP id 5a478bee46e88-3810e419e97mr4421701eec.6.1794983755563;
        Tue, 17 Nov 2026 22:35:55 -0800 (PST)
Received: from localhost.localdomain ([103.219.60.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a72eb2f3sm5002338eec.18.2026.11.17.22.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 22:35:55 -0800 (PST)
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
Subject: [PATCH v30 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Wed, 18 Nov 2026 12:05:04 +0530
Message-Id: <20261118063504.835259-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261118063504.835259-1-pavitrakumarm@vayavyalabs.com>
References: <20261118063504.835259-1-pavitrakumarm@vayavyalabs.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
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
index 0000000000000..b8a7d04209112
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
+	select CRYPTO_SHA3 if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_HMAC if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_CMAC if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_XCBC if CRYPTO_DEV_SPACC_HASH
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

