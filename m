From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v11 4/5] LRNG - enable compile
Date: Sun, 14 May 2017 16:29:03 +0200
Message-ID: <2619717.M11260EEPi@positron.chronox.de>
References: <7746835.7W6fIIgSam@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59560 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751614AbdENObg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 May 2017 10:31:36 -0400
In-Reply-To: <7746835.7W6fIIgSam@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add LRNG compilation support.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/Kconfig  | 10 ++++++++++
 drivers/char/Makefile | 10 +++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 31adbeb..ee26190 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -594,5 +594,15 @@ config TILE_SROM
 
 source "drivers/char/xillybus/Kconfig"
 
+config LRNG
+	bool "Linux Random Number Generator"
+	select CRYPTO_DRBG_MENU
+	select CRYPTO_CMAC if CRYPTO_DRBG_CTR
+	help
+	  The Linux Random Number Generator (LRNG) is the replacement
+	  of the legacy /dev/random provided with drivers/char/random.c.
+	  It generates entropy from different noise sources and
+	  delivers significant entropy during boot.
+
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 6e6c244..618bebb 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -2,7 +2,15 @@
 # Makefile for the kernel character device drivers.
 #
 
-obj-y				+= mem.o random.o
+obj-y				+= mem.o
+
+ifeq ($(CONFIG_LRNG),y)
+  obj-$(CONFIG_LRNG)		+= lrng.o
+  lrng-y			+= lrng_base.o lrng_kcapi.o
+else
+  obj-y				+= random.o
+endif
+
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_ATARI_DSP56K)	+= dsp56k.o
-- 
2.9.3
