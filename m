Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB4277F15
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 04:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714105611; cv=none; b=QUbRdf28TK3OYX0ELD523dFce9q0DeQjcaRUTDDNf7PHxT07QQvRFc846HT6lfHn89DZYTCAE8/TUdv4aM7H1rNEIQMPP5Mq1mB9AmPdOhMy7AQSNgYzJKlupZqpRKjFCVFb4UYm/2gAJljD38hz5HLpMs2nqZ4ln8Me/PhLumk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714105611; c=relaxed/simple;
	bh=+8P1w6aUSIAPhLIEYHoxnk8MIUtXaOEofQD45EECveE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m+8Y3mtn4Su+/r8XEgQlLrH1CniuIjUVnIXPTSsWFmKfshTkQfMz8XKI+HYilA2d2qcAbB8GxyQZAsT+US+tW3MFUQGFZSszmBkDC/wpm1csqx5cW4xPViAhWfLn/IlMHvNTBIiSWz4z5Ih3jZgYLeC1AbSAhB1qUfqaKSWoCmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=G8/Lz5RX; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="G8/Lz5RX"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5f7fc45fe1bso1366851a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 21:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1714105609; x=1714710409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKXMlIDnwfkcREXFrl0APrg+ZnLGK8H1w+N4Rwn2rOA=;
        b=G8/Lz5RXsuJzTYU5gzCwF/2C/Z4EL3U7xyuUs6IVRuiPc7vDEUTJPKplz9CsMsJPY/
         WF6ninpnkAWp2J58J6uCwi2aRPcgUy/9mpURv6lTF7smmxdhEQfUvhcPLqVCMRvmYtGe
         hXloY3H0wTjH4Iz6SnkC36I6L4whZ5Ohmkw9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714105609; x=1714710409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nKXMlIDnwfkcREXFrl0APrg+ZnLGK8H1w+N4Rwn2rOA=;
        b=dlKbbtLGCfHAFRnDXhA4Dxafepx8oihhUr0Bq91lctJQsU7M5hs6ucUuUZtBiYACuY
         ygBBDk7GIqGAyVs3+prV548cv8P7VnzkALm0fse0JmpVOkbmPK9pWHUcqrzjjTuiRymr
         ng4PJX7L5nq+O9h4SatZaotRD3h3O+5lvrS4IXaxHPyvfUosKEj+zz/u9O1BgwVfJPdB
         /8ffaPwWEmn7R0oenbqZg4VQdTBzYRO1bRV34IfvTIOa2TmDy6z15miUypKSPn/wLDOj
         sdzZkZroYQkcBK5ODebKtsJKYNUOkzEr06FVrYanuhkcXbgtB9EHqQwC530Wzn0/Sx03
         woFQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7yF4QUSiBCE79TIKK6rB5FM1Zk1NamO+BOST/WvPEm/5AvbAZUdC3Bgo/ZFD+DGsLUBvjiZpTnyA/HQyBE5MmpjrjMS+sVLWMvUtz
X-Gm-Message-State: AOJu0YyEfiIeRm0AZLTnTPwJbZyffh/O13KHtO4/1508+PsyiZ934n9e
	/g7JmNLyHTHworJxCKV8AzI4ixewotGiRk+Xzkr0r8sfrx1RuSlYK7O/9yKmhIVxegh1jJjX38H
	N
X-Google-Smtp-Source: AGHT+IEfQwugtOOc1cxBNW7Y+uJG97CBC9nf5O72VI85VGSPs8XRCNZ7nwV5s2EB4OJZRnXBp1/hCA==
X-Received: by 2002:a05:6a21:271c:b0:1a3:63fa:f760 with SMTP id rm28-20020a056a21271c00b001a363faf760mr1818458pzb.14.1714105609637;
        Thu, 25 Apr 2024 21:26:49 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090a5d8c00b002a474e2d7d8sm15500291pji.15.2024.04.25.21.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 21:26:49 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v3 5/7] Add SPAcc Kconfig and Makefile
Date: Fri, 26 Apr 2024 09:55:42 +0530
Message-Id: <20240426042544.3545690-6-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
References: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 drivers/crypto/dwc-spacc/Kconfig  | 95 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile | 16 ++++++
 2 files changed, 111 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile

diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
new file mode 100644
index 0000000000000..9eb41a295f9df
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
index 0000000000000..bf46c8e13a317
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

