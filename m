From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - use pci_wait_for_pending_transaction()
Date: Fri, 09 Jan 2015 11:55:14 -0800
Message-ID: <20150109195514.28205.80714.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21248 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbbAITyr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Jan 2015 14:54:47 -0500
Received: from gitlad.jf.intel.com (gitlad.jf.intel.com [127.0.0.1])
	by gitlad.jf.intel.com (8.14.2/8.14.2) with ESMTP id t09JtEle028285
	for <linux-crypto@vger.kernel.org>; Fri, 9 Jan 2015 11:55:14 -0800
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Prior to resetting the hardware, use pci_wait_for_pending_transaction()
instead of open coding similar functionality.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 drivers/crypto/qat/qat_common/adf_aer.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 740dc9e..fa1fef8 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -82,28 +82,15 @@ struct adf_reset_dev_data {
 	struct work_struct reset_work;
 };
 
-#define PPDSTAT_OFFSET 0x7E
 static void adf_dev_restore(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
 	struct pci_dev *parent = pdev->bus->self;
-	uint16_t ppdstat = 0, bridge_ctl = 0;
-	int pending = 0;
+	uint16_t bridge_ctl = 0;
 
 	pr_info("QAT: Resetting device qat_dev%d\n", accel_dev->accel_id);
-	pci_read_config_word(pdev, PPDSTAT_OFFSET, &ppdstat);
-	pending = ppdstat & PCI_EXP_DEVSTA_TRPND;
-	if (pending) {
-		int ctr = 0;
-
-		do {
-			msleep(100);
-			pci_read_config_word(pdev, PPDSTAT_OFFSET, &ppdstat);
-			pending = ppdstat & PCI_EXP_DEVSTA_TRPND;
-		} while (pending && ctr++ < 10);
-	}
 
-	if (pending)
+	if (!pci_wait_for_pending_transaction(pdev))
 		pr_info("QAT: Transaction still in progress. Proceeding\n");
 
 	pci_read_config_word(parent, PCI_BRIDGE_CONTROL, &bridge_ctl);
