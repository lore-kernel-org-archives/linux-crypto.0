Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EB3C432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 13:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 373BC22528
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 13:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574257374;
	bh=90dtLk+IqP0UprqMWrNqJocmKABR/HpuO8r3OlLHJ+8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=qISseiTUR0zE8+C2avitxSvmwDIc4y7ohm/9idK6afkRen5jkpHJaA0uFRryf3rrj
	 SDzhWIE/JyRgGHvxN+PdmKPejincmDaJGwmWyoD3H72yXcIS0/Y6T1wBCOM6xIPuTy
	 5hygS8FJOlmZ29sVvDMDBAJFAosz74nVIxhvrMkQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfKTNmx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731440AbfKTNmx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 08:42:53 -0500
Received: from localhost.localdomain (unknown [118.189.143.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C63224FA;
        Wed, 20 Nov 2019 13:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574257371;
        bh=90dtLk+IqP0UprqMWrNqJocmKABR/HpuO8r3OlLHJ+8=;
        h=From:To:Cc:Subject:Date:From;
        b=qhaa0iik09JF5p1wuJcv4Twb6bl2bQHRtpsmvXYnAqmjGPIGTkvTXvQ+5EzLYQK7p
         jx16uJ1dMOXtAtu5tXUsPq1QEaLd+bOHfZzGg+jbPPgIR4gtRmw4ZkXiYA/NQhjcRJ
         mdt/CQWzVSWjuuLbieVPQjN/ozEqmCkP8KU5dw6Q=
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
Subject: [PATCH] char: Fix Kconfig indentation
Date:   Wed, 20 Nov 2019 21:42:47 +0800
Message-Id: <20191120134247.16073-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
	$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/char/Kconfig           |  6 +++---
 drivers/char/agp/Kconfig       |  2 +-
 drivers/char/hw_random/Kconfig | 10 +++++-----
 drivers/char/ipmi/Kconfig      | 20 ++++++++++----------
 4 files changed, 19 insertions(+), 19 deletions(-)

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
index 7c7fecfa2fb2..91db933ed85a 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -390,13 +390,13 @@ config HW_RANDOM_CAVIUM
        depends on HW_RANDOM && PCI && (ARM64 || (COMPILE_TEST && 64BIT))
        default HW_RANDOM
        ---help---
-         This driver provides kernel-side support for the Random Number
-         Generator hardware found on Cavium SoCs.
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
index 4bad0614109b..cc4bea773ded 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -8,13 +8,13 @@ menuconfig IPMI_HANDLER
        depends on HAS_IOMEM
        select IPMI_DMI_DECODE if DMI
        help
-         This enables the central IPMI message handler, required for IPMI
+	 This enables the central IPMI message handler, required for IPMI
 	 to work.
 
-         IPMI is a standard for managing sensors (temperature,
-         voltage, etc.) in a system.
+	 IPMI is a standard for managing sensors (temperature,
+	 voltage, etc.) in a system.
 
-         See <file:Documentation/IPMI.txt> for more details on the driver.
+	 See <file:Documentation/IPMI.txt> for more details on the driver.
 
 	 If unsure, say N.
 
@@ -56,14 +56,14 @@ config IPMI_PANIC_STRING
 config IPMI_DEVICE_INTERFACE
        tristate 'Device interface for IPMI'
        help
-         This provides an IOCTL interface to the IPMI message handler so
+	 This provides an IOCTL interface to the IPMI message handler so
 	 userland processes may use IPMI.  It supports poll() and select().
 
 config IPMI_SI
        tristate 'IPMI System Interface handler'
        select IPMI_PLAT_DATA
        help
-         Provides a driver for System Interfaces (KCS, SMIC, BT).
+	 Provides a driver for System Interfaces (KCS, SMIC, BT).
 	 Currently, only KCS and SMIC are supported.  If
 	 you are using IPMI, you should probably say "y" here.
 
@@ -71,7 +71,7 @@ config IPMI_SSIF
        tristate 'IPMI SMBus handler (SSIF)'
        select I2C
        help
-         Provides a driver for a SMBus interface to a BMC, meaning that you
+	 Provides a driver for a SMBus interface to a BMC, meaning that you
 	 have a driver that must be accessed over an I2C bus instead of a
 	 standard interface.  This module requires I2C support.
 
@@ -79,17 +79,17 @@ config IPMI_POWERNV
        depends on PPC_POWERNV
        tristate 'POWERNV (OPAL firmware) IPMI interface'
        help
-         Provides a driver for OPAL firmware-based IPMI interfaces.
+	 Provides a driver for OPAL firmware-based IPMI interfaces.
 
 config IPMI_WATCHDOG
        tristate 'IPMI Watchdog Timer'
        help
-         This enables the IPMI watchdog timer.
+	 This enables the IPMI watchdog timer.
 
 config IPMI_POWEROFF
        tristate 'IPMI Poweroff'
        help
-         This enables a function to power off the system with IPMI if
+	 This enables a function to power off the system with IPMI if
 	 the IPMI management controller is capable of this.
 
 endif # IPMI_HANDLER
-- 
2.17.1

