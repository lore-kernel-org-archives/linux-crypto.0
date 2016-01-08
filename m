From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - update init_esram for C3xxx dev type
Date: Fri,  8 Jan 2016 10:19:54 -0800
Message-ID: <1452277194-4804-1-git-send-email-tadeusz.struk@intel.com>
Cc: <tadeusz.struk@intel.com>, <pingchao.yang@intel.com>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367AbcAHSXd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jan 2016 13:23:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There is no esram on C3xxx devices so we don't need to wait for
it to initialize.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 7786e6e..daecd71 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -456,6 +456,9 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
 	unsigned int csr_val;
 	int times = 30;
 
+	if (handle->pci_dev->device == ADF_C3XXX_PCI_DEVICE_ID)
+		return 0;
+
 	csr_val = ADF_CSR_RD(csr_addr, 0);
 	if ((csr_val & ESRAM_AUTO_TINIT) && (csr_val & ESRAM_AUTO_TINIT_DONE))
 		return 0;
-- 
2.1.4
