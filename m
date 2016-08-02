From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0128/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:42:47 +0800
Message-ID: <20160802104247.22284-1-baolex.ni@intel.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com, jslaby@suse.cz,
	peter@korsgaard.com, lee.jones@linaro.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, hpa@zytor.com,
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
 drivers/crypto/hifn_795x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index eee2c7e..dfcaa29 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -33,7 +33,7 @@
 #include <crypto/des.h>
 
 static char hifn_pll_ref[sizeof("extNNN")] = "ext";
-module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), 0444);
+module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(hifn_pll_ref,
 		 "PLL reference clock (pci[freq] or ext[freq], default ext)");
 
-- 
2.9.2
