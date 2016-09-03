From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] crypto: caam: add missing header dependencies
Date: Sat,  3 Sep 2016 11:29:30 +0800
Message-ID: <1472873370-18589-1-git-send-email-baoyou.xie@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        horia.geanta@nxp.com, srinivas.kandagatla@linaro.org,
        alexandru.porosanu@nxp.com, arnd@arndb.de
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We get 1 warning when building kernel with W=1:
drivers/crypto/caam/ctrl.c:398:5: warning: no previous prototype for 'caam_get_era' [-Wmissing-prototypes]

In fact, this function is declared in drivers/crypto/caam/ctrl.h
and be exported, thus can be refrenced by modules, so this patch 
adds missing header dependencies.

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
