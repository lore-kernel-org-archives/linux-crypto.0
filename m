Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBFD199943
	for <linux-crypto@vger.kernel.org>; Thu,  5 Sep 2024 11:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725535886; cv=none; b=DRHoEm9U+r8KlxX4LM0Rfg+/8rUkFbKYXXyz70EDPJcWrDkihmdxrJCcNLvZ4cX78MkxGo5Fmv34hF4AjZltaqtiT3qS7xK9YlvlaGtCjwHXKMpFIzGUj/IzExSkMWg/Pw5ENQUKmlhS0P88JaSn3aSWq9sz2BBXh90EMxJsmx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725535886; c=relaxed/simple;
	bh=uBEylabauM6XdIkm5sTFcPtKxIKqHgS42rKU/P/PZ28=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KwbZTWwOEqAO7fOVTeqhv4hIO206IlVy85qnnqJmD5y0gf5cU+Fy2APCk6haknivmr//AeY40ovDNcVcEHDzrAyVFtd3erUf+5v8opEBQUjWcwnTYOy/i6g1Ar1U0/VDx0PxdhXFR/365EfeFiwcK0/l7eDf4vF9OqifZBklL3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=KEQd4snU; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="KEQd4snU"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2068acc8a4fso6979395ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 04:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725535885; x=1726140685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOUKtq72kiKNhA9E7dWQRNJ0ISe50uKigyURXdbNL2I=;
        b=KEQd4snUAvt8F9TOwqu3J7zEPFxr9o4yPkrg/Twcle/MukkvDr2CQK/nE/GOIPAk1y
         NB7xtc7waxSLwUYwdskQA/ZKSbZ5o1Pl7D+YrpxTPj8DEuzeKwwMuEKiM2cxRWUwQN6j
         rnv+K5TO9na8gPB87B2w1B9bXJZ7QB/cetcOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725535885; x=1726140685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eOUKtq72kiKNhA9E7dWQRNJ0ISe50uKigyURXdbNL2I=;
        b=v/jjxVw4LSGZKy6WSkLXiKN7Am33gXk0leuvcWwBiFgCPZN1QPhLVAL/U21SGMndry
         SYc6oM8iMfgJ57BHdMtm7qH4sYNf6fGZooM7VmH4cMb+4kx/bmFq4IrU3c2I9HuYRvH3
         KPIk+PrjZVCNzav1aWSfJfuz096w9gnYQn9E4TIpuTSryQur6aX6q5xMqFwOh1ONyXbA
         3XnriHrn/I1l6q80sewNePYeGCm23Wmp4c/lTbBeU7Ufrn7y6CqDGZQGbkDHtSVzZa/c
         Xlx3QGAe6kFoxMTO9FghTtgLnbsvTLOIiK+hoUQjnyn01Rb0Cqv8GVuvLQTsuZoSZhEk
         6hug==
X-Forwarded-Encrypted: i=1; AJvYcCU5/dbFTTuURHe1+KeGkY4GTFqCf5hLbmJiFSu6PPe1c6SGz9LAfNVe4cl6Co0ogvozpfmsvlbtsgS9Re4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0HOkke1PBlbj76lIUfiZyr3alnh3bwxE/MX9NeSFTVYrQhC28
	8bZbeibz7iVBqjJm1LmoNPjupJt7FJN7f5ewstXEzC0F6KDyA7vNPS6R/W7Rnjg=
X-Google-Smtp-Source: AGHT+IGSq/nZhPpicmHG5AS0DPCqq8c4AF3Y6E7nWzr7cXSMEn+veGsyv/EoCz/2xTUowPyvc5T7Iw==
X-Received: by 2002:a17:902:f984:b0:205:8cde:34c3 with SMTP id d9443c01a7336-2058cde362emr100971105ad.54.1725535884536;
        Thu, 05 Sep 2024 04:31:24 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206e6aef432sm704085ad.177.2024.09.05.04.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 04:31:24 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v8 5/6] Add SPAcc Kconfig and Makefile
Date: Thu,  5 Sep 2024 17:00:49 +0530
Message-Id: <20240905113050.237789-6-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240905113050.237789-1-pavitrakumarm@vayavyalabs.com>
References: <20240905113050.237789-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Makefile and Kconfig for SPAcc driver.

Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
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

