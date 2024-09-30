Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7901885AA
	for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2024 09:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727688700; cv=none; b=bO95o8xC9QhD2mVkZGbt12IdzTRbbNeZltI5wYBpJsTc64zctxtLgx8V+AhJDu0/yfkeIfoxmNBRw7wMYGcRp+pbnQEFF+m/XI/mqw3KUjsLX+kEmoOMo/89acrnXrN6+/oScWPMOwJ44rqvGja16Lo0fKZPrvrbTKZqju7/7Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727688700; c=relaxed/simple;
	bh=WvSYDgTJt1KA5Twf++iaDwp1xk97LgOWXQmftK/L5n4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IGtQ6gv0Y8SyBzXQ1LiPaf2H5Q6BPCIU2I8B2++t1JIxyQbTugYzG1LRoiQBh6GFzgJe6Zx21hvRsBx2jyQZknZuelawbQh2aJ8miwKjaoeousxIhL7MXqfhyCoGDP07Vx9XPBqcpjZTeOnV1TnciLrLBWxVSFHUUOjLYqn7Gc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=HncNsQ9c; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="HncNsQ9c"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-71c63a43146so1631171b3a.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2024 02:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1727688698; x=1728293498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ApJUv3ifafyG6F88SylkU5nhcYTsZJJsykbCBTCXSc=;
        b=HncNsQ9cExQJ6Y+RoCXZm+Co/BBOPLj4ltVlhR+oQxUjgnnN5gCeMzdedA7YZxwbvY
         n/0IRmhOKPJ2jTlZEEhj5pgr8ZOsO1x1w7IYEdOV9nq6+2txCoOmzfjIBFtXrd4SkuIO
         XkA1GuONocTh2N86A/SY56+Sxz4mQTjIvwK0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727688698; x=1728293498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ApJUv3ifafyG6F88SylkU5nhcYTsZJJsykbCBTCXSc=;
        b=UlOkQ7SHmf51FzI70S5iaCM5VOApzK8Br/2cAiTMzLfqJfJpqtcCeNgAFND/wtvwA5
         FzwQTt8zb+1P5pqvf1gqHE15nIc0v3qgAxmV9cIm+7EvCxne5Hs5Syhde1fqX42Xf3cM
         ndeXCfPPEmcyflnlMVL5++jd5GjdozOsKnx9V5D/PMN/ftYiuHjR0Hfda00k/+0jKeKi
         kHUQWhaKes+5PLrmIv0j5rb8ZVtNaIs1Kds1jbaEzFcq7BeMBomxh0NRM1x/Fs3/SJFL
         tpIcq0hHRSaMOaAfSQ59CxJNnbDoM4U5yOOVYeQOQMyWsLdBprqt5QVVBjb8LBLUZwkj
         zScA==
X-Forwarded-Encrypted: i=1; AJvYcCVWwoIFJQYx96lPZDh0O41W4/SKUW9GFslaI8+EVUC96nhWnudhosgnEyj74rsLEqoiGcVJam1J6tCnXXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHFbRgno7Ls+BX6KiQEcQsvOfuAN5vG8kYnBkVTLa0A3tWmWMf
	VWvI002MurwPHbkbPA/nD8dgGSybKvKaabrgiFX5kzDp+AJbKjwTQm2OY9YAu2o=
X-Google-Smtp-Source: AGHT+IFzEPdI7RB14PPLDdqYbNUbQauaLFfnBwDOVgrXdW2UAmQhj1bwOqNLMmMQN6ni7xDL5xVnZA==
X-Received: by 2002:a05:6a00:2350:b0:714:2198:26bd with SMTP id d2e1a72fcca58-71b25f3c36cmr17857734b3a.11.1727688697948;
        Mon, 30 Sep 2024 02:31:37 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26499743sm6037482b3a.18.2024.09.30.02.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 02:31:37 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	robh@kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	Shweta Raikar <shwetar@vayavyalabs.com>
Subject: [PATCH v9 5/7] Add SPAcc Kconfig and Makefile
Date: Mon, 30 Sep 2024 15:00:52 +0530
Message-Id: <20240930093054.215809-6-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240930093054.215809-1-pavitrakumarm@vayavyalabs.com>
References: <20240930093054.215809-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Makefile and Kconfig for SPAcc driver.

Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Co-developed-by: Shweta Raikar <shwetar@vayavyalabs.com>
Signed-off-by: Shweta Raikar <shwetar@vayavyalabs.com>
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/dwc-spacc/Kconfig  | 94 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile | 16 ++++++
 2 files changed, 110 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile

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

