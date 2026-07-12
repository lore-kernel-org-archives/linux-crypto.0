Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8E3233923;
	Sun, 12 Jul 2026 21:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783891901; cv=none; b=OiKt/PX18XXSZjjiJgMm6qBDarIlfj4DRm2ZNqakBWlwiRmYHQCnNIFTZgJzh8ItY3N1/DGc65DtoibmtsE6SmquTEfIgMrBfG3PjcmCoGMDDQ5jR3z7mp3rkHoh4/FTApIXgyAPMoSXVUs0Adi6U3ZEsohFjkNx7nvxl2hM2qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783891901; c=relaxed/simple;
	bh=9FWW1i+hhUIvbjpIr65Q7V5Gh7SOFL1Xb3mRf1to5ic=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Am1QQIqFELZdq2gC/3q6xS+zuSafowHuWOQtvKxaPmfCcXCatrvWbazPeKS3wtRRqpoBaoGrC1NS9exZrm61OHV2iCAfydr00++HDsq9phT+2t9lDzkQ0PsiJF5NUBZRX4bFjQnaaTewMPj+VDCM5mfuu+mYZEZ44kVm24RdXVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o4e5iLPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o4e5iLPL"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B65AC2BCB7;
	Sun, 12 Jul 2026 21:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783891900;
	bh=9FWW1i+hhUIvbjpIr65Q7V5Gh7SOFL1Xb3mRf1to5ic=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=o4e5iLPLr+RTBrvPQS3WfLSEuYC1/8bl736/tDYfTYXzKbwdYeHCBwtID1/hwEDpK
	 YCkzIc1EcHLQwQq4PBFXlQbTgQLviLLAUsCJE5PqKMMNW2mFs7zzZmJGzk81TX3jot
	 Ngs3OrqO5X/PQImyK5H1OuB/XqcRLKSMx7EtfOf8lKPrH4pJJ2+Zx6S+RY/tgmcUOU
	 ulZLxyE8zUDz557f0qNOAxLD8eqIajUuvc39nilmAZTYIm+9PlrN9RGdkf3/tT2Fby
	 m69LMK/Eb+KRtKmn4IMiP78+pX+R4LSVJ5fUdeolIjYHKxGjgdXOtsksmkL+ZP1XqG
	 f1w+inbW1l/Vg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695E4C43458;
	Sun, 12 Jul 2026 21:31:40 +0000 (UTC)
From: Demi Marie Obenour via B4 Relay <devnull+demiobenour.gmail.com@kernel.org>
Date: Sun, 12 Jul 2026 17:31:31 -0400
Subject: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23MQQ6CMBCF4auQWTumU4QSV97DsIA6wESh2JpGQ
 3p3K2uX/0vet0FgLxzgXGzgOUoQt+TQhwLs1C0jo9xyg1a6VoY0Pi1j792dF6xVWTV1aenUKci
 H1fMg7x27trknCS/nP7sd6bf+ZSIhYVOx7oeBTGPoMs6dPI7WzdCmlL4k4213pAAAAA==
X-Change-ID: 20260712-qce-broken-6035863c14a0
To: Russell King <linux@armlinux.org.uk>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, stable@vger.kernel.org, 
 Demi Marie Obenour <demiobenour@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783891900; l=3669;
 i=demiobenour@gmail.com; s=20250731; h=from:subject:message-id;
 bh=0ILgQWt/4xfgFagXe7i7e2xC/Wm1GX2PHFzASrAHbAA=;
 b=Mp3fpdk7vu3JdbLmRrd/1oUzmDupyD0xlbfW4UJTanT9//APwjIrzaT4q5OB6aOQ/DTs7ipCB
 xN5u5LuXYA0An27pmX5VnKkcXYlZ9bmm/IcvSHMr6fR12NlkFMra50M
X-Developer-Key: i=demiobenour@gmail.com; a=ed25519;
 pk=4iGY+ynEKxIfs+fIUK9EzsvZ44yGE0GvXLeLTPKKPhI=
X-Endpoint-Received: by B4 Relay for demiobenour@gmail.com/20250731 with
 auth_id=473
X-Original-From: Demi Marie Obenour <demiobenour@gmail.com>
Reply-To: demiobenour@gmail.com

From: Demi Marie Obenour <demiobenour@gmail.com>

This driver is harmful:

- It is much slower than the CPU [1] [2].
- It Has a history of bugs [2] [3].
- It does not have exclusive access to the hardware [4], causing races
  with the secure world.
- It register its implementations with too low a cra_priority for them
  to be actually used [5].

Therefore, disable it to ensure that nobody builds it into kernels they
intend to ship.

In the future, the driver will be used for processing restricted media
content.  However, the kernel does not currently support this.  Since
the driver will have future uses, allow building it if COMPILE_TEST is
enabled.

[1]: https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel.org/
[2]: https://lore.kernel.org/r/20250615031807.GA81869@sol/
[3]: https://lore.kernel.org/r/20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com/
[4]: https://lore.kernel.org/r/20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com/
[5]: https://lore.kernel.org/r/20260524204537.GB110177@quark/

Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
---
Changes in v2:
- Add Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
- Add Cc: stable@vger.kernel.org
- Link to v1: https://lore.kernel.org/r/20260712-qce-broken-v1-1-85e2bff17871@gmail.com
---
 arch/arm/configs/multi_v7_defconfig | 1 -
 arch/arm64/configs/defconfig        | 1 -
 drivers/crypto/Kconfig              | 6 +++++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 01e016752c4d425e59a1a499abb8df8845aa9833..13d85a0e8580000235b4dbf6d0911b4e09af199d 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1321,7 +1321,6 @@ CONFIG_CRYPTO_DEV_ATMEL_AES=m
 CONFIG_CRYPTO_DEV_ATMEL_TDES=m
 CONFIG_CRYPTO_DEV_ATMEL_SHA=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=m
-CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_ROCKCHIP=m
 CONFIG_CRYPTO_DEV_STM32_HASH=m
 CONFIG_CRYPTO_DEV_STM32_CRYP=m
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 76ce07a08d5ac45bc4a4890c3f1aa7391de346fd..c624cdd122d144ad7e052f965c20c9bdcb3bd2e1 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1940,7 +1940,6 @@ CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
 CONFIG_CRYPTO_DEV_SUN8I_CE=m
 CONFIG_CRYPTO_DEV_FSL_CAAM=m
 CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM=m
-CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_TEGRA=m
 CONFIG_CRYPTO_DEV_ZYNQMP_AES=m
 CONFIG_CRYPTO_DEV_ZYNQMP_SHA3=m
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 03a8f7a1f75e878846dcf34da1265828949fbd9c..0189dfdcbbe11098ead0ea194293422a31d8fe65 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -528,13 +528,17 @@ source "drivers/crypto/intel/Kconfig"
 
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
-	depends on ARCH_QCOM || COMPILE_TEST
+	depends on (BROKEN && ARCH_QCOM) || COMPILE_TEST
 	depends on HAS_IOMEM
 	help
 	  This driver supports Qualcomm crypto engine accelerator
 	  hardware. To compile this driver as a module, choose M here. The
 	  module will be called qcrypto.
 
+	  This driver does not have exclusive access to the
+	  hardware, causing races with the secure world.  It
+	  is also slower than the CPU.
+
 config CRYPTO_DEV_QCE_SKCIPHER
 	bool
 	depends on CRYPTO_DEV_QCE

---
base-commit: e264401ce4776a288524e5b87593d4d864147115
change-id: 20260712-qce-broken-6035863c14a0

Best regards,
-- 
Demi Marie Obenour <demiobenour@gmail.com>


