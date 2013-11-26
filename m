From: <shh.xie@gmail.com>
Subject: [PATCH] crypto/caam/jr.c: include linux/of_address.h
Date: Tue, 26 Nov 2013 14:30:05 +0800
Message-ID: <1385447405-7784-1-git-send-email-shh.xie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>, <davem@davemloft.net>,
	Shaohui Xie <Shaohui.Xie@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:3961
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003Ab3KZHuA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Nov 2013 02:50:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Shaohui Xie <Shaohui.Xie@freescale.com>

to avoid a compile error:

drivers/crypto/caam/jr.c: In function 'caam_jr_probe':
drivers/crypto/caam/jr.c:468:2: error: implicit declaration of function
'of_iomap' [-Werror=implicit-function-declaration]
drivers/crypto/caam/jr.c:468:7: warning: assignment makes pointer from
integer without a cast [enabled by default]

Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
---
 drivers/crypto/caam/jr.c | 1 +
 1 file changed, 1 insertion(+)

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
-- 
1.8.4.1
