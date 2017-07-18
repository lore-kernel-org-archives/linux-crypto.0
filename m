From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [RFC PATCH v12 4/4] LRNG - enable compile
Date: Tue, 18 Jul 2017 09:59:29 +0200
Message-ID: <5071655.YFHJQhx4QD@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3910055.ntkqcq1Chb@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add LRNG compilation support.

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/Kconfig  | 10 ++++++++++
 drivers/char/Makefile | 10 +++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index ccd239a..88cc472 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -587,5 +587,15 @@ config TILE_SROM
 
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
index 53e3372..87e06ec 100644
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
+  lrng-y			+= lrng_base.o lrng_chacha20.o
+else
+  obj-y				+= random.o
+endif
+
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_ATARI_DSP56K)	+= dsp56k.o
-- 
2.9.4
