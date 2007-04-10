From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 06/30] Use menuconfig objects - crypto
Date: Tue, 10 Apr 2007 22:45:28 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704102243520.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tmailer.gwdg.de ([134.76.10.23]:35192 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbXDJUrM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Apr 2007 16:47:12 -0400
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/crypto/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/crypto/Kconfig
+++ linux-2.6.21-rc5/crypto/Kconfig
@@ -2,9 +2,7 @@
 # Cryptographic API Configuration
 #
 
-menu "Cryptographic options"
-
-config CRYPTO
+menuconfig CRYPTO
 	bool "Cryptographic API"
 	help
 	  This option provides the core Cryptographic API.
@@ -450,5 +448,3 @@ config CRYPTO_TEST
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
-
-endmenu
#<EOF>
