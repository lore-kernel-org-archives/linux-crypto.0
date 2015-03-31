From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - fix checkpatch CHECK_SPACING issues
Date: Tue, 31 Mar 2015 09:30:29 -0700
Message-ID: <20150331163029.6379.84969.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60438 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbbCaQaf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Mar 2015 12:30:35 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t2VGUTdD006434
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2015 09:30:29 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_hw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_hw.h b/drivers/crypto/qat/qat_common/icp_qat_hw.h
index 68f191b..121d5e6 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hw.h
@@ -145,7 +145,7 @@ struct icp_qat_hw_auth_setup {
 };
 
 #define QAT_HW_DEFAULT_ALIGNMENT 8
-#define QAT_HW_ROUND_UP(val, n) (((val) + ((n)-1)) & (~(n-1)))
+#define QAT_HW_ROUND_UP(val, n) (((val) + ((n) - 1)) & (~(n - 1)))
 #define ICP_QAT_HW_NULL_STATE1_SZ 32
 #define ICP_QAT_HW_MD5_STATE1_SZ 16
 #define ICP_QAT_HW_SHA1_STATE1_SZ 20
