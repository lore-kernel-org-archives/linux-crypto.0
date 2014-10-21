From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [cryptodev PATCH] qat: misspelling typo - "reseting" should be
	"resetting"
Date: Tue, 21 Oct 2014 16:09:56 -0700
Message-ID: <20141021230956.13965.60435.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29364 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbaJUXKG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Oct 2014 19:10:06 -0400
Received: from gitlad.jf.intel.com (gitlad.jf.intel.com [127.0.0.1])
	by gitlad.jf.intel.com (8.14.2/8.14.2) with ESMTP id s9LN9ukD013994
	for <linux-crypto@vger.kernel.org>; Tue, 21 Oct 2014 16:09:56 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---

 drivers/crypto/qat/qat_common/adf_aer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index c29d4c3..10ce4a2 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -90,7 +90,7 @@ static void adf_dev_restore(struct adf_accel_dev *accel_dev)
 	uint16_t ppdstat = 0, bridge_ctl = 0;
 	int pending = 0;
 
-	pr_info("QAT: Reseting device qat_dev%d\n", accel_dev->accel_id);
+	pr_info("QAT: Resetting device qat_dev%d\n", accel_dev->accel_id);
 	pci_read_config_word(pdev, PPDSTAT_OFFSET, &ppdstat);
 	pending = ppdstat & PCI_EXP_DEVSTA_TRPND;
 	if (pending) {
