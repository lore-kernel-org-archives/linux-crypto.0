Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A3E24EA9D
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746449876; cv=none; b=Rl1hUwxdWd73gu4httdLve//3b4ASbqid1vXrdcxpfwoHBKMHrYcti2Jt0+hsUD0viGrhF+xElRqvu2/mvtYN15eHiJZJ/TyMnPXu69rbaOtk6l6jz0H6Qf8KIwcP5u5GklcNrPUKZK5Pu2mBN1UbPGvMxfKo56LgdVdpFlYEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746449876; c=relaxed/simple;
	bh=8oUH1gindRCn95AykEyqq+bxw3pe7IGaCCKXayWmVwU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hV0bJ7JoeFjoJuqACSUcctYniGEOSnMwfu8bV1cDiQ4I+GUIoPsWVD8Ll4qlDIEvuDSg4/xSu+IwSZOiHv1cW08GuGLrOAdmJe4Y+I/fR/gaMqkUJXC4kVDSQb2GXlhNhNUOrxsqdMs75PaTRq+cyUJIzAo805cF5qcDQY8ZxHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=n/d0gole; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="n/d0gole"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-af6a315b491so4011362a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 May 2025 05:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1746449874; x=1747054674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OT2S9CIDCEY28yXqIqPSnPzbGUeYFCEUZbs68pYw7Bw=;
        b=n/d0goletsPdkyPTk/eD2xgTB4arKP0YEJEuLZ59D5CWD9cGOOwDHMHIMB2vcYTFdB
         ped/8AHZszHDe5JgommzyzAB1N6BVJmj64eZauBeh1oCGVs3LjUe3YF+LfSJ47ORI3qn
         bGhGy85VMnkosOuNHZK/ZuFsieAeXzHSd9yyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746449874; x=1747054674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OT2S9CIDCEY28yXqIqPSnPzbGUeYFCEUZbs68pYw7Bw=;
        b=ZYMb8goLzka53rFT9YN0YPCwCjHE0/oxIs+KYHYeLwvcjtdZjbirk3DeOvOq5dwhcg
         Yr8bRFiWXgoIOXuWESl+gdnahVRe3KqY9Pywvo+XROiS73wXJue2iHh1CGB75MLxOK79
         sYFtI5FF42bGDhO0RAWlXeN+Rqt9d0BEJ3Nlgo6ihYJexjQ8XyGIQQ5v7UKoX7kaGL4N
         fKJsRbJsEe1KYu7ANbtW0ITVoD8kUB+DUCg5tqOyEcxKn38m8uVgV7HGZvWxpRzUTy2Q
         qddFPUzOSch4gCUyL2leVreEFfAvWhmISX5nd2pGwBl+UBxzor8okJHHGHAwHiTPXbg6
         hPJw==
X-Gm-Message-State: AOJu0YxFzcn+s6H0LpqvWDF6IO78HYs0fWaJnX32xrk/tj5oVScKLbx+
	4cCY165swDpzcD3vDcht3ER6tkURcP/52aU8MjxTTFjWc680xVCcLlD5AiGnLSWn/qmixB6tkka
	5
X-Gm-Gg: ASbGnct6H8ckPbtwM0W8o6E1yFNQY/MVapnhMj5QTJy7mhmoQfkp4ouJg/fhUIG4pMO
	tgJXagsWXugZnJjUpH+Ht4GlqVnMi+qpNp8zo2NkZixvzdmZ3NmratBWIJy4RxDy0Kk9E0To8A4
	3n6iblBX2ijcoc5grQ7PefBlgF8CUqub2VqJjTjFi2mHOHfuFHxiV7FRk9XlOe2l0z4rKSlBnsZ
	ol++JF6qOZWAB8LilEcJibuhLvx4QB160tOF7AWNc7rZ0Sxmi9n1Hgmy5AX3iQLAqsS8D12trfP
	HrMM5AYjQeJ+3Z8KiL8HZXlmsQfUxryTf4EdTmOHdmL0FoB76yydsOAZN/EpsQ5o
X-Google-Smtp-Source: AGHT+IG7EfH+S1yfDkjwtm2EFBSqfUuDVwnWJ+U6WeyJDohkZTH/ayy7+72RN9E3Rghf+/qo2mmsxA==
X-Received: by 2002:a17:90b:2f10:b0:2ee:8ea0:6b9c with SMTP id 98e67ed59e1d1-30a6197c0fbmr14246738a91.12.1746449873998;
        Mon, 05 May 2025 05:57:53 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1521fc6fsm53559565ad.145.2025.05.05.05.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 05:57:53 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v2 6/6] Add SPAcc Kconfig and Makefile
Date: Mon,  5 May 2025 18:25:38 +0530
Message-Id: <20250505125538.2991314-7-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250505125538.2991314-1-pavitrakumarm@vayavyalabs.com>
References: <20250505125538.2991314-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

Add Makefile and Kconfig for SPAcc driver.

Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/Kconfig            |   1 +
 drivers/crypto/Makefile           |   1 +
 drivers/crypto/dwc-spacc/Kconfig  | 103 ++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile |  16 +++++
 4 files changed, 121 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 5686369779be..f3074218a4de 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -754,6 +754,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.
 
 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 22eadcc8f4a2..c933b309e359 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-y += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
new file mode 100644
index 000000000000..e43309fd76a3
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,103 @@
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
+
+config CRYPTO_DEV_SPACC_PRIORITY
+	int "VSPACC priority value"
+	depends on CRYPTO_DEV_SPACC
+	range 0 15
+	default 1
+	help
+	  Default arbitration priority weight for this Virtual SPAcc instance.
+	  Hardware resets this to 1. Higher values means higher priority.
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

