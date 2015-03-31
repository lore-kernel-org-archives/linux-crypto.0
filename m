From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - checkpatch PARENTHESIS_ALIGNMENT and
 LOGICAL_CONTINUATIONS
Date: Tue, 31 Mar 2015 09:30:35 -0700
Message-ID: <20150331163035.6379.2654.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9131 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbbCaQat (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Mar 2015 12:30:49 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t2VGUZpT006443
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2015 09:30:35 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Cleanup code to fix the subject checkpatch warnings

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/qat_crypto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index f064a9f..3bd705c 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -110,8 +110,8 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 	list_for_each(itr, adf_devmgr_get_head()) {
 		accel_dev = list_entry(itr, struct adf_accel_dev, list);
 		if ((node == dev_to_node(&GET_DEV(accel_dev)) ||
-			dev_to_node(&GET_DEV(accel_dev)) < 0)
-				&& adf_dev_started(accel_dev))
+		     dev_to_node(&GET_DEV(accel_dev)) < 0) &&
+		    adf_dev_started(accel_dev))
 			break;
 		accel_dev = NULL;
 	}
