Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794662837;
	b=DtFytOUJ/xtmmfKFJu1uVu6aJTKjJp752PuMSeBChsfCnSo2Zf5nBW/gUi71Jv2PiSbQ
	 Qtb6+1FxMc8smOBeCSZJD1IrlJHU6xnK+zy4ToruBNfzbB+lEqe2BStSsje4XmdjukYI2
	 zfsMnydQugtnj8zdCUStg8waEdCMbl942/QEb7Xr4l9K+1yYgIZr6+7LfLIBQcepbdds/
	 /ZMy64qd9WaBaygaJ7Lkmbsn57W8NjaFQ1sqLjkaUfeLKohYuFHXctGdVQjz20X5Uusne
	 3Nj3BWNhYM1r2UJdEIW2QHShEwa3g6aSD8WJwm8rQngLWQHVGt0fYXN1l/bQpIq2h9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794662837;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
	b=Ckg9psebZ8BJjs5GcT7iXzVzBgtcZNcWKsH2E7U/CwG5DYwwQv3eRHl9mMqyRrmS7w45
	 JWurmws7Udo25K2XoUCuKl4L+f2dcU7hHEd8r05XWSdBXKAiJjKaJ11rOLQDotd1A9ha8
	 +kvg9H8MWgcfidhmolAL8sEhPjmR+laabAh8sP5L1ptlCn8EMLMbBH5OY02YpGjVtcKlx
	 29mQeLnCV+3SxL38DhyPPKr4YB1DrZzp3dae0/dV9eXFmUVNpHInHEBdU+tDuucgTg2M6
	 3J+8AJUjqr/f9mxD6f/hGe14sIqQPITTI6IdfdWlzE6QfaEqlEKVyoLg8qyuv3jijRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=DYUJmfnM;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01994606A332
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 13:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01994606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=DYUJmfnM
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1a3c08d6928so2604701c88.0
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 05:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1794662836; x=1795267636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
        b=DYUJmfnML8vIMSeTbwMRhyiyoE3vks9XdK6YwzPr7hTZ9VWn/1Npzs87ji1TQerNPy
         HQEEybkK942+gaeI1EG1CgbmtfHUgVpR6vGOsYy3xVlypYvnPY3mhdUxreQpjPtEJ25K
         9ZDaNR8MWm9s8RQwcJp79Er8ejoJCgImJzaGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794662836; x=1795267636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0W7YU0nqnNfpCHH55J3ba3Gg8nFzbCN2KphX9SzD9hg=;
        b=GvtTACqLQbnrnirVmhCRxqIuA9yQbHWtRVuC8Ww7rgpd8Cq1lv2RBd9r67DIYrB1Yj
         FRMeuNGnIzppdygvVU55lC+2p36GDxn3QmWsWy9IYnFlEx0dtc9Q5pxDFi+dWJqnsLF6
         ij6NwxUuFfAQWC6OZEIdg4sICRH6gHLs1Smn8ASZgF4wVjHl8sAgmnAfNWNvXth7aXTy
         zbF7my/apJ+05OwmzEw8ZvVBcw4kvCLvL57wOlEvzUzJZvdV5a1b5+g5GedqqQxWrj3q
         67PWk1QeBYQ+3+AR6QKxpxQPwVJtxZ/8lzMA+B4qwq1o/XJ+qFdnQ7nWuxipv8Ettrgs
         Smuw==
X-Gm-Message-State: APuU4Z/xRnUTzxD7qGkb/lDqSm1ftcipPcNb39qJMOiO0xw3Sb1q8Acm
	jDIs9JOeEXgn9AmY6RwFRqsmsszDuFM55cAQQxra+84ZInxh+gRVpKNI2w3iSgf0/7lHg64P6ve
	/0ysL
X-Gm-Gg: AYBFou2Rx+Bk3YqjifU8I01VP7XEZguHCucJ8bZoPxLHCquKdfzJameS5GWxjrs/cxT
	b8sc+2zNgYxKM7kl7r3uhhPD+5i/mDUOvnP6DszhOSgiwT3slj5pXx7wq2zwFcqdRzcH2xZFjSA
	OeQ7gZBWrVuDCR/dTgw9E64wqhCMCUPFkqyMwnuTepKmSIQBVpjSb5ti5qkuwcym7ZlqRqv/sAG
	u9frkgiRckuqCRxG6Fss+WWQACBu3FaZnoWfq4cmyTXlcryIgO7Cc4ytepnmaQlPBEjI/yFyhVB
	Nh9C1YLCTxdBE43QUnK3RGqD8C1pE4kpHJRlCag1eNjSozWhQriZlBZZ0t2+yzDloVEKqn459Yw
	wp0sJZZdNzgYvHHtAFkHq9q+t07mLf46QR8YfYCMuWJL0Ti4MElhYEN0gOmCL6m8gmIOnbEk1hj
	Shy4ti3kC2E7529qtauXFKCD4n8Cw9S/6aLIOCjqphj7TKuWNnlOu1mgpBG6cUe0LQ9yX45lNvW
	bq6YOYsl3UYDIKgb+lI6cPLiTZ/WUmYICiXL6Dl30CF0vVGs7//bGq3hYkCLNXZroe3iyCjcR34
	lwE0oxRK4yTG2E9ZCiqs+5tVEJgNnE1Gv5U21Y4pkHdpy1omAwoPSQ+SMXYusMGTeY/JgjS82BZ
	yuEU9fJVhkSv2t/TAkzhtKupbqy8stWmUjg9nClMmM7GMgyf3d1HzOxokGFAvekdT1k9ta4PV9N
	OdgquA/pvD/rZAAg==
X-Received: by 2002:a05:7022:ea8b:b0:15e:9126:c60f with SMTP id a92af1059eb24-1b5030e2ef6mr4837796c88.29.1794662836097;
        Sat, 14 Nov 2026 05:27:16 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50319e381sm15712003c88.12.2026.11.14.05.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 05:27:15 -0800 (PST)
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
Subject: [PATCH v28 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Sat, 14 Nov 2026 18:56:22 +0530
Message-Id: <20261114132622.690129-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261114132622.690129-1-pavitrakumarm@vayavyalabs.com>
References: <20261114132622.690129-1-pavitrakumarm@vayavyalabs.com>
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

