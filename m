Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794666221;
	b=2Khhheuf6QVaPlwmPZ8klbndyd9xETV4Q9mXFPR1fynKDZGHgNNKxY6cQUOCfLL8VGmC
	 uJn20i8zkoeNoiHNbRUS1SEe5O+BLmjo9AJpXR8vR46NIkdZ5ShBudrpG16uL8LVoiZfD
	 Jsbudpi3s+kOK1H4IRwm19Y4CwuUFQbkutZMCSLaHj0ElNBqlSX//fAGvQAQ5sA7+qXQM
	 zMBi8uKu3DrT9aEw1cAIT8pq7lytfmU0wagHw0vvnVUnj1QNBgu1eLsLaqjaKqRJ6ve1n
	 ZQqqASlpCy0LgJm9x0tuuwa+v0n57bmbOA0FgLr4E1NU21Eua+SPpryvzC7Tig/+OSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794666221;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
	b=1avv2DGo1gn8S2t0ReL64uQVsDRG8DpPOUQWIGy/LwXRXV2Afda9JqEJZ0MNZbmS8wQ4
	 xoGBJgOIcp6VTeTMxKZMR/UaUii9Oqq+zqGPwWjLS+sVnfLzhlUuwKlyxstbYipD0TPuk
	 js9ZQnXhO2aO5P8mAI8h7Jz8BkGxfxIXo/rTh6daxANkjqlA55tErGgqizumi9e4KwUGR
	 I0q+s2hf7x6A1BuEOpAoRWCYw7cKUqTITBGOCENuUZjzl0Az6xFTMsdDd8PbGSP0SF3xN
	 sLC52gxxieIb6m445EORciAgjn+XQzjCTVB6wk8tEGCdWD4xlIKV3thgioSF6DLb1hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=TYdHSwT8;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCDF606A330
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 14:23:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BCDF606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=TYdHSwT8
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1b3b4bcbfc9so2039316c88.1
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 06:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1794666220; x=1795271020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
        b=TYdHSwT8Fdi7kBnH+zjEag50KdubB6uWXYmuHAn9YNQ89y7Nx3zUyLizRLtOiwY1cr
         WHiwi+6Y7gCAVmpQ5XZ1DXPDriJIVVBTi0T3aGkTzq1Ek15p46eTkyVwafb9awIJ+KCz
         mPKQ8lRIMY5r7wBd+7sLozRnFt5gkmrRUOcuk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794666220; x=1795271020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
        b=AImQ3nW7BV3EFa8YiTNOCghCU3kCMyXXAFf4OyxBJ6jvZ41YLl54UO4vxKwVkKOKSP
         y31GCZU4nOkP7WCOalYnxdGZfnVnGP3HTbO7UlWqZ2OYdN2382OS+7tkjWC6cp0y4Srf
         8pHLWnfb/SIf0l4WmwZOr0dVNtLhLFg+1CS5qsi8Ur7okmSMMXrn/s6vAJWWj3GHiIeD
         UDBaaf2z8PXi2cp+hrEYc0FSWZt5sB+5rhD7AwC8C4v+NyvhhPXF53DQS7YjKlb10Z3r
         FhSTH+kWo75LKeUanqns673PT8iCoH0hCcNJcXywq6zOiIWIFyjs5B/PPdgsDEFpzIVy
         Nx5Q==
X-Gm-Message-State: APuU4Z+iXF0SV9mSaGApliP3v37zzVpl9+Cp3phNh4PYQ0JnAVn7lqH8
	XLWaw0WusgajYQj9t7fHhW6fvyODxYxf/KxCf87+31/CiyXFLabcpZF9txMJdNmLLqiCVuXobuK
	5s/WL
X-Gm-Gg: AYBFou1V1JnsFIdbu/KblYuv7G2xH6tv68uZItJDEMDA/IW/FSYyAD0DYgNAriRqfse
	DZXQr8BVkbie/HIOHNYU8qg1OBcXhqw1nQTCFyvM48YRkKhjcbxC7PmGjcFCoOma+N0AiFtxp/B
	sqJP3T3R/X/WzQpJmUKLiXDW6GtTV6RuXvxHPJWbq5Y5QNcQfvXnLaoAREWGE6vJ6xcANx5QcCE
	E61O+DBpv8qclBQcBVFCWY8OsJBjbuQOgF/j+rBw6iv5Wf1TCpWL3wIHIAndAqkCZvfBDtYpOkf
	/dLjCkxost7DNyV97ruD9wCZwKWty0att2LmuI7bqNUqpweK+UWYduBAZm80qcBFT2RAiynBiCd
	Sp+4gAAhRt2tS9cw11TYWzpvbuCtgcciO6D1q7elqZkGSXs8A4vZGhkuKouPyeLwgpaC3fI+bN/
	DmkKydPT/gKVjDPyN+1OvsnSO5Bc32NRJ0HKtydHo8JSCylL81/z0pxAwBGLr6N3XpVG8ll7Dkt
	UtZSw4lUCDkEsOYnraJ5xFlnBdguSmzz0Wq1zUg/v/++UZG2m/dfY/1YGIVH5D38DgRVZvenshj
	V/DLYdA/54GFieRPAKL5pFg4co4pZ3skRrHq5sHz/IQd8poxXeGGbQ3guovWy2GMMema7PQGWkg
	f2N5PO7Z449uWIZGVmIXgcFVF4HNJtbhUVZM8T6lkHSWfIWzCwO8PyGjyg2i3tc34mb7x
X-Received: by 2002:a05:701b:45d8:10b0:17b:fea8:1425 with SMTP id a92af1059eb24-1b50315310fmr6223169c88.30.1794666220211;
        Sat, 14 Nov 2026 06:23:40 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50316e195sm19376962c88.8.2026.11.14.06.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 06:23:39 -0800 (PST)
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
Subject: [PATCH v29 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Sat, 14 Nov 2026 19:52:12 +0530
Message-Id: <20261114142212.716906-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261114142212.716906-1-pavitrakumarm@vayavyalabs.com>
References: <20261114142212.716906-1-pavitrakumarm@vayavyalabs.com>
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

