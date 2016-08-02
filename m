From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0127/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:42:42 +0800
Message-ID: <20160802104242.22217-1-baolex.ni@intel.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com, jslaby@suse.cz,
	peter@korsgaard.com, lee.jones@linaro.org
To: thomas.lendacky@amd.com, gary.hook@amd.com,
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
 drivers/crypto/ccp/ccp-crypto-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index e0380e5..34e130c 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -26,11 +26,11 @@ MODULE_VERSION("1.0.0");
 MODULE_DESCRIPTION("AMD Cryptographic Coprocessor crypto API support");
 
 static unsigned int aes_disable;
-module_param(aes_disable, uint, 0444);
+module_param(aes_disable, uint, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(aes_disable, "Disable use of AES - any non-zero value");
 
 static unsigned int sha_disable;
-module_param(sha_disable, uint, 0444);
+module_param(sha_disable, uint, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(sha_disable, "Disable use of SHA - any non-zero value");
 
 /* List heads for the supported algorithms */
-- 
2.9.2
