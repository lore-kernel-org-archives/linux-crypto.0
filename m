Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF94CC432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 03:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C711208C3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 03:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574306347;
	bh=1bqZPQuO1X7ZNq9CpnFjGd2MPvDWAZkp3viGUMDkQ7M=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=V0JWoBoQXa37vVDnInaexKGHj9/d5YwrIZ5D2a+vGCDMeGrXtYI7GQJwvc0H1t2Rp
	 8+tpsPr7nc+16RpS8rZH3CjOiztLW5sdgg/tZAiCLAUwkcrJwy4maUJFkNRgSEplFN
	 ummILPmJMp8uu/wVO+y2LoFaHQtIBM3kGWengMLc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKUDTG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 22:19:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfKUDTF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 22:19:05 -0500
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9206520898;
        Thu, 21 Nov 2019 03:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574306344;
        bh=1bqZPQuO1X7ZNq9CpnFjGd2MPvDWAZkp3viGUMDkQ7M=;
        h=From:To:Cc:Subject:Date:From;
        b=m/hX2Q3JKGQIqE9nxtGxON8p5plTPSoQZMpi1ynYAlIK1+Z5CAbgjMFBKGRHeCxGt
         AKvojYbj6EKleMYwxZ78MgaSVgNuQHZAEodKkJ/jpr7omNVhGFqQlRlMss3WZTlfcy
         /wJ2NA0LU+Yz+2S9toC9JnqRI7k9d70e0VdNC9QA=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Corey Minyard <minyard@acm.org>, linux-crypto@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH v2] char: Fix Kconfig indentation
Date:   Thu, 21 Nov 2019 04:19:00 +0100
Message-Id: <1574306340-29108-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
	$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v1:
1. Fix also 7-space and tab+1 space indentation issues.
---
 drivers/char/Kconfig           |  6 ++--
 drivers/char/agp/Kconfig       |  2 +-
 drivers/char/hw_random/Kconfig | 18 +++++------
 drivers/char/ipmi/Kconfig      | 70 +++++++++++++++++++++---------------------
 4 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index df0fc997dc3e..26956c006987 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -439,8 +439,8 @@ config RAW_DRIVER
 	  Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
 	  See the raw(8) manpage for more details.
 
-          Applications should preferably open the device (eg /dev/hda1)
-          with the O_DIRECT flag.
+	  Applications should preferably open the device (eg /dev/hda1)
+	  with the O_DIRECT flag.
 
 config MAX_RAW_DEVS
 	int "Maximum number of RAW devices to support (1-65536)"
@@ -559,4 +559,4 @@ config RANDOM_TRUST_BOOTLOADER
 	device randomness. Say Y here to assume the entropy provided by the
 	booloader is trustworthy so it will be added to the kernel's entropy
 	pool. Otherwise, say N here so it will be regarded as device input that
-	only mixes the entropy pool.
\ No newline at end of file
+	only mixes the entropy pool.
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index 812d6aa6e013..bc54235a7022 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -63,7 +63,7 @@ config AGP_AMD64
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
 	  You still need an external AGP bridge like the AMD 8151, VIA
-          K8T400M, SiS755. It may also support other AGP bridges when loaded
+	  K8T400M, SiS755. It may also support other AGP bridges when loaded
 	  with agp_try_unsupported=1.
 
 config AGP_INTEL
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 7c7fecfa2fb2..9f19bfc22061 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -386,17 +386,17 @@ config HW_RANDOM_MESON
 	  If unsure, say Y.
 
 config HW_RANDOM_CAVIUM
-       tristate "Cavium ThunderX Random Number Generator support"
-       depends on HW_RANDOM && PCI && (ARM64 || (COMPILE_TEST && 64BIT))
-       default HW_RANDOM
-       ---help---
-         This driver provides kernel-side support for the Random Number
-         Generator hardware found on Cavium SoCs.
+	tristate "Cavium ThunderX Random Number Generator support"
+	depends on HW_RANDOM && PCI && (ARM64 || (COMPILE_TEST && 64BIT))
+	default HW_RANDOM
+	---help---
+	 This driver provides kernel-side support for the Random Number
+	 Generator hardware found on Cavium SoCs.
 
-         To compile this driver as a module, choose M here: the
-         module will be called cavium_rng.
+	 To compile this driver as a module, choose M here: the
+	 module will be called cavium_rng.
 
-         If unsure, say Y.
+	 If unsure, say Y.
 
 config HW_RANDOM_MTK
 	tristate "Mediatek Random Number Generator support"
diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index 4bad0614109b..6a26bab8b101 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -4,32 +4,32 @@
 #
 
 menuconfig IPMI_HANDLER
-       tristate 'IPMI top-level message handler'
-       depends on HAS_IOMEM
-       select IPMI_DMI_DECODE if DMI
-       help
-         This enables the central IPMI message handler, required for IPMI
+	tristate 'IPMI top-level message handler'
+	depends on HAS_IOMEM
+	select IPMI_DMI_DECODE if DMI
+	help
+	 This enables the central IPMI message handler, required for IPMI
 	 to work.
 
-         IPMI is a standard for managing sensors (temperature,
-         voltage, etc.) in a system.
+	 IPMI is a standard for managing sensors (temperature,
+	 voltage, etc.) in a system.
 
-         See <file:Documentation/IPMI.txt> for more details on the driver.
+	 See <file:Documentation/IPMI.txt> for more details on the driver.
 
 	 If unsure, say N.
 
 config IPMI_DMI_DECODE
-       select IPMI_PLAT_DATA
-       bool
+	select IPMI_PLAT_DATA
+	bool
 
 config IPMI_PLAT_DATA
-       bool
+	bool
 
 if IPMI_HANDLER
 
 config IPMI_PANIC_EVENT
-       bool 'Generate a panic event to all BMCs on a panic'
-       help
+	bool 'Generate a panic event to all BMCs on a panic'
+	help
 	 When a panic occurs, this will cause the IPMI message handler to,
 	 by default, generate an IPMI event describing the panic to each
 	 interface registered with the message handler.  This is always
@@ -54,42 +54,42 @@ config IPMI_PANIC_STRING
 	  causes the default value to be set to "string".
 
 config IPMI_DEVICE_INTERFACE
-       tristate 'Device interface for IPMI'
-       help
-         This provides an IOCTL interface to the IPMI message handler so
+	tristate 'Device interface for IPMI'
+	help
+	 This provides an IOCTL interface to the IPMI message handler so
 	 userland processes may use IPMI.  It supports poll() and select().
 
 config IPMI_SI
-       tristate 'IPMI System Interface handler'
-       select IPMI_PLAT_DATA
-       help
-         Provides a driver for System Interfaces (KCS, SMIC, BT).
+	tristate 'IPMI System Interface handler'
+	select IPMI_PLAT_DATA
+	help
+	 Provides a driver for System Interfaces (KCS, SMIC, BT).
 	 Currently, only KCS and SMIC are supported.  If
 	 you are using IPMI, you should probably say "y" here.
 
 config IPMI_SSIF
-       tristate 'IPMI SMBus handler (SSIF)'
-       select I2C
-       help
-         Provides a driver for a SMBus interface to a BMC, meaning that you
+	tristate 'IPMI SMBus handler (SSIF)'
+	select I2C
+	help
+	 Provides a driver for a SMBus interface to a BMC, meaning that you
 	 have a driver that must be accessed over an I2C bus instead of a
 	 standard interface.  This module requires I2C support.
 
 config IPMI_POWERNV
-       depends on PPC_POWERNV
-       tristate 'POWERNV (OPAL firmware) IPMI interface'
-       help
-         Provides a driver for OPAL firmware-based IPMI interfaces.
+	depends on PPC_POWERNV
+	tristate 'POWERNV (OPAL firmware) IPMI interface'
+	help
+	 Provides a driver for OPAL firmware-based IPMI interfaces.
 
 config IPMI_WATCHDOG
-       tristate 'IPMI Watchdog Timer'
-       help
-         This enables the IPMI watchdog timer.
+	tristate 'IPMI Watchdog Timer'
+	help
+	 This enables the IPMI watchdog timer.
 
 config IPMI_POWEROFF
-       tristate 'IPMI Poweroff'
-       help
-         This enables a function to power off the system with IPMI if
+	tristate 'IPMI Poweroff'
+	help
+	 This enables a function to power off the system with IPMI if
 	 the IPMI management controller is capable of this.
 
 endif # IPMI_HANDLER
@@ -126,7 +126,7 @@ config NPCM7XX_KCS_IPMI_BMC
 
 config ASPEED_BT_IPMI_BMC
 	depends on ARCH_ASPEED || COMPILE_TEST
-       depends on REGMAP && REGMAP_MMIO && MFD_SYSCON
+	depends on REGMAP && REGMAP_MMIO && MFD_SYSCON
 	tristate "BT IPMI bmc driver"
 	help
 	  Provides a driver for the BT (Block Transfer) IPMI interface
-- 
2.7.4

