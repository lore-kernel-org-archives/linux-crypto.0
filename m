From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/1] crypto: s5p-sss: Fix compilation error
Date: Thu,  8 Nov 2012 11:52:00 +0530
Message-ID: <1352355720-31685-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	sachin.kamat@linaro.org, patches@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:65104 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2KHG1j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Nov 2012 01:27:39 -0500
Received: by mail-da0-f46.google.com with SMTP id n41so1044086dak.19
        for <linux-crypto@vger.kernel.org>; Wed, 07 Nov 2012 22:27:39 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

struct s3c2410_dma_client gets defined multiple times as it is defined
in more than one header file. Changing it at the header file level causes
many more build breakages as they are interdependent in a complex way.
Hence fixing this problem by using the mach version of the header file.

Without this patch, following build error is observed:
arch/arm/plat-samsung/include/plat/dma-pl330.h:106:27: error:
redefinition of struct s3c2410_dma_client

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Build tested using s5pv210_defconfig from the linux-next tree.
---
 drivers/crypto/s5p-sss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index a227144..49ad8cb 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -30,7 +30,7 @@
 #include <crypto/ctr.h>
 
 #include <plat/cpu.h>
-#include <plat/dma.h>
+#include <mach/dma.h>
 
 #define _SBF(s, v)                      ((v) << (s))
 #define _BIT(b)                         _SBF(b, 1)
-- 
1.7.4.1
