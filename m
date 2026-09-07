Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD5450C2A7
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788796821; cv=none; b=N2Ck3JgV5hGxKf53ADfLORiyS166J8v384dkJK4WXuNXf2u0NSs+HJv2qii6BkPW8hRXGxVHVz0TPuFLqdM8nJtOTERHqQEUbe2iJCTwbUERdCp+QCGt9i7ljixExgZFV6WZNBdpZpaFg6h5IAdckrF8yYea7xaGZnGje9yDSJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788796821; c=relaxed/simple;
	bh=+vYSXAdB7mdZUzzraaWojPzoKc/WyC01Fzwr3gps7GY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i9TjS9Sr+Hii45HdsSVQveSlEGrIEmwS5lChkHtQLc41zZiqqXrc/QUOrp80cSNx2vbD9ixqeR+bpZv+E2kQ55G6j+weOiK/9c5VWcxE0eVH1QB+AotLHoKWbcTVe+qK9uKIvyNP7RbPUdquHdacHOAY+nakQ/Hb/xD3J46WcDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=QKrbicDH; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="QKrbicDH"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc147d86bebso3201356a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 09:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1788796819; x=1789401619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kfdZ+27dsteNmPPWYcAlJOh1CClxN+nuAUGat2n+hNU=;
        b=QKrbicDHGgTfDpiNEZeq/ug6Fp1I6iDBT9R6W56bE23mUBjv4PV8yqdfoSvzH9UMhJ
         nOFQMCOrZxAddMIIh5APUuwOXvfN8aRNiudS+cvRRnhu2EHAFIS3L3yxFaBi99JSpJm+
         E587d4MgFNUAnirLBX9sadwwqtHqlPKPoE+1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788796819; x=1789401619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kfdZ+27dsteNmPPWYcAlJOh1CClxN+nuAUGat2n+hNU=;
        b=VYgqY0+3UHkNMke+2QdKR3As/q1vQdUVcUVf8sAhnH2haNx1YxbAJWsXk97VH5JHtl
         EYdASqBA47BkKSEAu4H18PrlkwVgesn3ckHO/43nA1WaKr2ZRXepGLWlBkPwUuaIR33g
         7Hty+H4YjkhyyrGdwG85zzUnxuhX55hT+QAQqOeEgemuPGr6JH1mdOk2xKpMK77lX95o
         a3vA4U/bRr1Y2Yxn4ALOt1NRs2wFJ13KUv6+dq4/QzX3st3/oE5SfjlKjCL/5c2WBg78
         18ImBbH77A/JLi1FnPKNa6o2VbHamqWzMkfV+riEyWuhD5Kmv4B++L0v4dSsKeN6PgLI
         sLmA==
X-Gm-Message-State: AFuF++ksyTFWfSeY+LWCbXU6xkPgZeDK/83xZ1PyDE/cjQSdfaNxLaU7
	I7t+4hG24YY0F/ienqHsRrv70R/76fjke0Uf7B3YT9K4TAEDEKNzyYHvR4eVTUmwDWTzs3elssU
	o9UkU
X-Gm-Gg: AYBFou1Dc6iPyKI7JA08ZKJ6C6xnnV+6BhnPCtZNikF0DZXZ1LM1DEuuTaaZLB4ZHyV
	ORPgyj1v6qBoCm1OLFNZUFQKmIlLz0sNt98qUlnWeD+9Gt+0554rPn7fO2uEREvuhDW1lNSghbo
	EhK4lzSegal/jNP8+ipftSNy498u9RD3AypYsLryXMciIV7DK8+XDDxo9QCOKqRn0h9X4O/eW6u
	jMOx4gwVACT+k5Bx+tzDR54FGvL11qSZPBnoaOKmBTm2BGKZrMdRblRZWXcamCi3/cS6wsUkUlL
	v/RMtUj2GlcFfntkd6DGMhLFkFVfU4DVjBM/tH6md/+sNFqiRwc/Q3y32ySNKEWDfz17mYE4mUL
	9KsrYd7EIqwtWuugOiVIUMfgW6L0QJRVMglHJLh976yDl1RYJFxFyKzxdN8uQ1NKpSD0jKxvNP4
	1ybkYMih0i8rAP+IXxo2TwwAaj3O10KP7+UM/0Fxz42uM9xSdg5z3Q413ost7+tgFsS/0dxkDH2
	kKu+RmRvN2S4VdR6AjbPfRyeGq9JSDcBehrTPM1RHP6/ew0q6TRPatvsGiTijJsTDgr7OZdrqTY
	286eEF5FkyvmdHDkc5dCDSRqShTx
X-Received: by 2002:a05:6a20:6a26:b0:3c8:e304:99d0 with SMTP id adf61e73a8af0-3da211316femr26644951637.0.1788796818456;
        Mon, 07 Sep 2026 09:00:18 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm46065613eec.16.2026.09.07.09.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:00:17 -0700 (PDT)
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
Subject: [PATCH v25 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Mon,  7 Sep 2026 21:29:16 +0530
Message-Id: <20260907155916.999153-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907155916.999153-1-pavitrakumarm@vayavyalabs.com>
References: <20260907155916.999153-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/Kconfig  | 65 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile |  7 ++++
 4 files changed, 74 insertions(+)
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
index 0000000000000..82ea907a14635
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,65 @@
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

