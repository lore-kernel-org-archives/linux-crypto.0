Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D1547A5C
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 04:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718684904; cv=none; b=CmeXiktHSWDLopXM0QYiFeLNvJUvoH7ikkilE4gyy1rGSPpS2O1XxJjg6QrVDKd1yypOAJenIjTYJE0izaViIIst+GjuHQik8hKhi30k/dTqvYvjiBgqdcDPWVFJytNOoVg9PPSFHDyD87nO8mRlllhACUX1yuO7WcppIa23DpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718684904; c=relaxed/simple;
	bh=9eL7I3HhFKM+kKnUHr40pjdpRnTJwCII4Al/7eM5WwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=evl+DnFZ8R/7vnSNfXezgKzEmDZTqkGOnvj+kfiQJdDrXeVcXleFDTQ4STbynEYjfYdG7jQWwa8jQfArqonD6daueeJto0i1+1902Lv6wMbko9pMznAWoZNxb8PqdlcOmhIGP0EcYp+if4knx58V2mLHcGvUsMq5xPKEq4FsKD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=U6Sso+Vi; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="U6Sso+Vi"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1f717b3f2d8so42622205ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 21:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1718684902; x=1719289702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNuc47l/d9O88OpjU0ua7A2FwM7g1KOoLnm2sfcPXYE=;
        b=U6Sso+ViWvlVf87T1AT0F3kwYuL3cE5rBHgCmgmhrnJHoujOgdgsVu5mQMX+DpcG94
         J7rMFNXapKo+FHTIxhpRDIJGTyt3RgxGwPrUsYVBk9bQ6Y+gzn6R/gW3k6lPk7Y7jlTC
         3xB2kkGnGEssyhoiUlUqXrC4AsiYP4TOwfatg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718684902; x=1719289702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jNuc47l/d9O88OpjU0ua7A2FwM7g1KOoLnm2sfcPXYE=;
        b=I7utfjiPS5bet+i/ygOVeKIux5T5s+dvtKQ6K9lzyyEZw7SfkqnWVmY9MyBbXHjPf+
         UsmtaD1xjomeiiudzr0wwP6UvVk6W+1vSs5GOmX5QY9HHQJP7TTN4zjOjGLYHFpdxfCR
         CXFR/kjinuTpmBL5YuHnftePoXVVyq3HbAcM8/1br/J/pXQ3l53cUtyYhHusvWZJE1Oy
         ZQp5/sH933hqNa1JSEGGvFO8BMNRncF2Lxzh3Qwi+t9h+F+qj4WXGBWYeEKjKQy5pylr
         foo85TQc0EaUh+F0gGxxaKiTA9cHO2qTz5p3slfqFsvW15wyt5kRaSjkk1WpA/RYun6f
         q42A==
X-Forwarded-Encrypted: i=1; AJvYcCUWCEbL6fPV8OemJh1pFIUCpXCEYaoCTCzzVTGNMqBhF5boqEZtrBH68dVTSHWfdRxSy7UklUibogZulr/MQ4JkH+Qb/n9KcpqE4lVr
X-Gm-Message-State: AOJu0YzT/1uL3MPa2CF6UbENDAOguFRsPPmH4EIGz46LGtlptXoRKEWj
	9yif9nofD6Pqw1xwD8RXlA9MsGDqGpHNABhCcAVD6YYiqF37LZ+UaTTz157Y2hE=
X-Google-Smtp-Source: AGHT+IH1xD9WTGqriAlI1OBaYOy06zlNVdd+8iS81I3PnfY7GvWkIrgKHX3z3RYGWFUw91fz+UuXVQ==
X-Received: by 2002:a17:903:2288:b0:1f8:3d2d:d9ae with SMTP id d9443c01a7336-1f98b23df71mr20938965ad.18.1718684901908;
        Mon, 17 Jun 2024 21:28:21 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f1770csm87912405ad.230.2024.06.17.21.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 21:28:21 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	shwetar <shwetar@vayavyalabs.com>
Subject: [PATCH v4 5/7] Add SPAcc Kconfig and Makefile
Date: Tue, 18 Jun 2024 09:57:48 +0530
Message-Id: <20240618042750.485720-6-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
References: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
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

