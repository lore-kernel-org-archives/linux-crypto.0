Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5927EC432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 13:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A0C42070B
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 13:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574342932;
	bh=0HkgFJdDQHE3by3aLKwO6EefVYZW/Zdkx6yOx0RE9LI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=JJZVhCQhkz0qWbBAyUU/qOuML5WRALyZRvNlrzoSVbr8/6mnG3OKoBGQqgKK3MvtZ
	 nEtQRMYbxgPfTuUnljKyX2vivulSbDTPxjTjYs0E3QiWSxx4BMT71yBug80cHAKpVl
	 iMjR17G53MXDlLgbtzo5d79xhD4mMSUD0IoF2OWg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfKUN2s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 08:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUN2r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 08:28:47 -0500
Received: from localhost.localdomain (unknown [118.189.143.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C7A12067D;
        Thu, 21 Nov 2019 13:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574342926;
        bh=0HkgFJdDQHE3by3aLKwO6EefVYZW/Zdkx6yOx0RE9LI=;
        h=From:To:Cc:Subject:Date:From;
        b=Z9ekmTt1Z/DFRkageVjT8bvI5YeOAb0650f720wGoJOjpENnmqgtgoVs8qj1apxlI
         JU8Pzf3vWKI4K0uWlNg5O/unzs4VSsN2fxFI7zO+sjLOVxr5juiP1fsfweYqTYc/L8
         PTU3wFvvCKJnnvg6VNmwV7qVjP9wttOPfkJMkx+U=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Corey Minyard <minyard@acm.org>, linux-crypto@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH] char: Fix Kconfig indentation, continued
Date:   Thu, 21 Nov 2019 21:28:41 +0800
Message-Id: <20191121132842.28942-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adjust indentation from seven spaces to tab (+optional two spaces) as in
coding style with command like:
	$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/char/hw_random/Kconfig | 18 +++----
 drivers/char/ipmi/Kconfig      | 98 +++++++++++++++++-----------------
 2 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 91db933ed85a..f898df4c1412 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -386,17 +386,17 @@ config HW_RANDOM_MESON
 	  If unsure, say Y.
 
 config HW_RANDOM_CAVIUM
-       tristate "Cavium ThunderX Random Number Generator support"
-       depends on HW_RANDOM && PCI && (ARM64 || (COMPILE_TEST && 64BIT))
-       default HW_RANDOM
-       ---help---
-	 This driver provides kernel-side support for the Random Number
-	 Generator hardware found on Cavium SoCs.
+	tristate "Cavium ThunderX Random Number Generator support"
+	depends on HW_RANDOM && PCI && (ARM64 || (COMPILE_TEST && 64BIT))
+	default HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on Cavium SoCs.
 
-	 To compile this driver as a module, choose M here: the
-	 module will be called cavium_rng.
+	  To compile this driver as a module, choose M here: the
+	  module will be called cavium_rng.
 
-	 If unsure, say Y.
+	  If unsure, say Y.
 
 config HW_RANDOM_MTK
 	tristate "Mediatek Random Number Generator support"
diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index cc4bea773ded..7dc2c3ec4051 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -4,38 +4,38 @@
 #
 
 menuconfig IPMI_HANDLER
-       tristate 'IPMI top-level message handler'
-       depends on HAS_IOMEM
-       select IPMI_DMI_DECODE if DMI
-       help
-	 This enables the central IPMI message handler, required for IPMI
-	 to work.
+	tristate 'IPMI top-level message handler'
+	depends on HAS_IOMEM
+	select IPMI_DMI_DECODE if DMI
+	help
+	  This enables the central IPMI message handler, required for IPMI
+	  to work.
 
-	 IPMI is a standard for managing sensors (temperature,
-	 voltage, etc.) in a system.
+	  IPMI is a standard for managing sensors (temperature,
+	  voltage, etc.) in a system.
 
-	 See <file:Documentation/IPMI.txt> for more details on the driver.
+	  See <file:Documentation/IPMI.txt> for more details on the driver.
 
-	 If unsure, say N.
+	  If unsure, say N.
 
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
-	 When a panic occurs, this will cause the IPMI message handler to,
-	 by default, generate an IPMI event describing the panic to each
-	 interface registered with the message handler.  This is always
-	 available, the module parameter for ipmi_msghandler named
-	 panic_op can be set to "event" to chose this value, this config
-	 simply causes the default value to be set to "event".
+	bool 'Generate a panic event to all BMCs on a panic'
+	help
+	  When a panic occurs, this will cause the IPMI message handler to,
+	  by default, generate an IPMI event describing the panic to each
+	  interface registered with the message handler.  This is always
+	  available, the module parameter for ipmi_msghandler named
+	  panic_op can be set to "event" to chose this value, this config
+	  simply causes the default value to be set to "event".
 
 config IPMI_PANIC_STRING
 	bool 'Generate OEM events containing the panic string'
@@ -54,43 +54,43 @@ config IPMI_PANIC_STRING
 	  causes the default value to be set to "string".
 
 config IPMI_DEVICE_INTERFACE
-       tristate 'Device interface for IPMI'
-       help
-	 This provides an IOCTL interface to the IPMI message handler so
-	 userland processes may use IPMI.  It supports poll() and select().
+	tristate 'Device interface for IPMI'
+	help
+	  This provides an IOCTL interface to the IPMI message handler so
+	  userland processes may use IPMI.  It supports poll() and select().
 
 config IPMI_SI
-       tristate 'IPMI System Interface handler'
-       select IPMI_PLAT_DATA
-       help
-	 Provides a driver for System Interfaces (KCS, SMIC, BT).
-	 Currently, only KCS and SMIC are supported.  If
-	 you are using IPMI, you should probably say "y" here.
+	tristate 'IPMI System Interface handler'
+	select IPMI_PLAT_DATA
+	help
+	  Provides a driver for System Interfaces (KCS, SMIC, BT).
+	  Currently, only KCS and SMIC are supported.  If
+	  you are using IPMI, you should probably say "y" here.
 
 config IPMI_SSIF
-       tristate 'IPMI SMBus handler (SSIF)'
-       select I2C
-       help
-	 Provides a driver for a SMBus interface to a BMC, meaning that you
-	 have a driver that must be accessed over an I2C bus instead of a
-	 standard interface.  This module requires I2C support.
+	tristate 'IPMI SMBus handler (SSIF)'
+	select I2C
+	help
+	  Provides a driver for a SMBus interface to a BMC, meaning that you
+	  have a driver that must be accessed over an I2C bus instead of a
+	  standard interface.  This module requires I2C support.
 
 config IPMI_POWERNV
-       depends on PPC_POWERNV
-       tristate 'POWERNV (OPAL firmware) IPMI interface'
-       help
-	 Provides a driver for OPAL firmware-based IPMI interfaces.
+	depends on PPC_POWERNV
+	tristate 'POWERNV (OPAL firmware) IPMI interface'
+	help
+	  Provides a driver for OPAL firmware-based IPMI interfaces.
 
 config IPMI_WATCHDOG
-       tristate 'IPMI Watchdog Timer'
-       help
-	 This enables the IPMI watchdog timer.
+	tristate 'IPMI Watchdog Timer'
+	help
+	  This enables the IPMI watchdog timer.
 
 config IPMI_POWEROFF
-       tristate 'IPMI Poweroff'
-       help
-	 This enables a function to power off the system with IPMI if
-	 the IPMI management controller is capable of this.
+	tristate 'IPMI Poweroff'
+	help
+	  This enables a function to power off the system with IPMI if
+	  the IPMI management controller is capable of this.
 
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
2.17.1

