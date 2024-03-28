Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515791327ED
	for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 18:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711650445; cv=none; b=etIP3A1BrnZ3VgLILJtHUq0tZccrmTAIhMsjEY7Bg/E56uI80vZviPiSYJLI/t2iq5+LD3I0bmOCWkPOucMQuGp5SgSaTgdGRX7Y6WE7WkHzOoPK1godmLq+zWDHsItDpjEZjykJUYjk5Xrp7PS3bF+20yKOC2FHIY56diepngY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711650445; c=relaxed/simple;
	bh=9eL7I3HhFKM+kKnUHr40pjdpRnTJwCII4Al/7eM5WwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r61xiYLI8oxMd6Q1nUGVewF4Z7zfSPI2/SmOh2gYsv1Yq4BMc4zSprMVkYS3yYq75khfuWWX9LWh9Ue+/3RSqbU/wRg9yMWFU0vADALEqxvN41C7HoJBA/QqJrRqfNTVGdMaPy7KzHChumfztW7X2lVPooZSGZESkrjlFSH4MuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=nJvOhQeL; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="nJvOhQeL"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e0878b76f3so10163195ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 11:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1711650443; x=1712255243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNuc47l/d9O88OpjU0ua7A2FwM7g1KOoLnm2sfcPXYE=;
        b=nJvOhQeLxye4C5LmI2Cp0yFkJHWJ+mVCwRJ/dJyUXINOMNKvmBjBD5YCap2mypq2zG
         dg+JvLJUwTeUH1Ri14qAsv5+0f5UjYvP9MDLfWKJnceV4EqITMxbYlf7h/1SbLhIxwuN
         SLkXmmtny/yUutPbU/FymC4eKnYb3Qi4JdfPE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711650443; x=1712255243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jNuc47l/d9O88OpjU0ua7A2FwM7g1KOoLnm2sfcPXYE=;
        b=GNRRhsELhZsvPF3c5435OUJaTSiuL8anqSKQi4ikgBjge4jfM7a7JpGx6G+S7Gv6IC
         bfvGK3mQVsZ8R1waIEUfs0fMlbgMJSo9oDXftL/dx32tvwlWwtG+SCcLuzsSq3ahUlca
         8Lwo8xsU4/cFgcthkNlK21QL69zJrWtuvk7eTCFNQxd1wL8cQRKeHsuDizoU7Kd0FDjm
         6uWQFuUu8HFrgUue1AgrjdBPex8rVqiZWA8WaJpMnmYFDOvbrtanV9T8oMlefpjzcjxW
         HvxWi0TYJGr4SRD7DAnD9JFNwXtTPuwjTWq/jJMuhpe3RM+PV9O/p0RQkph/Xcc5p7EN
         5dVg==
X-Forwarded-Encrypted: i=1; AJvYcCWmfBCxJ5iAJMik9EEngx8cOi/OpuWDh1p++4npcFmuAQyMVC2memowrubh8i9SNUepxIyXNue1sSHsmUvQ0i9bgnAuuhoJfDaSWIIp
X-Gm-Message-State: AOJu0YwoVXA5d/dIdQYLlIqo/vxtqGYa3EMpbCVG901brpymfx46BkB7
	ffUOLE8Bj+eW70VqOCrwV4GmLyyDyGE7EHv26T29QN0u0aZUuee4ad9YwUwMnGQ=
X-Google-Smtp-Source: AGHT+IFLQqV/JIzT0TSBEtuUiXvOVyOIPILBdZ3xZmdYQnEIJzgmJf4czsDsdL6LLK9ufmhygmlDZQ==
X-Received: by 2002:a17:902:e88a:b0:1e2:26de:c61d with SMTP id w10-20020a170902e88a00b001e226dec61dmr299274plg.21.1711650443626;
        Thu, 28 Mar 2024 11:27:23 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id i7-20020a170902c94700b001e223c9679asm846059pla.93.2024.03.28.11.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 11:27:23 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	shwetar <shwetar@vayavyalabs.com>
Subject: [PATCH v1 2/4] Add SPACC Kconfig and Makefile
Date: Thu, 28 Mar 2024 23:56:50 +0530
Message-Id: <20240328182652.3587727-3-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
References: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: shwetar <shwetar@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/dwc-spacc/Kconfig  | 95 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile | 16 ++++++
 2 files changed, 111 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile

diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
new file mode 100644
index 000000000000..9eb41a295f9d
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,95 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config CRYPTO_DEV_SPACC
+	tristate "Support for dw_spacc Security protocol accelerators"
+	depends on HAS_DMA
+	default m
+
+	help
+	  This enables support for the HASH/CRYP/AEAD hw accelerator which can be found
+	  on dw_spacc IP.
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
+	  Say y to enable Cipher functionality of SPACC.
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
+	  Say y to enable Hash functionality of SPACC.
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
+	  Say y to enable AEAD functionality of SPACC.
+
+config CRYPTO_DEV_SPACC_AUTODETECT
+	bool "Enable Autodetect functionality"
+	depends on CRYPTO_DEV_SPACC
+	default y
+	help
+	  Say y to enable Autodetect functionality
+
+config CRYPTO_DEV_SPACC_DEBUG_TRACE_IO
+	bool "Enable Trace MMIO reads/writes stats"
+	depends on CRYPTO_DEV_SPACC
+	default n
+	help
+	  Say y to enable Trace MMIO reads/writes stats.
+	  To Debug and trace IO register read/write opration
+
+config CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+	bool "Enable Trace DDT entries stats"
+	default n
+	depends on CRYPTO_DEV_SPACC
+	help
+	  Say y to enable Enable Trace DDT entries stats.
+	  To Debug and trace DDT opration
+
+config CRYPTO_DEV_SPACC_SECURE_MODE
+	bool "Enable Spacc secure mode stats"
+	default n
+	depends on CRYPTO_DEV_SPACC
+	help
+	  Say y to enable Spacc secure modes stats.
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

