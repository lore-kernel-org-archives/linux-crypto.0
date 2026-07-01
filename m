Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B70B481A91
	for <linux-crypto@vger.kernel.org>; Wed,  1 Jul 2026 12:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782909161; cv=none; b=TNJqxtXCTo6lHXA2kE2uKjWoZZ5dhR/9FuvDE4y/FnEx31YS5v0lA3iCNzVnNiMy09hqObFfhpormqJDqei4Md7CM5cERxNDj7nu1m0t9wWg4W3d/5JO8bwn30CUW9q8y6m4uuMkNPE8538OtG83QG9s19W+txLtV/9CkeM0nN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782909161; c=relaxed/simple;
	bh=FnbUb2fj7mS8FvtSY2ctYhOyvfQQIyc9xP4UTl5q0N0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qn4THKB/j+QI5mirVWux1QbehNTHdQu5cgLF5Y6r+9hmiVX8U72sdQL37uBAfQ3fV9vBL00E3DIySQ7fn8Y/NC47vp9pZAeeuqkTOr4Ra3JV8GBsqM6uc2+k9nDr1mR06eMfPAj9sVh+9z54uiHHJVy5yDPTdbPIYnpl7Wy6iMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=BZWl0fQ1; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="BZWl0fQ1"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-30bc871ecdfso999261eec.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 05:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1782909159; x=1783513959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/PsSIQ+vvmUu7ZGpNEkF3m3d7FEgCmZo5EF6wbWhukY=;
        b=BZWl0fQ1WmPWGjgMYwtXbpGIclfyi9M76KZ7DbIclCka53SBKxoprdW6CeEXzk6XOj
         dAYb5gJtev2BPqh+mfAwYTMq7pT/P52NYz7MkK+eGyniqst2KnVDAECyT3huwf0tEvVr
         af838+M1g53EWqjgBfmbVOKkBaku8RZVgTlAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782909159; x=1783513959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/PsSIQ+vvmUu7ZGpNEkF3m3d7FEgCmZo5EF6wbWhukY=;
        b=ZljhmrNf8r4WterdLJP+iYuhhPizsU0zHTvUnFoua8hLx+T9CgX/4RqjQ6LwVC2brs
         dZXyJ/yYuz8dlg6D3C6+RvRORC22NajRVal6thinyxHxUDdI1yOTuz/7oS1aBQQe29sC
         owJutk4fUM64BLDwKDJLaiILrn/MPMPGmlioHpqyFq86+irwAHu+Ed+mZjKnqu0Dukpf
         lyOLL+YEonJ+T3RFReAAviyj7TiEN1ZAvuMiwWvxvsqmZa8NLsqM7M+YWYNJOp/si9Nh
         Kc4NzdE7hAdl6ufuvOfBGw+QqRQhmIM+TloS5DdWU/rXSRDWPQAZhdehBJ/2q5hvhIMl
         6ynw==
X-Gm-Message-State: AOJu0YxoCkTf9zHJn6dwajsW2TJocZYh9s4s+AviwCMSi5RPi3iOQLgo
	E1OlJ0bdQTIMxW8+iZMpaC8nDrZgtq9rptmOUK+BL8/15MdV+MBdEAqLC4lwzZ2BK8tMaromo8g
	Afq7f
X-Gm-Gg: AfdE7cmucSBRWND3PEEuuTiaS/ObE3zVadJAP7j+PRRoQ8NVH6zWGrGfQ/zzbGtZPXw
	22bBe7EFSXFS3JaX9J5f7h1oKah3CPKCZyHAyZZ1l6AH9U0JA8NFfPrlj9znTMCzpIni8DRjAMq
	pbQw9U9hkL8hOZ+AG+ZYZhUwKypsP4kJQT8sKOS+36r4BXYvw73JxkB34ewLXO8m5EYecsbVqW5
	/d70VKyAQqvr6cLrMYpdZ5sSm9YSU2PxEYNHqA2suw1IW4FAjEdQebkeDxkixa4eRwXuHOeG8Pe
	rAtMbCsaXimrQfSc10zOHxEW3ERh1AFY3pnaBvkj2a9FFBQEbKxQFVioZOQKuKpZq5RcATbkHas
	e3z9a9zG8/K155taidRLmXgkRtEwq8iLZxZyUy/kvjL29FP7x7QCuZSbpUDB/cUldW2CGm4z+Ur
	CICrYi9F6MuWHoqdY77HEEyrw6tM8912c93u0i5gUFcg0VwF+EP0aSNI9Wucv4/Y55QRk/7BawM
	2FNryLwPVTsPgod73XP+csAJ5daSMOpQQ8Hg6OQPCpf+l/xN8xL4Ani
X-Received: by 2002:a05:7300:3b28:b0:304:bce9:25fa with SMTP id 5a478bee46e88-30f0524f50amr706702eec.4.1782909158919;
        Wed, 01 Jul 2026 05:32:38 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee2cd21bcsm40776402eec.0.2026.07.01.05.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 05:32:38 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v15 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Wed,  1 Jul 2026 17:59:41 +0530
Message-Id: <20260701122941.2149121-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260701122941.2149121-1-pavitrakumarm@vayavyalabs.com>
References: <20260701122941.2149121-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/Makefile |  8 +++
 4 files changed, 93 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 216a00bad5d70..280a0165ddfdf 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -742,6 +742,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.

 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"

 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 5a950c7abc393..d463a3f101963 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-y += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
new file mode 100644
index 0000000000000..a9172606d77aa
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
+	default y
+	select CRYPTO_HASH
+	select CRYPTO_SHA1
+	select CRYPTO_MD5
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	select CRYPTO_HMAC
+	select CRYPTO_SM3
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
+	default y
+	help
+	  Say y to enable Autodetect functionality of SPAcc.
+
+config CRYPTO_DEV_SPACC_DEBUG_TRACE_IO
+	bool "Enable Trace MMIO reads/writes stats"
+	default n
+	help
+	  Say y to enable Trace MMIO reads/writes stats.
+	  To Debug and trace IO register read/write oprations.
+
+config CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+	bool "Enable Trace DDT entries stats"
+	default n
+	help
+	  Say y to enable Enable DDT entry stats.
+	  To Debug and trace DDT opration
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
+	  This value configures a hardware watchdog counter in the SPAcc engine.
+	  The counter starts ticking when a completed cryptographic job is
+	  sitting in the STATUS FIFO. If the job remains unprocessed for the
+	  configured duration, an interrupt is triggered to ensure it is serviced.
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

