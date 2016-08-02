From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0100/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:40:40 +0800
Message-ID: <20160802104040.20423-1-baolex.ni@intel.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	mpm@selenic.com, herbert@gondor.apana.org.au, jslaby@suse.cz,
	peter@korsgaard.com, lee.jones@linaro.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
	gregkh@linuxfoundation.org, hpa@zytor.com, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61961 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbcHBLTR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Aug 2016 07:19:17 -0400
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
 drivers/char/hw_random/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 9203f2d..09dce37 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -63,10 +63,10 @@ static u8 *rng_buffer, *rng_fillbuf;
 static unsigned short current_quality;
 static unsigned short default_quality; /* = 0; default to "off" */
 
-module_param(current_quality, ushort, 0644);
+module_param(current_quality, ushort, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(current_quality,
 		 "current hwrng entropy estimation per mill");
-module_param(default_quality, ushort, 0644);
+module_param(default_quality, ushort, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(default_quality,
 		 "default entropy content of hwrng per mill");
 
-- 
2.9.2
