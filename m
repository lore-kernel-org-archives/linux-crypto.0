Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B49F383
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2024 04:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722226474; cv=none; b=ny4pW50wBRUs3DCEkQ23quzw+QcrwRJRX6CuDfCoBBeyS2pLp8Je+sINP0/cCnxjLp4kF1BnUXdtnAU4XLeMNnYDmjHvYiZKXF1D6F5AG1bPPXafMeWj+77wgPH3tDauSYM8gR7uMli+xwImD04zQrDgvkzKJVWanVWkwcBYcBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722226474; c=relaxed/simple;
	bh=9eL7I3HhFKM+kKnUHr40pjdpRnTJwCII4Al/7eM5WwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PRgkRXhkGjTj/MwHAgvGrzvoIurVfm6xhcBvX4TmmNx5B9ceQ9rukCBUIqe3icrwRUePuPkc7mWWGn23s0J+7+nCVBB+uVhbAFUHCkXBsAVkX7mOr7t50u/WTZDDgEwkZyIB3p91LWQqi3aEn+NaykkduuSYrkmt/lg3OMK+JU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Py8GQuet; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Py8GQuet"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7093f3a1af9so1602596a34.1
        for <linux-crypto@vger.kernel.org>; Sun, 28 Jul 2024 21:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1722226472; x=1722831272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNuc47l/d9O88OpjU0ua7A2FwM7g1KOoLnm2sfcPXYE=;
        b=Py8GQuetgbyynqKxtYmDIqxZ+dypxuEy1vpDPF+cDRRDL+o69TQjo5Zzv9unqeVS5i
         F71RkSmyQTfy07mq+Hhhv3tU9mONA2wuElQpVw6vEsD6a+Ug8qYLQDFSNzcVBbb8tLdk
         8sz5GO1XjvqXQl4Z7lmusCPo2UCqN6qyQ3myc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722226472; x=1722831272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jNuc47l/d9O88OpjU0ua7A2FwM7g1KOoLnm2sfcPXYE=;
        b=IgWOZF9BGSibKqIWyn2En609Zt8xei6ibEi9l8BZ/WJdIgRDZUjzkExKx88Cw8TOsQ
         fbLkLi8XRD45MOIlQMlfnuuAQ3aXYJNRKHZMhleYhmdh3MtuJi6orNTYrijcr0xsbB7V
         a0todbbV+btFjdpqzpYTZFG1pyeX1Xgs4cLkNtVVQLrcla2CpqKD+W3lM5b6w7oTqRYS
         TCMIJor/c4nFP5/pvpRDssbI/9FTgvkqKfrRSUyJHtxZqhxC7LUrv8/T5ySc8T0SB+s7
         Va6N8X06U4mRb6saC3qTzBl+Wc75+YS5SgvHMK1XaB1+SSKWWkLxZCPdEZYK/FhlrUj8
         7eOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKhMSKDkWNCse5WpVm205xQNMZqfE9cNALmnU+s1eYcvv1ChULG5x7gdkEbyTlgRcNU6UkrIcnTTC+sFjkKGEuOix5U6eL07e+qXX0
X-Gm-Message-State: AOJu0YxsYJQhCP1bU025IjkwZgMHmafZu7W79INuNr9QgbWknrf+FCt/
	jD2eDodFEJLoxyr8tH0ql3FcyKSRp5b+DU5GZfgckAkIJjtw/rmhAOIMqSvVMC8=
X-Google-Smtp-Source: AGHT+IFJIaFnpkqkCmZkipr7ALZYYqYYj9UUVJor9nn+GNu+wmjV7TS2Ns4S4PIPmJzfoIw1blmjmg==
X-Received: by 2002:a9d:4f11:0:b0:705:9615:3c3e with SMTP id 46e09a7af769-70940c1a680mr8055346a34.12.1722226471747;
        Sun, 28 Jul 2024 21:14:31 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead71228dsm5932141b3a.47.2024.07.28.21.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 21:14:31 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	shwetar <shwetar@vayavyalabs.com>
Subject: [PATCH v7 5/6] Add SPAcc Kconfig and Makefile
Date: Mon, 29 Jul 2024 09:43:49 +0530
Message-Id: <20240729041350.380633-6-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
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

