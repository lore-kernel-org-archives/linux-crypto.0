From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0040/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:36:27 +0800
Message-ID: <20160802103627.16439-1-baolex.ni@intel.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com, travis@sgi.com
To: herbert@gondor.apana.org.au, davem@davemloft.net, hpa@zytor.com,
	x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63632 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbcHBLSr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Aug 2016 07:18:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c727fb0..528e54e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -36,7 +36,7 @@
 #include "internal.h"
 
 static bool notests;
-module_param(notests, bool, 0644);
+module_param(notests, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(notests, "disable crypto self-tests");
 
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
-- 
2.9.2
