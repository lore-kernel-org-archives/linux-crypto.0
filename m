Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795180516;
	b=JAWcJYCrLUCk7hFUZ0VCBlYPHGi6ifD09zY+yKlKQfwKLVkszntPNr+jL9jHnXr1R8Mt
	 adVf9sCLZJUX6D9FcBnr3dvnnX45pvIz5QPbg7PncGm/dzlxEIOFjnwn5DTEquzt7tnQU
	 IwTO6XSBVTh9iI6rESfg3FQrRwhWuMckwBDbc5yuVbD2RLMvTqhVBa54R61pXuNuKhKrT
	 Ik7fKDrkAvP4ynk2szmVZ0H1OcKizMVsaFG8senSJcTSH95HM8t8kDVRQnn3IvB/muksY
	 Moi7UKKzUUlNWEbVgYgcSsLlHY7Pk4x0tJeWnrOpDMcoxiX8sC8CunUoK5La/FQRLmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795180516;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=I2Zr97px45Lj3XI6OkTDSQtGrZcMB3LLelnuX/SP2Nc=;
	b=Vx0anurawNAcLAPNgqmFublBdBvtNFy4qMpFCKPbrs5PqXoFQJtEXtKpJtggT8TD5b5L
	 Pumye9aWGkK/j0Am4LqD0qIMMeiRDH7z2SG8x0U9bUKpqbMUhFcF2UrRDoW6vX/WT7ePO
	 GeyAehWsWbeXLlDP+IPd9IzHd9IpkPAl8WknvceL8Fdp92vZeqrP9aHbnaFT80HYx+W6u
	 H3KarasbfR2FilkY7r94GDaoGJz6kUcqRwVSOkD5/pBFBgYr+qdYTaLnvyhRRjnemUaga
	 UH8ABvcAs4SekliHSY76YK4tUVO3nJHyoQMZ9yVstCUqKmv2zS50FKKeFxrAzo/mapg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=KgsOidvr;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9416D606A331
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 13:15:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9416D606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=KgsOidvr
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-385c497bf94so1395694eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 05:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1795180516; x=1795785316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I2Zr97px45Lj3XI6OkTDSQtGrZcMB3LLelnuX/SP2Nc=;
        b=KgsOidvrbcO6fU1skx4kyAGn00NKAPLV/hJKqHJkE2Gb1+nA8QmttXwJFfGOJV2K24
         jmP4Hn4x9UcH14fvrHpIFH8g8ijrwg4cGrEXAaTSmOxk66ndFhn2CKGs+MfiHKetnQZp
         rRvOvcfxIe+M5+RvamgMlCdSmTzi2Wg27XTUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795180516; x=1795785316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I2Zr97px45Lj3XI6OkTDSQtGrZcMB3LLelnuX/SP2Nc=;
        b=Usazs5v7vVzC/Qr0zEmBxy1VkvGB+w6+Ij15q5F0SQlbAZQtjgZtqCE32TsGIDDm8A
         vem+QbUG7Iu61phY8rGFwHpeUNELCrvnnQkLEmMCXrpCVJ2QcmJbBGfUapHzwpKQrw8e
         wbllw7uRafit5v1OvoqawtHLJRG2cguBU0n/7bbL97q5jnzgeRnZgVjFSKgtd0lj1Igp
         Pp9eYVheX/Vifu0sASxfOj3T3yktjwsFzp/L3BE3oWUi7rRMKVUp0alxBRikoSMdPwmW
         YilCeAHpQP2d0AsWkxeQJIt05dbLkafvGVfFvPdkw8v8POHLRNXiETSBIqIavqPnEjCG
         LVXA==
X-Gm-Message-State: APuU4Z/2uYsWQl5LMJKsPL5v9j85R5Nmjf+19vAEjGCFt4KBng+YMwDZ
	uYp2Qni8XdSqZW9wH3DwhMKejq60NxwenlcsHhX7CBuPicFClHezzrJk79xXeBkGTf12efdOuMA
	t27RG
X-Gm-Gg: AZFdTZeXORf6j89Tx6HayZ+2l0Ct83WubW5CafN5XoYgzzI6kZGMGWOIwMjhyFKO8Gu
	HdNqtEFB8EqQ5XiK41P9xSOpz1TSZmAUJPe18ZmkdcJmyInMQvXIlkdT3wBLhhBMSWCYPxaNF/2
	eFUErTYxAm7cNzWSHRUdLV7yJUJ5PED6R42XDgeXKLnmGnbq+tmTa2KybP5nvI3ZavMx2hEFQpu
	ivIDs1WMpZcTn4PPxBWXRvWUfSYtS3WqOo8+J4br229BzSoQXMaeBp03XhIIFBxiOxpgx2sDwW7
	JneMy/CCDhE+Y0sspkx0oLICXLfASpx4wqh4Pff+XGojtq1M8TZualeksgX/Mk51nLKyOvCTseU
	KF21Kn1g42Q5M2alRiwq8WYvTroMR+3QyPtXgIMwD6D/8CtcbNEEvWlFLOWISzzIYBgYt4HYG/v
	dBkvhavngkHkbsAgpf/ST1ZU9ednIP+d9d7yreYeyfbZVuzrw4vi0oSw3DN7d8GNh4gmNVNWItx
	pJyP7umWHPu5ahj6CVQLC6iaRueYNv+Z6Kih7r+Ita+imwJTQU0zy+KZczN42c3ZtrXRTYCp3GD
	ryyKjx90EXEuuqS0/r93a3DOlygdjfUhletEnnUhaU1+8adP1ArnbmM7eKUCJJs12/TJuFagA16
	1PZIWdtfLcYKHhsQ8JLdWebawl9TQpr9ODL6oT6EXXeMn2eYW+WQDVCq1f9ZR+Ef7iqYj
X-Received: by 2002:a05:7301:4718:b0:369:fbc1:89c2 with SMTP id 5a478bee46e88-3856e63afdbmr2767679eec.8.1795180515753;
        Fri, 20 Nov 2026 05:15:15 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c349csm8900527eec.22.2026.11.20.05.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 05:15:15 -0800 (PST)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	ruud.derwig@gf.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v31 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Date: Fri, 20 Nov 2026 18:44:04 +0530
Message-Id: <20261120131404.976959-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261120131404.976959-1-pavitrakumarm@vayavyalabs.com>
References: <20261120131404.976959-1-pavitrakumarm@vayavyalabs.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Makefile and Kconfig for SPAcc driver.

Acked-by: Ross Bannerman <rbannerm@synopsys.com>
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
---
 drivers/crypto/Kconfig            |  1 +
 drivers/crypto/Makefile           |  1 +
 drivers/crypto/dwc-spacc/Kconfig  | 64 +++++++++++++++++++++++++++++++
 drivers/crypto/dwc-spacc/Makefile |  7 ++++
 4 files changed, 73 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index adcbe15851899..ece06af788132 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -738,6 +738,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.

 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"

 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 2c33b83f3cfa6..b80f211598bbc 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-y += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
new file mode 100644
index 0000000000000..b8a7d04209112
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Kconfig
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config CRYPTO_DEV_SPACC
+	tristate "Support for dwc_spacc Security Protocol Accelerator"
+	depends on HAS_DMA
+	depends on HAS_IOMEM
+	select CRYPTO_ENGINE
+	select CRYPTO_HASH if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_SHA1 if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_MD5 if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_SHA256 if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_SHA512 if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_SHA3 if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_HMAC if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_CMAC if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_XCBC if CRYPTO_DEV_SPACC_HASH
+	select CRYPTO_SM4_GENERIC if CRYPTO_DEV_SPACC_HASH
+	default n
+
+	help
+	  This enables support for SPAcc Hardware Accelerator.
+
+if CRYPTO_DEV_SPACC
+
+config CRYPTO_DEV_SPACC_HASH
+	bool "Enable HASH functionality"
+	default CRYPTO_DEV_SPACC
+	help
+	  Say y to enable Hash functionality of SPAcc.
+
+config CRYPTO_DEV_SPACC_AUTODETECT
+	bool "Enable Autodetect functionality"
+	default n
+	help
+	  Say y to enable Autodetect functionality of SPAcc.
+
+config CRYPTO_DEV_SPACC_DEBUG_TRACE_IO
+	bool "Enable Trace MMIO reads/writes stats"
+	default n
+	help
+	  Say y to enable Trace MMIO reads/writes stats.
+	  To Debug and trace IO register read/write operations.
+
+config CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+	bool "Enable Trace DDT entries stats"
+	default n
+	help
+	  Say y to enable Enable DDT entry stats.
+	  To Debug and trace DDT operation
+
+config CRYPTO_DEV_SPACC_SECURE_MODE
+	bool "Enable Spacc secure mode stats"
+	default n
+	help
+	  Say y to enable SPAcc secure modes stats.
+
+config CRYPTO_DEV_SPACC_CONFIG_DEBUG
+	bool "Enable SPAcc debug logs"
+	default n
+	help
+	  Say y to enable additional debug prints and diagnostics in the
+	  SPAcc driver. Disable this for production builds.
+
+endif # CRYPTO_DEV_SPACC
diff --git a/drivers/crypto/dwc-spacc/Makefile b/drivers/crypto/dwc-spacc/Makefile
new file mode 100644
index 0000000000000..b7125a7797ba0
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_SPACC) += snps-spacc.o
+
+snps-spacc-y := spacc_hal.o spacc_core.o \
+spacc_manager.o spacc_interrupt.o spacc_device.o
+
+snps-spacc-$(CONFIG_CRYPTO_DEV_SPACC_HASH) += spacc_ahash.o
--
2.25.1

