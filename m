Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F4C33D6F7;
	Sat, 30 May 2026 20:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780172852; cv=none; b=Ydbhp5EKBnREByafAdi6CMtiCIiOxS9h3uo2R1Z0Nl6hY0fMO4cg1qUR31PDgDXFXlYAf7Z9b4GX/dGimLeWNTtpjgboTCPUvyyEDWLho/aZNN+M2NKSDYOosWB8MaiUhC79OrPpt/z9WUwY2E2IkJgu8gZarJLoZDYKHX+xDuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780172852; c=relaxed/simple;
	bh=HOG8MRh1JSE3+YRjO2/kotlcNEhISK9YOayzZsv3e3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbXsWBD3noT10xIaADAfiowVGasqLYT41kUnix/EgGXAu3lbpyZ2P2c/2Gw58Tjrnj4Z4PIRuNm98/bkmhB7hAQZwFVM8M1WjqZLkCklBgqam5kiDrDou/pC62vNspzqG0oUv9dRaVUrour8M+Hujg30KK2R5TO9/qOALELQggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzZ/UslA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzZ/UslA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC651F0089A;
	Sat, 30 May 2026 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780172851;
	bh=p6oN29nL23YBC9zeu+cS0xAdL1Tlq04Bva1hFovgT3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzZ/UslAyfvjiwoMEHjMzBp7bf/x36lJJAT3m1Zf72griBVrViTTTUvepnPrHB61C
	 VfnEMNs2tsq/+Bo5g+FPgJeznk+l088xtfcptDrC+nZq0EO8cQ0SsK6CNOOftWwtst
	 KVzlTuW0VfRTnnHeM6ldHq5tZDK0/mk5g4qEsDdOeHdpZadaXwXVVCWO1/qVsVQiQ9
	 j2bN8I9FVaANvaNdTm1fh0FFXV/D5an24P5eg8bqXHrGiKm/7cmmMqchkymSBefYDj
	 +8eKqoJoyWaNLXMCL9FlosCaxPCoM2IZG+b5nt+uK2zGZEMsuODWO5rNx+z8qgMn6s
	 1c/bjrJbHGBLQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olivia Mackall <olivia@selenic.com>,
	Weili Qian <qianweili@huawei.com>,
	Wei Xu <xuwei5@hisilicon.com>,
	Longfang Liu <liulongfang@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] hwrng: hisi-trng - Move hisi-trng into drivers/char/hw_random/
Date: Sat, 30 May 2026 13:26:24 -0700
Message-ID: <20260530202624.20768-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260530202624.20768-1-ebiggers@kernel.org>
References: <20260530202624.20768-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since this file just implements a hwrng driver, move it into
drivers/char/hw_random/.  Rename the kconfig option accordingly as well.

Note that this moves the file back to its original location.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 MAINTAINERS                                            |  2 +-
 arch/arm64/configs/defconfig                           |  2 +-
 drivers/char/hw_random/Kconfig                         | 10 ++++++++++
 drivers/char/hw_random/Makefile                        |  1 +
 .../trng/trng.c => char/hw_random/hisi-trng-v2.c}      |  0
 drivers/crypto/hisilicon/Kconfig                       |  7 -------
 drivers/crypto/hisilicon/Makefile                      |  1 -
 drivers/crypto/hisilicon/trng/Makefile                 |  2 --
 8 files changed, 13 insertions(+), 12 deletions(-)
 rename drivers/{crypto/hisilicon/trng/trng.c => char/hw_random/hisi-trng-v2.c} (100%)
 delete mode 100644 drivers/crypto/hisilicon/trng/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 882214b0e7db..dcbbc56368be 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11703,11 +11703,11 @@ F:	Documentation/devicetree/bindings/mfd/hisilicon,hi6421-spmi-pmic.yaml
 F:	drivers/mfd/hi6421-spmi-pmic.c
 
 HISILICON TRUE RANDOM NUMBER GENERATOR V2 SUPPORT
 M:	Weili Qian <qianweili@huawei.com>
 S:	Maintained
-F:	drivers/crypto/hisilicon/trng/trng.c
+F:	drivers/char/hw_random/hisi-trng-v2.c
 
 HISILICON V3XX SPI NOR FLASH Controller Driver
 M:	Yang Shen <shenyang39@huawei.com>
 S:	Maintained
 W:	http://www.hisilicon.com
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index bb930cce7233..9aa62b675023 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -548,10 +548,11 @@ CONFIG_VIRTIO_CONSOLE=y
 CONFIG_IPMI_HANDLER=m
 CONFIG_IPMI_DEVICE_INTERFACE=m
 CONFIG_IPMI_SI=m
 CONFIG_HW_RANDOM=y
 CONFIG_HW_RANDOM_VIRTIO=y
+CONFIG_HW_RANDOM_HISI_TRNG=m
 CONFIG_HW_RANDOM_QCOM=m
 CONFIG_TCG_TPM=y
 CONFIG_TCG_TIS=m
 CONFIG_TCG_TIS_SPI=m
 CONFIG_TCG_TIS_SPI_CR50=y
@@ -1960,11 +1961,10 @@ CONFIG_CRYPTO_DEV_ZYNQMP_AES=m
 CONFIG_CRYPTO_DEV_ZYNQMP_SHA3=m
 CONFIG_CRYPTO_DEV_CCREE=m
 CONFIG_CRYPTO_DEV_HISI_SEC2=m
 CONFIG_CRYPTO_DEV_HISI_ZIP=m
 CONFIG_CRYPTO_DEV_HISI_HPRE=m
-CONFIG_CRYPTO_DEV_HISI_TRNG=m
 CONFIG_CRYPTO_DEV_SA2UL=m
 CONFIG_DMA_RESTRICTED_POOL=y
 CONFIG_CMA_SIZE_MBYTES=32
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_KERNEL=y
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 7102e03dcf0a..6d8012d55ac0 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -371,10 +371,20 @@ config HW_RANDOM_HISTB
 	  Generator hardware found on Hisilicon Hi37xx SoC.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called histb-rng.
 
+config HW_RANDOM_HISI_TRNG
+	tristate "HiSilicon True Random Number Generator support"
+	depends on ARM64 && ACPI
+	help
+	  This driver provides kernel-side support for the True Random Number
+	  Generator hardware found on some HiSilicon SoCs.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called hisi-trng-v2.
+
 config HW_RANDOM_ST
 	tristate "ST Microelectronics HW Random Number Generator support"
 	depends on ARCH_STI || COMPILE_TEST
 	help
 	  This driver provides kernel-side support for the Random Number
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 605ba8df5a8f..f2888524b6ef 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -29,10 +29,11 @@ obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
 obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
 obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
 obj-$(CONFIG_HW_RANDOM_HISI)	+= hisi-rng.o
 obj-$(CONFIG_HW_RANDOM_HISTB) += histb-rng.o
+obj-$(CONFIG_HW_RANDOM_HISI_TRNG) += hisi-trng-v2.o
 obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
 obj-$(CONFIG_HW_RANDOM_BCM74110) += bcm74110-rng.o
 obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) += iproc-rng200.o
 obj-$(CONFIG_HW_RANDOM_ST) += st-rng.o
 obj-$(CONFIG_HW_RANDOM_XGENE) += xgene-rng.o
diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/char/hw_random/hisi-trng-v2.c
similarity index 100%
rename from drivers/crypto/hisilicon/trng/trng.c
rename to drivers/char/hw_random/hisi-trng-v2.c
diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 8aa23c939775..aeff08ccbadd 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -73,12 +73,5 @@ config CRYPTO_DEV_HISI_HPRE
 	select CRYPTO_RSA
 	select CRYPTO_ECDH
 	help
 	  Support for HiSilicon HPRE(High Performance RSA Engine)
 	  accelerator, which can accelerate RSA and DH algorithms.
-
-config CRYPTO_DEV_HISI_TRNG
-	tristate "Support for HISI TRNG Driver"
-	depends on ARM64 && ACPI
-	select HW_RANDOM
-	help
-	  Support for HiSilicon TRNG Driver.
diff --git a/drivers/crypto/hisilicon/Makefile b/drivers/crypto/hisilicon/Makefile
index 8595a5a5d228..e1068ee9f973 100644
--- a/drivers/crypto/hisilicon/Makefile
+++ b/drivers/crypto/hisilicon/Makefile
@@ -3,6 +3,5 @@ obj-$(CONFIG_CRYPTO_DEV_HISI_HPRE) += hpre/
 obj-$(CONFIG_CRYPTO_DEV_HISI_SEC) += sec/
 obj-$(CONFIG_CRYPTO_DEV_HISI_SEC2) += sec2/
 obj-$(CONFIG_CRYPTO_DEV_HISI_QM) += hisi_qm.o
 hisi_qm-objs = qm.o sgl.o debugfs.o
 obj-$(CONFIG_CRYPTO_DEV_HISI_ZIP) += zip/
-obj-$(CONFIG_CRYPTO_DEV_HISI_TRNG) += trng/
diff --git a/drivers/crypto/hisilicon/trng/Makefile b/drivers/crypto/hisilicon/trng/Makefile
deleted file mode 100644
index d909079f351c..000000000000
--- a/drivers/crypto/hisilicon/trng/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-obj-$(CONFIG_CRYPTO_DEV_HISI_TRNG) += hisi-trng-v2.o
-hisi-trng-v2-objs = trng.o
-- 
2.54.0

