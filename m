From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: ux500: do not build with -O0
Date: Mon, 27 Jun 2016 11:17:40 +0200
Message-ID: <20160627091809.1349621-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:58657 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbcF0JQI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Jun 2016 05:16:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ARM allmodconfig build currently warngs because of the
ux500 crypto driver not working well with the jump label
implementation that we started using for dynamic debug, which
breaks building with 'gcc -O0':

In file included from /git/arm-soc/include/linux/jump_label.h:105:0,
                 from /git/arm-soc/include/linux/dynamic_debug.h:5,
                 from /git/arm-soc/include/linux/printk.h:289,
                 from /git/arm-soc/include/linux/kernel.h:13,
                 from /git/arm-soc/include/linux/clk.h:16,
                 from /git/arm-soc/drivers/crypto/ux500/hash/hash_core.c:16:
/git/arm-soc/arch/arm/include/asm/jump_label.h: In function 'hash_set_dma_transfer':
/git/arm-soc/arch/arm/include/asm/jump_label.h:13:7: error: asm operand 0 probably doesn't match constraints [-Werror]
  asm_volatile_goto("1:\n\t"

Turning off compiler optimizations has never really been supported
here, and it's only used when debugging the driver. I have not found
a good reason for doing this here, other than a misguided attempt
to produce more readable assembly output. Also, the driver is only
used in obsolete hardware that almost certainly nobody will spend
time debugging any more.

This just removes the -O0 flag from the compiler options.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/ux500/cryp/Makefile | 6 +++---
 drivers/crypto/ux500/hash/Makefile | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/Makefile b/drivers/crypto/ux500/cryp/Makefile
index e5d362a6f680..b497ae3dde07 100644
--- a/drivers/crypto/ux500/cryp/Makefile
+++ b/drivers/crypto/ux500/cryp/Makefile
@@ -4,9 +4,9 @@
 # * License terms: GNU General Public License (GPL) version 2  */
 
 ifdef CONFIG_CRYPTO_DEV_UX500_DEBUG
-CFLAGS_cryp_core.o := -DDEBUG -O0
-CFLAGS_cryp.o := -DDEBUG -O0
-CFLAGS_cryp_irq.o := -DDEBUG -O0
+CFLAGS_cryp_core.o := -DDEBUG
+CFLAGS_cryp.o := -DDEBUG
+CFLAGS_cryp_irq.o := -DDEBUG
 endif
 
 obj-$(CONFIG_CRYPTO_DEV_UX500_CRYP) += ux500_cryp.o
diff --git a/drivers/crypto/ux500/hash/Makefile b/drivers/crypto/ux500/hash/Makefile
index b2f90d9bac72..784d9c0a8853 100644
--- a/drivers/crypto/ux500/hash/Makefile
+++ b/drivers/crypto/ux500/hash/Makefile
@@ -4,7 +4,7 @@
 # License terms: GNU General Public License (GPL) version 2
 #
 ifdef CONFIG_CRYPTO_DEV_UX500_DEBUG
-CFLAGS_hash_core.o := -DDEBUG -O0
+CFLAGS_hash_core.o := -DDEBUG
 endif
 
 obj-$(CONFIG_CRYPTO_DEV_UX500_HASH) += ux500_hash.o
-- 
2.9.0
