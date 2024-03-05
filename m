Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8065733F
	for <linux-crypto@vger.kernel.org>; Tue,  5 Mar 2024 11:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709638140; cv=none; b=YdeNUO5Ji/xid5rr9hacB2Khfp3KCX2vweiKB3H1/zZN5oQCwcjK/r6o/7EVhNvt/gHG5vi+/NHrWBM7wjjG+Yy5qjx5R3Ugl6I8RdSaKLkAlDzZkwY3SWqobzbjvwvw0gM9jqFt2Xej597y9QnVs1Ux3Ck8xus6YdlSSL7zNCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709638140; c=relaxed/simple;
	bh=48Jrb/cXZKZi4Zdrt6Pma1PbCtOT/yCF32sTv2T5pN4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qB2EPxGBjDe3WL7QBinQvFEBXiaAO7LmBITR1WtUQz+dzvk3QAjqPOTYaGFYVFg8/6zSQY1pJBcVtwI/iZ+l06shG9XAtfjTYdafo9xvH96fObmy9T9k3wmFk/gkTQoGGw1/6WxUE7O73K6MN4SwiLxcR0tcCTSRAG3XMt8Bjec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=EiYG87iv; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="EiYG87iv"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dcd0431f00so34318675ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 Mar 2024 03:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1709638138; x=1710242938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2XArLRS1sHqeDfWSR22Mxy+6cbfGWPYDDChfPN87QnY=;
        b=EiYG87ivcDJE/pOiq9cuOUhHLmgXd+tDlXzcK+1VYjdnHzVw1IAOchYzQRMtOYOwaj
         OP6armViJVwrZSO+1OIaASfWCIjUTsTfUQADVJlIaqeRFQJVT76Eh924yogUmcBQuYEw
         3VqwqojfNL60JWpm7jc0sMgksdJiBLiia4IDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709638138; x=1710242938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2XArLRS1sHqeDfWSR22Mxy+6cbfGWPYDDChfPN87QnY=;
        b=S4KxTi57QMec4XkcplgomeK3ub9+qxrYBmtegXXmE2E/avZdQEsFPze6ZdU1Dx0P+q
         vsPYgLsU8Rr8dKVtM8zikg2O8deqm1d3UfCMUBAxtgPJU2EHPvuQuE3cOHeushgzR3Zf
         OcrbK5fCHsy3Uxs1Pq3b51aPN4woCdvB1CrKXWNDxsE1wWck85tNCMNemY9FZhwFnylV
         Ip1AY/KEHYsPJ1tMW2MEzbXN+jD9gyq9CbSHLv/F6OQBwR4ZQCt6a1b6nmmq+Hnx0ZzE
         LYKvECTAmbd5PW7EUra15/xRIYTWNu3kHGCku5n38f29kZvuUDNycHZZ8mssssxk5mhh
         tR1g==
X-Forwarded-Encrypted: i=1; AJvYcCWS00QZsVRvNAdzUQTN9xnQQlBD1NLd34rj4ZIVGa8adSDnPRQmKOh0zWkcTHftitO3DgzztGVyIfn+19croOvoNOCRjzZwg5f3Syqo
X-Gm-Message-State: AOJu0YxbpBxysEERdlysH1uean0anPOrFCig3qqJhvi4iiB9wBpVfaID
	t9lAV6+AtYeOdSSeb0zj0mhwMttMk2FLp/BiIUvFoA4UneFW4v9o9CAogSruT+A=
X-Google-Smtp-Source: AGHT+IGN1HCGyvYkAtqFl8LdDDz+xlnVDKuGYOa2jG8kBKl3i9Yq4naDxiu5Fc+wl4lkjsrfG0HVbg==
X-Received: by 2002:a17:902:d4d1:b0:1dc:fce2:3084 with SMTP id o17-20020a170902d4d100b001dcfce23084mr1831685plg.7.1709638138088;
        Tue, 05 Mar 2024 03:28:58 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id mp16-20020a170902fd1000b001db7e461d8asm10287212plb.130.2024.03.05.03.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 03:28:57 -0800 (PST)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	shwetar <shwetar@vayavyalabs.com>
Subject: [PATCH 2/4] Add SPACC Kconfig and Makefile
Date: Tue,  5 Mar 2024 16:58:29 +0530
Message-Id: <20240305112831.3380896-3-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
References: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
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
index 000000000000..6f40358f7932
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,95 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config CRYPTO_DEV_SPACC
+	tristate "Support for dw_spacc Security protocol accelerators"
+	depends on HAS_DMA
+	default y
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

