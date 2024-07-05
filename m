Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C33716B3BA
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jul 2024 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720199622; cv=none; b=KOYQzcKoii2dzeLSgEB+LPDw7K1n8kiaFmbWtU/AQ0x43p5KoLkVOXVOdFGvtTrgY+CTvADWw0NeERy4i2RsesGQ4TWPRLHr36ZN0W0b88dy7ihNqwg3NFZg1M+dDXb8k3mk/62hNVnB0mAgmN70CXPq7k7vf8BMRWS3uUHkpmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720199622; c=relaxed/simple;
	bh=9eL7I3HhFKM+kKnUHr40pjdpRnTJwCII4Al/7eM5WwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kn2+vgEpUERitQxY0A5aRULBQCBqlrpl1xUZJIUlt1X5kQHJkQFNkQTuOEGYQvZz0d8M2xN02E4LT6AuXWePrOcI/F7VYurIBlfdXwwEmT/89Vy7iFV9VuJM8vwBT1CLV6SF1kMEnsCSmR5SZwdb9yBcltduRWmOJQ+Y+R5UHkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=et8Db9gj; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="et8Db9gj"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-70af2b1a35aso1339658b3a.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jul 2024 10:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1720199620; x=1720804420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNuc47l/d9O88OpjU0ua7A2FwM7g1KOoLnm2sfcPXYE=;
        b=et8Db9gjVE7ZfplNothiLr7srOqp/hCPGqkje7J0mLMNozd0ZneKnVrKyLTcgXkZ31
         8/jMOkbDW5rhW545F0WHEcOA5yeNUUD1fy3rqBadQiEs3T+TBpiP7Q9RNZr1QGuSJnny
         MaGrAZWc4O09Cua34yAnbsxpYPDsITaFuGQfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720199620; x=1720804420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jNuc47l/d9O88OpjU0ua7A2FwM7g1KOoLnm2sfcPXYE=;
        b=qDrg63gBseNb8IrKFdSx9hu7Ck1r+41WjAuks59qdbo9bxXkPcuNdVuxzncBqtjeKK
         3cXwYuOgu/fkqwrmG4b4A65Y7JguMsk9geUituUXs8xOekI1aFpvxD0+e0omaeWF/ghn
         D502PP88F9nJq+wxbOsVOryxFHcbaTmSaL9lXBNYCbK5XIfjIbxNS/lo5l8QdATepAHL
         106x6LGOzQ1LURyduu4x5V/o0WHOK20lK0vGGpjpoP2mLfmmSVERWH11ScLdlfXNNVxi
         iukU58mHJO0nIymgdBZmmjXf3geYn2sazHvB0iGxjDXcWKxInyeY27A3YKCaI/C7+sZx
         rSxg==
X-Forwarded-Encrypted: i=1; AJvYcCUzHEVnGiKlrFED9ZMpxlNlDLuA2uj5r8EKQGj697uFRsfeQXj7XEvubRWqS2F3AB5/+/Jy1nRSl0a6um52bcSHp9qbFMHiFb2RHUwM
X-Gm-Message-State: AOJu0Ywmz59oeqNnGQwQ/fUoXd6qnNiqeeMywlZocZHmUULgZtYm/GVs
	2lAAaW25tpGX+biAXIcHJz1n83z/hKS2826YrQANgZ7Ps4satZxVx2ONocR2s8AYaaWFgOsn66y
	5
X-Google-Smtp-Source: AGHT+IF2r6IYIhHjxZlMklsm6BKPtuphqRbJraoFicmAMaPjOOI6eZUOZn5c3IS7tQNXeAhbb53mkw==
X-Received: by 2002:a05:6a00:198f:b0:706:31d9:9ca0 with SMTP id d2e1a72fcca58-70b00927369mr5402961b3a.4.1720199620357;
        Fri, 05 Jul 2024 10:13:40 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b030d5d0bsm3174889b3a.14.2024.07.05.10.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jul 2024 10:13:40 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	shwetar <shwetar@vayavyalabs.com>
Subject: [PATCH v6 5/6] Add SPAcc Kconfig and Makefile
Date: Fri,  5 Jul 2024 22:42:54 +0530
Message-Id: <20240705171255.2618994-6-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240705171255.2618994-1-pavitrakumarm@vayavyalabs.com>
References: <20240705171255.2618994-1-pavitrakumarm@vayavyalabs.com>
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

