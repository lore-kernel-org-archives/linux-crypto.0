Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793381199;
	b=FeS9lWumPmCkqJD0WBt6SOd/Z3GtEeFLX0R/A5oytE3lAn7hb3swJcEuZBl38k5iPFZ3
	 Jwy1ld13X/HKs1K/6aLSYS4aQxmOH/ezYemw4E8qB1Q4wYHDQy1LiJxtfLp5W4okSiOJV
	 OPpK8oYnmlgVIB76a4ppnTJr9mtNn+9IAmPjupnzkbhfHU7VKmGvBvPbgy0hXEtfc0H4g
	 T73t49bLarfXsZdNBNvNqVRTdHbgsw/tZBBsQolq9umG/kGGmt/zSQf+2jAMRztYPd4VM
	 Ltbi0ySHrze96vFdzQZhmRPSBzNc9SrCf7XHZzeERc94Gp/ysdLojYorfumLnRBRQ0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793381199;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
	b=V5Lz/jcfKBFaNAqBD8IMlRUnQ1H1BCVBIrmOKU0T5w0c2pdfLK5Z0DZMTbVadUrj5Sj2
	 1WEDimil3Zg5/ueaeZK0opEnM+8FIuo8rHQ0RfnVRZiWnDMtXP+pSmrCSPA74S5WcFwyY
	 4e2ByxcDGg77kO6dFJbE696q1Nf7qu/y7XdNv0Rn2aQin53wrDNGTCuw7eWpipguwTXRs
	 E0aQVz8sXWO+vNQw957T6Sy21PgXgx+IJKjjyNtoBdGC3xSbf2sWz7t7zAWsLI71Ylpnj
	 UKInfRb9sdO4CMJECyrBx4LbSqNn+VkcpvCda5hG7Q0soHnArZZgXeXpuxNp56RGReQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=exTwvhbq;
	arc=none smtp.remote-ip=74.125.82.44
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC39606A31D
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 17:26:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACC39606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=exTwvhbq
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1adbf62dd31so737138c88.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 10:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1793381198; x=1793985998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
        b=exTwvhbq1wSNUWxy4nWY0ZDbRBFEYpa9zSH85Fg5666ChEWQxB7CrKdbnHZMmff29T
         2ocTxig3Sz830hBimiHlnInuIOmRe03vkN/upDiKeCL7ZvtZGI8mbljfVM+Jd0k3o6FU
         BmGtyYbZcsPWNIl5J3T25wRnI4yq9Wxhlzocg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381198; x=1793985998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
        b=uvEURLa6b2Bp3RXfxTr3v776Czqhhae8ycKgRieGt1xh/3UZqwOCtC9yT6ULiS+KUs
         4X/uOTdw42cRMqHSOZ+Grra4x4epRPZJmV9VMZzL/nsrXY+P26LeMDmcawufi/taSuJH
         IM0o5yIth2VoCExyAk427fZ3Z8pYGNv2qSjgflInDmTGdZFuPWdKSOeV9AbZmmPzjqVF
         S27hpX7P0AyWhwlXHI7Ezef7Dlm6TYO6UjrDfg+CAvZXqW6cqEmBYKyyvIYLLdZM7YQ8
         k1I0JMXVEUG4yX14IgeNI10MVYN5hbhL3BHx0vNc+DlS4qiipJJy1PZguwklKfpdpneq
         aW9g==
X-Gm-Message-State: AFq9FYJuzQx+75vHmLiHv/BAE7xh2QIg0cbspAFRfsC6nM+U90Kf36g2
	BG396X9Ja//pcPchcPnxxAERQrOx1OM7ERCN1Iy/2Cp6HOLru+VaD3Ue0qLXa6a0Uje3kqkg9M7
	3W6YG
X-Gm-Gg: AYBFou0UV9r2JLlkXb4p3vOUBEpM5y1Rb5mQzbTO8dKm0meSYT18ICNsoEZGZ09ixsO
	f2AIkEiAlLd94GG9LqAW6OHjxe+Uey17mftFl+geVkhwTj8s/odYmkpsjazahtXyYdk85WDHDOl
	vSITkharY3jJehyFGYzxecuKCMDb6LgHulwtM1Y584Es2uaqJrhtoEPwNUDYf73mSXYUZsE8Njm
	EzLm64MhWJylSYp/04xuUhh7duzoxqd+2R9WzxdOeu8wd1sZnogS6kBPRYIBKigU/1SMhlCptGw
	6GzcuWYdCAADfhqGlplPgfRnlzQW4yxZfjdHrrofGbN2RUUdMG71VVQOvZNHZgzBvtax0CHWLvK
	Sl56fVb58T58FEZX7tFNSoIjL3SuZKFj/3iHfS8ERo8gShHCDtzMODbaKIM9N5QHo1c8VbQiXle
	FnsdshjKUj+Anuj0FJnSRshseKAlH0LkZ09byY+I5njqXk9lBJLg1M0S8QQVdI7aBuHpBL5eajJ
	YmlKxYOzjyDk5WLkpszYI1OPZ8KGP2BXap9wSj2XVQfLCnNQf2x+LlQQ2+fS2Pz8JnaUojsuyEn
	CcG3rzaPh/KQIIt8uD8JAV32dxTlVW1zBo/4u/rWoKxpumsm4DnVjt8+M/Et3aN3cr5NojoDwF8
	hueIl5cV0GKb/pAKX3pZeuMdkQ6uMthr1RQmsifDG3oJiZ0twDPUd2iJK5N7UtykOLya7
X-Received: by 2002:a05:7300:c00f:10b0:36a:1470:da0e with SMTP id 5a478bee46e88-36a423bececmr5123560eec.29.1793381197701;
        Fri, 30 Oct 2026 10:26:37 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428ecb61sm7641152eec.10.2026.10.30.10.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:26:37 -0700 (PDT)
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
Subject: [PATCH v27 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Fri, 30 Oct 2026 22:54:56 +0530
Message-Id: <20261030172456.274744-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261030172456.274744-1-pavitrakumarm@vayavyalabs.com>
References: <20261030172456.274744-1-pavitrakumarm@vayavyalabs.com>
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

