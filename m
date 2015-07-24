From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - remove unused define
Date: Fri, 24 Jul 2015 13:18:25 -0700
Message-ID: <20150724201825.27580.48594.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Bruce Allan <bruce.w.allan@intel.com>, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13436 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbbGXUTU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 16:19:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Bruce Allan <bruce.w.allan@intel.com>

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 1d6d289..8e711d1 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -671,7 +671,6 @@ static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
 #define ICP_DH895XCC_CAP_OFFSET     (ICP_DH895XCC_AE_OFFSET + 0x10000)
 #define LOCAL_TO_XFER_REG_OFFSET    0x800
 #define ICP_DH895XCC_EP_OFFSET      0x3a000
-#define ICP_DH895XCC_PMISC_BAR 1
 int qat_hal_init(struct adf_accel_dev *accel_dev)
 {
 	unsigned char ae;
