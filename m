From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 1/5] crypto: omap-aes: change in prevention of OCP bus error
Date: Wed, 10 Nov 2010 19:26:52 +0200
Message-ID: <78e86640037f10904b37250f0c578c6e0ca2c256.1289409924.git.dmitry.kasatkin@nokia.com>
References: <y>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:20040 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259Ab0KJR1Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Nov 2010 12:27:25 -0500
In-Reply-To: <y>
In-Reply-To: <cover.1289409924.git.dmitry.kasatkin@nokia.com>
References: <cover.1289409924.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Suggested to use udelay() instead of nop as on the higher
core frequencies it might not be enough time.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-aes.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 799ca51..9d65611 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -26,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
 
@@ -187,11 +188,12 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 		omap_aes_write_mask(dd, AES_REG_MASK, AES_REG_MASK_SOFTRESET,
 					AES_REG_MASK_SOFTRESET);
 		/*
-		 * prevent OCP bus error (SRESP) in case an access to the module
-		 * is performed while the module is coming out of soft reset
+		 * prevent OCP bus error (SRESP) on OMAP3630 in case an access
+		 * to the module is performed while the module is
+		 * coming out of soft reset
 		 */
-		__asm__ __volatile__("nop");
-		__asm__ __volatile__("nop");
+		if (cpu_is_omap3630())
+			udelay(1);
 
 		err = omap_aes_wait(dd, AES_REG_SYSSTATUS,
 				AES_REG_SYSSTATUS_RESETDONE);
-- 
1.7.0.4
