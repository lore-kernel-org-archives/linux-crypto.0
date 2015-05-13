From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - rm unneeded header include
Date: Wed, 13 May 2015 14:45:31 -0700
Message-ID: <20150513214531.30635.73353.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32543 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbbEMVsw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2015 17:48:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Don't need proc_fs.h

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index f22ce71..5fe9029 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -48,7 +48,6 @@
 #define ADF_ACCEL_DEVICES_H_
 #include <linux/module.h>
 #include <linux/list.h>
-#include <linux/proc_fs.h>
 #include <linux/io.h>
 #include "adf_cfg_common.h"
 
