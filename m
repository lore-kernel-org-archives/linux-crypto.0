From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] fix:caam:ctrl:add missing header dependencies
Date: Fri, 26 Aug 2016 17:56:24 +0800
Message-ID: <1472205384-29888-1-git-send-email-baoyou.xie@linaro.org>
Cc: arnd@arndb.de, baoyou.xie@linaro.org, tudor-dan.ambarus@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        xie.baoyou@zte.com.cn
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36388 "EHLO
        mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752098AbcHZJ5n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2016 05:57:43 -0400
Received: by mail-pa0-f48.google.com with SMTP id di2so25979365pad.3
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2016 02:57:43 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We get 1 warning when biuld kernel with W=1:
drivers/crypto/caam/ctrl.c:398:5: warning: no previous prototype for 'caam_get_era' [-Wmissing-prototypes]

In fact, this function is declared in drivers/crypto/caam/ctrl.h,
so this patch add missing header dependencies.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/crypto/caam/ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 0ec112e..46e72ed 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -14,6 +14,7 @@
 #include "jr.h"
 #include "desc_constr.h"
 #include "error.h"
+#include "ctrl.h"
 
 bool caam_little_end;
 EXPORT_SYMBOL(caam_little_end);
-- 
2.7.4
