Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F2B241A14;
	Wed, 15 Jan 2025 13:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736946450; cv=none; b=hIVsAfrcCWiVU+tpgtz9mYkqYagF+46zxJ6PNg71CN3ur3vS7xuSxiBoNQdqsCuDiPm1RrQmnRlmbb5NjNvThNOVgxOpe6TNLPZwiusofOY+lVPg0EA0Hg+OD806TG+xmil/sJJCKckT2TkTHge/x/azjn18F6v5+sKz6OyOppc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736946450; c=relaxed/simple;
	bh=AfxnL6Ssa+MOZx0Tz6ibvvZQKHiBwSpkyaF8TAq0I7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r5LUA6hD6K1vIzQQRjgrhPnt3oeJlvQfxM81HhQlU8jMJrglsDOH6Hqxs6jC2uAOLHBFPheLYfXoQdauExJWbXWt88iTcndXqAL283o7MKRLGXgxQRu5Ozqw+Db+MRWOLqnUwW06h0O30TuaL8w945rW4PlRtQD55Ashc6JdjLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=BdbB+7Sf; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="BdbB+7Sf"
From: Dragan Simic <dsimic@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1736946443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ghcxbOi4AI3ArbEOzt+OPEuH7D0iZBBXULBx5cUb5ak=;
	b=BdbB+7Sfk7lkMF+lgfB3NPQn+CDq/SLi6w25HzCgl1lRPDuqa1iSVFGati8jf59jOK95Zq
	XUd4mhw1CPpcIGsoqpggOo9JjdUFf3JhNgUIzB9pUcyjqoMgKo2qtrY8P8LFwnzh6HAl66
	OYaTUC0IJuVgNHcvB0A7s5Le+WeEI+L3eEMOIgLVmjGqMe5ZBPbUteIvUdjuTCN9Ik1AfN
	RpuQDiFfkF6R/zuQqMDaEK6cCOhDL8s2/vM7e4Owhe9Sw0NbVNneMutGUnaTjlfHBmRrB6
	xKb+6XnBD1mOiyqcTbH5EOdH0D8BLZC9UtR48roFSd9drAkxaauef8So/+kuZg==
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	didi.debian@cknow.org,
	heiko@sntech.de,
	dsimic@manjaro.org
Subject: [PATCH 3/3] hwrng: Don't default to HW_RANDOM when UML_RANDOM is the trigger
Date: Wed, 15 Jan 2025 14:07:02 +0100
Message-Id: <3d3f93bd1f8b9629e48b9ad96099e33069a455c1.1736946020.git.dsimic@manjaro.org>
In-Reply-To: <cover.1736946020.git.dsimic@manjaro.org>
References: <cover.1736946020.git.dsimic@manjaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Since the commit 72d3e093afae (um: random: Register random as hwrng-core
device), selecting the UML_RANDOM option may result in various HW_RANDOM_*
options becoming selected as well, which doesn't make much sense for UML
that obviously cannot use any of those HWRNG devices.

Let's have the HW_RANDOM_* options selected by default only when UML_RANDOM
actually isn't already selected.  With that in place, selecting UML_RANDOM
no longer "triggers" the selection of various HW_RANDOM_* options.

Fixes: 72d3e093afae (um: random: Register random as hwrng-core device)
Reported-by: Diederik de Haas <didi.debian@cknow.org>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
---
 drivers/char/hw_random/Kconfig | 76 +++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index e84c7f431840..283aba711af5 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -38,47 +38,47 @@ config HW_RANDOM_TIMERIOMEM
 config HW_RANDOM_INTEL
 	tristate "Intel HW Random Number Generator support"
 	depends on (X86 || COMPILE_TEST) && PCI
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Intel i8xx-based motherboards.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called intel-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_AMD
 	tristate "AMD HW Random Number Generator support"
 	depends on (X86 || COMPILE_TEST)
 	depends on PCI && HAS_IOPORT_MAP
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on AMD 76x-based motherboards.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called amd-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_AIROHA
 	tristate "Airoha True HW Random Number Generator support"
 	depends on ARCH_AIROHA || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the True Random Number
 	  Generator hardware found on Airoha SoC.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called airoha-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_ATMEL
 	tristate "Atmel Random Number Generator support"
 	depends on (ARCH_AT91 || COMPILE_TEST)
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Atmel AT91 devices.
@@ -102,139 +102,139 @@ config HW_RANDOM_BCM2835
 	tristate "Broadcom BCM2835/BCM63xx Random Number Generator support"
 	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X || \
 		   ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on the Broadcom BCM2835 and BCM63xx SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called bcm2835-rng
 
 	  If unsure, say Y.
 
 config HW_RANDOM_BCM74110
 	tristate "Broadcom BCM74110 Random Number Generator support"
 	depends on ARCH_BRCMSTB || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on the Broadcom BCM74110 SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called bcm74110-rng
 
 	  If unsure, say Y.
 
 config HW_RANDOM_IPROC_RNG200
 	tristate "Broadcom iProc/STB RNG200 support"
 	depends on ARCH_BCM_IPROC || ARCH_BCM2835 || ARCH_BCMBCA || ARCH_BRCMSTB || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the RNG200
 	  hardware found on the Broadcom iProc and STB SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called iproc-rng200
 
 	  If unsure, say Y.
 
 config HW_RANDOM_GEODE
 	tristate "AMD Geode HW Random Number Generator support"
 	depends on (X86_32 || COMPILE_TEST)
 	depends on PCI
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on the AMD Geode LX.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called geode-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_N2RNG
 	tristate "Niagara2 Random Number Generator support"
 	depends on SPARC64
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Niagara2 cpus.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called n2-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_VIA
 	tristate "VIA HW Random Number Generator support"
 	depends on X86
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on VIA based motherboards.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called via-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_IXP4XX
 	tristate "Intel IXP4xx NPU HW Pseudo-Random Number Generator support"
 	depends on ARCH_IXP4XX || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Pseudo-Random
 	  Number Generator hardware found on the Intel IXP45x/46x NPU.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ixp4xx-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_OMAP
 	tristate "OMAP Random Number Generator support"
 	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS || ARCH_MVEBU || ARCH_K3 || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on OMAP16xx, OMAP2/3/4/5, AM33xx/AM43xx
 	  multimedia processors, and Marvell Armada 7k/8k SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called omap-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_OMAP3_ROM
 	tristate "OMAP3 ROM Random Number Generator support"
 	depends on ARCH_OMAP3 || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on OMAP34xx processors.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called omap3-rom-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_OCTEON
 	tristate "Octeon Random Number Generator support"
 	depends on CAVIUM_OCTEON_SOC
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Octeon processors.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called octeon-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_PASEMI
 	tristate "PA Semi HW Random Number Generator support"
 	depends on PPC_PASEMI || (PPC && COMPILE_TEST)
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on PA Semi PWRficient SoCs.
@@ -257,114 +257,114 @@ config HW_RANDOM_VIRTIO
 config HW_RANDOM_MXC_RNGA
 	tristate "Freescale i.MX RNGA Random Number Generator"
 	depends on SOC_IMX31 || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Freescale i.MX processors.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called mxc-rnga.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_IMX_RNGC
 	tristate "Freescale i.MX RNGC Random Number Generator"
 	depends on HAS_IOMEM
 	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator Version C hardware found on some Freescale i.MX
 	  processors. Version B is also supported by this driver.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called imx-rngc.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_INGENIC_RNG
 	tristate "Ingenic Random Number Generator support"
 	depends on MACH_JZ4780 || MACH_X1000 || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number Generator
 	  hardware found in ingenic JZ4780 and X1000 SoC. MIPS Creator CI20 uses
 	  JZ4780 SoC, YSH & ATIL CU1000-Neo uses X1000 SoC.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ingenic-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_INGENIC_TRNG
 	tristate "Ingenic True Random Number Generator support"
 	depends on MACH_X1830 || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the True Random Number Generator
 	  hardware found in ingenic X1830 SoC. YSH & ATIL CU1830-Neo uses X1830 SoC.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ingenic-trng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
 	depends on ARCH_NOMADIK || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on ST-Ericsson SoCs (8815 and 8500).
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called nomadik-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_PSERIES
 	tristate "pSeries HW Random Number Generator support"
 	depends on PPC64 && IBMVIO
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on POWER7+ machines and above
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called pseries-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_POWERNV
 	tristate "PowerNV Random Number Generator support"
 	depends on PPC_POWERNV
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This is the driver for Random Number Generator hardware found
 	  in POWER7+ and above machines for PowerNV platform.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called powernv-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_HISI
 	tristate "Hisilicon Random Number Generator support"
 	depends on ARCH_HISI || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Hisilicon Hip04 and Hip05 SoC.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called hisi-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_HISTB
 	tristate "Hisilicon STB Random Number Generator support"
 	depends on ARCH_HISI || COMPILE_TEST
-	default ARCH_HISI
+	default ARCH_HISI if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Hisilicon Hi37xx SoC.
@@ -385,34 +385,34 @@ config HW_RANDOM_ST
 config HW_RANDOM_XGENE
 	tristate "APM X-Gene True Random Number Generator (TRNG) support"
 	depends on ARCH_XGENE || COMPILE_TEST
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on APM X-Gene SoC.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called xgene_rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_STM32
 	tristate "STMicroelectronics STM32 random number generator"
 	depends on ARCH_STM32 || COMPILE_TEST
 	depends on HAS_IOMEM
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on STM32 microcontrollers.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called stm32-rng.
 
 	  If unsure, say N.
 
 config HW_RANDOM_PIC32
 	tristate "Microchip PIC32 Random Number Generator support"
 	depends on MACH_PIC32 || COMPILE_TEST
-	default HW_RANDOM if MACH_PIC32
+	default HW_RANDOM if MACH_PIC32 && !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on a PIC32.
@@ -439,105 +439,105 @@ config HW_RANDOM_MESON
 	tristate "Amlogic Meson Random Number Generator support"
 	depends on ARCH_MESON || COMPILE_TEST
 	depends on HAS_IOMEM && OF
-	default HW_RANDOM if ARCH_MESON
+	default HW_RANDOM if ARCH_MESON && !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Amlogic Meson SoCs.
 
 	  To compile this driver as a module, choose M here. the
 	  module will be called meson-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_CAVIUM
 	tristate "Cavium ThunderX Random Number Generator support"
 	depends on PCI
 	depends on ARCH_THUNDER || (ARM64 && COMPILE_TEST)
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Cavium SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called cavium_rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_MTK
 	tristate "Mediatek Random Number Generator support"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	depends on HAS_IOMEM && OF
-	default HW_RANDOM if ARCH_MEDIATEK
+	default HW_RANDOM if ARCH_MEDIATEK && !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Mediatek SoCs.
 
 	  To compile this driver as a module, choose M here. the
 	  module will be called mtk-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_S390
 	tristate "S390 True Random Number Generator support"
 	depends on S390
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the True
 	  Random Number Generator available as CPACF extension
 	  on modern s390 hardware platforms.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called s390-trng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_EXYNOS
 	tristate "Samsung Exynos True Random Number Generator support"
 	depends on ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_IOMEM
-	default HW_RANDOM if ARCH_EXYNOS
+	default HW_RANDOM if ARCH_EXYNOS && !UML_RANDOM
 	help
 	  This driver provides support for the True Random Number
 	  Generator available in Exynos SoCs.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called exynos-trng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_OPTEE
 	tristate "OP-TEE based Random Number Generator support"
 	depends on OPTEE
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This  driver provides support for OP-TEE based Random Number
 	  Generator on ARM SoCs where hardware entropy sources are not
 	  accessible to normal world (Linux).
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called optee-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_NPCM
 	tristate "NPCM Random Number Generator support"
 	depends on ARCH_NPCM || COMPILE_TEST
 	depends on HAS_IOMEM
-	default HW_RANDOM if ARCH_NPCM
+	default HW_RANDOM if ARCH_NPCM && !UML_RANDOM
 	help
 	  This driver provides support for the Random Number
 	  Generator hardware available in Nuvoton NPCM SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called npcm-rng.
 
 	  If unsure, say Y.
 
 config HW_RANDOM_KEYSTONE
 	tristate "TI Keystone NETCP SA Hardware random number generator"
 	depends on ARCH_KEYSTONE || COMPILE_TEST
 	depends on HAS_IOMEM && OF
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This option enables Keystone's hardware random generator.
 
@@ -567,21 +567,21 @@ config HW_RANDOM_XIPHERA
 config HW_RANDOM_ARM_SMCCC_TRNG
 	tristate "Arm SMCCC TRNG firmware interface support"
 	depends on HAVE_ARM_SMCCC_DISCOVERY
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  Say 'Y' to enable the True Random Number Generator driver using
 	  the Arm SMCCC TRNG firmware interface. This reads entropy from
 	  higher exception levels (firmware, hypervisor). Uses SMCCC for
 	  communicating with the firmware:
 	  https://developer.arm.com/documentation/den0098/latest/
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called arm_smccc_trng.
 
 config HW_RANDOM_CN10K
 	tristate "Marvell CN10K Random Number Generator support"
 	depends on HW_RANDOM && PCI && (ARM64 || (64BIT && COMPILE_TEST))
-	default HW_RANDOM if ARCH_THUNDER
+	default HW_RANDOM if ARCH_THUNDER && !UML_RANDOM
 	help
 	 This driver provides support for the True Random Number
 	 generator available in Marvell CN10K SoCs.
@@ -603,7 +603,7 @@ config HW_RANDOM_ROCKCHIP
 	tristate "Rockchip True Random Number Generator"
 	depends on HW_RANDOM && (ARCH_ROCKCHIP || COMPILE_TEST)
 	depends on HAS_IOMEM
-	default HW_RANDOM
+	default HW_RANDOM if !UML_RANDOM
 	help
 	  This driver provides kernel-side support for the True Random Number
 	  Generator hardware found on some Rockchip SoC like RK3566 or RK3568.
