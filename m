From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - fix checkpatch CODE_INDENT issue
Date: Tue, 31 Mar 2015 09:30:55 -0700
Message-ID: <20150331163055.6379.96979.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9148 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbbCaQbA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Mar 2015 12:31:00 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t2VGUtgL006479
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2015 09:30:56 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ERROR:CODE_INDENT: code indent should use tabs where possible

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index e7af9d5..9decea2 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -236,7 +236,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	accel_dev = kzalloc_node(sizeof(*accel_dev), GFP_KERNEL,
-			         dev_to_node(&pdev->dev));
+				 dev_to_node(&pdev->dev));
 	if (!accel_dev)
 		return -ENOMEM;
 
