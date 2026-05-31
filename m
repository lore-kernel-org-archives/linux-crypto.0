Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDC133B6F4;
	Sun, 31 May 2026 19:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255384; cv=none; b=jlfqwXJFe1ksbxNtUtwSRiq0QHpJY3UpHx68RV71/u4ju0cMgaxFSQGHzCMKOVZp6uSfHnFhLbPNsf0l/qg4FBT7QU63JSDd2QbiCC3ZJEAt6fsuZig3Kv3SeSY/mAx7FIqEKGIdwe/4+XPIv47rZm6trh2gup02i7uB9clDKqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255384; c=relaxed/simple;
	bh=5pCrWYczduBsQ/ALL2REyauU8QXHUfWLO1WwZnLzokQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rq4Ysn0k9H7Heb1gG46HzXThggcfqVdd9KZJpwzXhWHE4s9tHiYBLKr9V72hJ5dAhqGY7v+iB4GaAVgPn4/e6DymFp4z00qP01Adz2o4xQJdIssr1K5gdkbA92QA2imzoJSO/Pu8sRWASu6lRaUMjhZHzGNEBWTrEyhcZNSp3xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ko/tba3H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ko/tba3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6F61F00893;
	Sun, 31 May 2026 19:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780255382;
	bh=drqfjg2nZ2DWxQu7emk2SfhIy7vMmsaoIWRnmhbe+wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ko/tba3HLKucRJKVb3n0g3z/DuDY3BwGUbsgQq5qmDji6k2rtknzK3v1XdF/n1ncS
	 KkLOlk1cBZV+gTSjYpH+VKue3FcrF8L5ehR4iWlPd2UFnyXlupEcQmCUIWBRfdZXpv
	 O72ubfn8Is/ge2oVoCQq3Z3qWroJcyMGYXfKivzsadsM2pnTWCh6DvUKVUKhVNRY8J
	 gqVdaHtXv/vRrzrqpBSpBP7Hc2gm2OOHfxjeKhR2wPlckbbjrtD1vWjs9NN7Cksj/p
	 vUH1W+E0f71DQNyNey/AjnAk7obXtDpgLEdXF8T74+bNJGE2WszX6UBRCt7WLPU7h6
	 oEg2cxsT681IA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Mounika Botcha <mounika.botcha@amd.com>,
	Harsh Jain <h.jain@amd.com>,
	Olivia Mackall <olivia@selenic.com>,
	Michal Simek <michal.simek@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/4] hwrng: xilinx - Move xilinx-rng into drivers/char/hw_random/
Date: Sun, 31 May 2026 12:17:38 -0700
Message-ID: <20260531191738.55843-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260531191738.55843-1-ebiggers@kernel.org>
References: <20260531191738.55843-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since this file just implements a hwrng driver, move it into
drivers/char/hw_random/.  Rename the kconfig option accordingly as well.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 MAINTAINERS                                          |  2 +-
 arch/arm64/configs/defconfig                         |  2 +-
 drivers/char/hw_random/Kconfig                       | 11 +++++++++++
 drivers/char/hw_random/Makefile                      |  1 +
 .../{crypto/xilinx => char/hw_random}/xilinx-trng.c  |  0
 drivers/crypto/Kconfig                               | 12 ------------
 drivers/crypto/xilinx/Makefile                       |  1 -
 7 files changed, 14 insertions(+), 15 deletions(-)
 rename drivers/{crypto/xilinx => char/hw_random}/xilinx-trng.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 882214b0e7db..a593e78c30fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -29218,11 +29218,11 @@ F:	include/uapi/misc/xilinx_sdfec.h
 
 XILINX TRNG DRIVER
 M:	Mounika Botcha <mounika.botcha@amd.com>
 M:	Harsh Jain <h.jain@amd.com>
 S:	Maintained
-F:	drivers/crypto/xilinx/xilinx-trng.c
+F:	drivers/char/hw_random/xilinx-trng.c
 
 XILINX UARTLITE SERIAL DRIVER
 M:	Peter Korsgaard <jacmet@sunsite.dk>
 L:	linux-serial@vger.kernel.org
 S:	Maintained
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index bb930cce7233..d8fb11e4c36d 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -549,10 +549,11 @@ CONFIG_IPMI_HANDLER=m
 CONFIG_IPMI_DEVICE_INTERFACE=m
 CONFIG_IPMI_SI=m
 CONFIG_HW_RANDOM=y
 CONFIG_HW_RANDOM_VIRTIO=y
 CONFIG_HW_RANDOM_QCOM=m
+CONFIG_HW_RANDOM_XILINX=m
 CONFIG_TCG_TPM=y
 CONFIG_TCG_TIS=m
 CONFIG_TCG_TIS_SPI=m
 CONFIG_TCG_TIS_SPI_CR50=y
 CONFIG_TCG_TIS_I2C_CR50=m
@@ -1953,11 +1954,10 @@ CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
 CONFIG_CRYPTO_DEV_SUN8I_CE=m
 CONFIG_CRYPTO_DEV_FSL_CAAM=m
 CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM=m
 CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_TEGRA=m
-CONFIG_CRYPTO_DEV_XILINX_TRNG=m
 CONFIG_CRYPTO_DEV_ZYNQMP_AES=m
 CONFIG_CRYPTO_DEV_ZYNQMP_SHA3=m
 CONFIG_CRYPTO_DEV_CCREE=m
 CONFIG_CRYPTO_DEV_HISI_SEC2=m
 CONFIG_CRYPTO_DEV_HISI_ZIP=m
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 7102e03dcf0a..e0a53ba558a0 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -624,10 +624,21 @@ config HW_RANDOM_QCOM
 	  Generator hardware found on some Qualcomm SoCs.
 
 	  To compile this driver as a module, choose M here. The
 	  module will be called qcom-rng. If unsure, say N.
 
+config HW_RANDOM_XILINX
+	tristate "Support for Xilinx True Random Generator"
+	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
+	select CRYPTO_LIB_SHA512
+	help
+	  Xilinx Versal SoC driver provides kernel-side support for True Random Number
+	  Generator and Pseudo random Number in CTR_DRBG mode as defined in NIST SP800-90A.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called xilinx-trng.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
 	depends on UML
 	select HW_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 605ba8df5a8f..470004ad841a 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -51,5 +51,6 @@ obj-$(CONFIG_HW_RANDOM_ARM_SMCCC_TRNG) += arm_smccc_trng.o
 obj-$(CONFIG_HW_RANDOM_CN10K) += cn10k-rng.o
 obj-$(CONFIG_HW_RANDOM_POLARFIRE_SOC) += mpfs-rng.o
 obj-$(CONFIG_HW_RANDOM_ROCKCHIP) += rockchip-rng.o
 obj-$(CONFIG_HW_RANDOM_JH7110) += jh7110-trng.o
 obj-$(CONFIG_HW_RANDOM_QCOM) += qcom-rng.o
+obj-$(CONFIG_HW_RANDOM_XILINX) += xilinx-trng.o
diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/char/hw_random/xilinx-trng.c
similarity index 100%
rename from drivers/crypto/xilinx/xilinx-trng.c
rename to drivers/char/hw_random/xilinx-trng.c
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ad6427f08d4f..451d61b33143 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -704,22 +704,10 @@ config CRYPTO_DEV_TEGRA
 
 	help
 	  Select this to enable Tegra Security Engine which accelerates various
 	  AES encryption/decryption and HASH algorithms.
 
-config CRYPTO_DEV_XILINX_TRNG
-	tristate "Support for Xilinx True Random Generator"
-	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
-	select CRYPTO_LIB_SHA512
-	select HW_RANDOM
-	help
-	  Xilinx Versal SoC driver provides kernel-side support for True Random Number
-	  Generator and Pseudo random Number in CTR_DRBG mode as defined in NIST SP800-90A.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called xilinx-trng.
-
 config CRYPTO_DEV_ZYNQMP_AES
 	tristate "Support for Xilinx ZynqMP AES hw accelerator"
 	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_ENGINE
diff --git a/drivers/crypto/xilinx/Makefile b/drivers/crypto/xilinx/Makefile
index 9b51636ef75e..730feff5b5f2 100644
--- a/drivers/crypto/xilinx/Makefile
+++ b/drivers/crypto/xilinx/Makefile
@@ -1,4 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_CRYPTO_DEV_XILINX_TRNG) += xilinx-trng.o
 obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += zynqmp-aes-gcm.o
 obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_SHA3) += zynqmp-sha.o
-- 
2.54.0

