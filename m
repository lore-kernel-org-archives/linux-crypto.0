From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: s5p-sss: fix multiplatform build
Date: Fri, 09 May 2014 13:35:39 +0200
Message-ID: <4525493.CM3akEXMYf@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	Tomasz Figa <t.figa@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Vladimir Zapolskiy <vz@mleia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:56729 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbaEILfx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 May 2014 07:35:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As we are preparing to enable multiplatform support on EXYNOS,
we can no longer include mach/*.h or plat/*.h headers from device
drivers.

The s5p-sss driver was just enabled for EXYNOS when it used to
be used only on s5pv210, and it includes two samsung platform
specific header files for historic reasons. Fortunately, it no
longer actually needs them, so we can remove the #includes and
avoid the problem

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: <linux-samsung-soc@vger.kernel.org>
Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
Please apply on top of the other s5p-sss patches

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 47c568e..4197ad9 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -30,9 +30,6 @@
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
 
-#include <plat/cpu.h>
-#include <mach/dma.h>
-
 #define _SBF(s, v)                      ((v) << (s))
 #define _BIT(b)                         _SBF(b, 1)
 
