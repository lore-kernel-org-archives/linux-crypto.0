From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 07/30] Use menuconfig objects - crypto hw
Date: Tue, 10 Apr 2007 22:46:06 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704102245310.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tmailer.gwdg.de ([134.76.10.23]:35413 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030614AbXDJUro (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Apr 2007 16:47:44 -0400
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/drivers/crypto/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/crypto/Kconfig
+++ linux-2.6.21-rc5/drivers/crypto/Kconfig
@@ -1,4 +1,9 @@
-menu "Hardware crypto devices"
+
+menuconfig CRYPTO_HW
+	bool "Hardware crypto devices"
+	default y
+
+if CRYPTO_HW
 
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
@@ -66,4 +71,4 @@ config CRYPTO_DEV_GEODE
 	  To compile this driver as a module, choose M here: the module
 	  will be called geode-aes.
 
-endmenu
+endif # CRYPTO_HW
#<EOF>
