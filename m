From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 03/10] crypto: qat: Cleanup - remove unneeded header
Date: Fri, 25 Jul 2014 15:55:21 -0700
Message-ID: <20140725225521.24909.63745.stgit@gitlad.jf.intel.com>
References: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <tadeusz.struk@intel.com>, <davem@davemloft.net>,
	<bruce.w.allan@intel.com>, <bo.cui@intel.com>,
	<pingchao.yang@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21655 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaGYWzg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jul 2014 18:55:36 -0400
In-Reply-To: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove include of a no longer necessary header file.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 drivers/crypto/qat/qat_common/adf_cfg.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index 4279076..aba7f1d 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -49,7 +49,6 @@
 #include <linux/list.h>
 #include <linux/seq_file.h>
 #include "adf_accel_devices.h"
-#include "adf_common_drv.h"
 #include "adf_cfg.h"
 
 static DEFINE_MUTEX(qat_cfg_read_lock);
