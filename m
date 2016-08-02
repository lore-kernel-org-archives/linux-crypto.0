From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0129/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:42:52 +0800
Message-ID: <20160802104252.22350-1-baolex.ni@intel.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com, jslaby@suse.cz,
	peter@korsgaard.com, lee.jones@linaro.org
To: boris.brezillon@free-electrons.com, arno@natisbad.org,
	herbert@gondor.apana.org.au, davem@davemloft.net, hpa@zytor.com,
	x86@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/crypto/marvell/cesa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index e8ef9fd..5edbcc4 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -32,7 +32,7 @@
 #include "cesa.h"
 
 static int allhwsupport = !IS_ENABLED(CONFIG_CRYPTO_DEV_MV_CESA);
-module_param_named(allhwsupport, allhwsupport, int, 0444);
+module_param_named(allhwsupport, allhwsupport, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(allhwsupport, "Enable support for all hardware (even it if overlaps with the mv_cesa driver)");
 
 struct mv_cesa_dev *cesa_dev;
-- 
2.9.2
