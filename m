Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3613376A0
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 11:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771501330; cv=none; b=VK117aWQulGqediZxnIaFbdloVsSVobzhJVF1dx3I4dYXt41AwwlIPeqN741fDMewdROnJxcaaX3NVyCVBQYTTcU6jSJTF9ykRKG8GI5SreCg/MK/VJknl4PuwDLq7eol1/hoLyCjI4dk68PlcLyJ6nLpvu9wrd/MI9y2HrQomY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771501330; c=relaxed/simple;
	bh=9+DQjUew8kkumdJA/hrPw0h+aDG9PSARamWRMqx9mNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q+wADv2tRWtCmG47XfZR5wkYo/8tHz/emv/flBaxvMFBZ4BYajbWk0b4ZZ5tAIGxakSsz3BU/cWb0F+0RJFS5Pc8+CUuA9tWRLTk1TlZJWsdYReO4Db9UV30HZ9kGeHRH0qn92AD6YUCLJvukt0czcV52kWLXw1hNvwbw7QN6WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=DyjCF5BE; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="DyjCF5BE"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-352ccc61658so319411a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 03:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1771501328; x=1772106128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KlFofjEDBgXa43lzOJCQ6xEpdr+n2zK1FZuaFtwkHQA=;
        b=DyjCF5BEvsNs02v48YKaE+4FyJ4tJfGlNqyw7QYX54ZQowOeXaOc8BJ9u4Qrjbfny8
         +hcx4ws95xkl4Vwtzuo1MXVJaWzrg+hQmI6ZNaiG/GLjSFyUnNg/OK9VeKkLlAg5fqI3
         yiuLaWv6GZrHKmPpp9RUvIZF+IKeQqAVHzcrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771501328; x=1772106128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KlFofjEDBgXa43lzOJCQ6xEpdr+n2zK1FZuaFtwkHQA=;
        b=jF9Lv4mEKdevhnmWmRlwyVBDVwBunar4R/NE1EWJmT2peoCOJrntV6dTDfyFkU4CyI
         orixhGrCv8qD2cT+7nac4KF95SJQGTlKoj4J0V0ec2cwqWNNjzdLWwawEUvbF++XM/6i
         EcE3mtZqZAGP3bc/43pOzuyjVkmAEUy34eNy0V56DVAHp6ImcVL3FytozG3ckxMFHZ/M
         ngaPe17+VKJGBaNNwxLR80o8CNM3gmGAwfGV2kSEkQZrUfjNcVuI1JAp/GGUVhFhAZcD
         mS+2/ZeYmq7SOTKYVZpGjBAGZ3Ew58HNEqTwKRV+A8wzOHE//AMUYa9gu6R/UrUSvMsz
         xeaQ==
X-Gm-Message-State: AOJu0YzXGoIdehZyOzuRH+V0pJoCFQJiIugWMJWnM9WpnLAM2AN72BWn
	Z/irn5Qk0mzZMJKc4HAqSlzSGNxGgE9+hENUhkGXqH7UTm7Kv07ALW8xxU/8xNlnw7vKPG3jev6
	MerFM
X-Gm-Gg: AZuq6aIaRKBtrUb9E+iwovOsB0GNxwXDU8hquOORcQglf5s44q7/eXRatJHcUIUMwBn
	NlVmWWUVsK7I8yszy6K9hbKT5bM/AhFe8znkedRly9D9c+WtkScTqXpYT5c/T9L6FT+mvEtV8rs
	jf82cB6uGdr1nNLfFrXjRgWFsfwW1fBv2/Q1I8wpc/A5ZIEE+GxrJiAIJVhgqe/+PbAmVEUDKrV
	zk12xKsXpXHlTMOuc0qX4Jk8rTkab0VT8ZL/E+FZpCd/dYC59XAEuHlv/MFtNLQa+D9l9cuqvzv
	eqPV81VqMXuacKd5oClLEE3oKiu596NLlG3558we2yihSMHbchfaB+NLGzZODXUzSmuKY4Y9TqH
	4ssAvx7f3hbt0TBz700S1DXlFA2kVhT/eujpQMLSiO+4GWIT8PCDXHK7x+tNmeZO17mJOQwOvFF
	cI+QfuMWFCUl/vmcUodZsVKsp7sftkPTqYCGJ6h5D/DCXGEhfWeTsQGPSBYHVe3wGdfiimwhCEB
	mzbi1QgHQMDPTu/9Bwtp1CrxKlBopWWVY3LAr+3TJqWHCaNJW6ic2Ji3BpRD/snCXA=
X-Received: by 2002:a17:90b:17d1:b0:356:2bda:a857 with SMTP id 98e67ed59e1d1-358937a4e0emr2366141a91.18.1771501327905;
        Thu, 19 Feb 2026 03:42:07 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm27442358a91.2.2026.02.19.03.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 03:42:07 -0800 (PST)
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
Subject: [PATCH v10 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Thu, 19 Feb 2026 17:11:30 +0530
Message-Id: <20260219114130.779720-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260219114130.779720-1-pavitrakumarm@vayavyalabs.com>
References: <20260219114130.779720-1-pavitrakumarm@vayavyalabs.com>
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

