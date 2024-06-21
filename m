Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B31316C863
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 08:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718958101; cv=none; b=TyB7TaSnnyMZILg7ynYOSEmpAONcNP5NK7BDl7nE57UYwcg9Y61EF0XHwkttB6e2YxvGrev2vZDI7GKoIo7F8UL38g3dFajY5TnisgQWSw8urYCA79vl5JB6zSpWWOhW2hO/6zb2fc+VlFAuYX4SZZQIoB0HRfB8bRruLen6pwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718958101; c=relaxed/simple;
	bh=9eL7I3HhFKM+kKnUHr40pjdpRnTJwCII4Al/7eM5WwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hf8H3D7g05aOhQnZLer69p3khdZLp22p/lOnGIp+0ZGUqv8k+OQ9e9A1DOoHWQzFD4k3XQTG+e3mBGApJTCuYvLvk1ldFyvwjdN2xpVI6wibspq5qnB0DKSpHdqHNSkZO5NlUl+pUWVzZMaquXIR9o4+DLFsVQAQAA/Y82YHSx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=da7Btwq0; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="da7Btwq0"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-70df2135426so1189230a12.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 01:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1718958100; x=1719562900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNuc47l/d9O88OpjU0ua7A2FwM7g1KOoLnm2sfcPXYE=;
        b=da7Btwq0ttw4+HB/wR7wjLLDK0jLcU9coXF8B5oAP1h8xHOr5u5MksHQRR8Zi08BtF
         K9++0lWzkl5iLXRtwCUYjiNBje9iBkvbyo18GEQ2+n0N1BOgyTd8KY2AwNqXXm3r4gBV
         qCFQr5iSoCd5CMPClDysJeSBDMekPFye1d+wE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718958100; x=1719562900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jNuc47l/d9O88OpjU0ua7A2FwM7g1KOoLnm2sfcPXYE=;
        b=lyTSGUyoyNW0Ce3fIdbdkwc70t/W2A0++qhJhL9FkMnAcY7C0RMHkZOWWl0ajWIk9K
         3NSws72UsbX/uP97YL1CmgVgl0GibIAq0Fo3q2F4RjkyGqkcrFoYhV/18md3g0WTNb0Q
         TSpLozD6FoiyxCXR7dPA4YN2GheFZenkbmPrGzJenuwVdR2UIkWBqlgcF3nruGN7fKI8
         jbl03z+O9++Rn50cxjEHUMT0kesWfz82UvDcO2qQkqIepTGlpvzQ4IVYHwJwD1x4+IGW
         fahCvOnRJrgKgPjl/QyJpBU76SwijYmysy3NjHIX1zjgJQsHm4k9EHoOns47oUHk+OK5
         uXZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRgyhqyW46uA+fWMO8edBSJI8/l1h6WMEr3etrwfa9UZ0qYq1ervJA2licrzCWILDp0Nis7HuaRHQm2sxRkIjOIk2Di0dIxvV8y5ID
X-Gm-Message-State: AOJu0YwEoFApzm//3HLtRk7cqMGEgMBbLCEvDHCrRkZUD/asE9J4V2/H
	Z/zKMSNjAVL4KmSkXOTZizWlglzPwJMwFa/ky/Lv21Sq+CdzQpWqxltNDjASXIY=
X-Google-Smtp-Source: AGHT+IHrWxxg/SCBkspD7WvGAGVZAgIBnhmrmONH9enmIKv3+POcksPzOIX/SjgexGhNGgg+/ZCP2A==
X-Received: by 2002:a05:6a20:b91e:b0:1b5:fd58:30fc with SMTP id adf61e73a8af0-1bcbb656014mr7242582637.41.1718958099753;
        Fri, 21 Jun 2024 01:21:39 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c5c97sm8673555ad.125.2024.06.21.01.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 01:21:39 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	shwetar <shwetar@vayavyalabs.com>
Subject: [PATCH v5 5/7] Add SPAcc Kconfig and Makefile
Date: Fri, 21 Jun 2024 13:50:51 +0530
Message-Id: <20240621082053.638952-6-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
References: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
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

