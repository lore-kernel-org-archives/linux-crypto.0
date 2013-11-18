From: Michael Neuling <mikey@neuling.org>
Subject: [PATCH] crypto: caam - Add missing Job Ring include
Date: Mon, 18 Nov 2013 15:20:01 +1100
Message-ID: <7301.1384748401@ale.ozlabs.ibm.com>
Mime-Version: 1.0
Cc: Garg Vakul-B16394 <vakul@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, sfr@canb.auug.org.au
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:34651 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab3KREUD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Nov 2013 23:20:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

linuxnext currently doesn't compile with the powerpc mpc85xx_defconfig
giving:

  drivers/crypto/caam/jr.c: In function 'caam_jr_probe':
  drivers/crypto/caam/jr.c:468:2: error: implicit declaration of function 'of_iomap' [-Werror=implicit-function-declaration]

In:
  commit 313ea293e9c4d1eabcaddd2c0800f083b03c2a2e
  Author: Ruchika Gupta <ruchika.gupta@freescale.com>
  crypto: caam - Add Platform driver for Job Ring

We added a reference to of_iomap but did add the necessary include file.

The below adds this include.

Signed-off-by: Michael Neuling <mikey@neuling.org>

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index d23356d2..1d80bd3 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/of_irq.h>
+#include <linux/of_address.h>
 
 #include "compat.h"
 #include "regs.h"
