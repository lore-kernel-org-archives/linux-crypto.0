From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - fix checkpatch CONCATENATED_STRING issues
Date: Tue, 31 Mar 2015 09:30:40 -0700
Message-ID: <20150331163040.6379.89228.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:5139 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbbCaQal (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Mar 2015 12:30:41 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t2VGUetO006452
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2015 09:30:40 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CHECK:CONCATENATED_STRING: Concatenated strings should use spaces between
elements

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/adf_cfg_strings.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
index 0d1a77e..1357511 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_strings.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
@@ -69,15 +69,15 @@
 #define ADF_DC "Dc"
 #define ADF_ETRMGR_COALESCING_ENABLED "InterruptCoalescingEnabled"
 #define ADF_ETRMGR_COALESCING_ENABLED_FORMAT \
-	ADF_ETRMGR_BANK"%d"ADF_ETRMGR_COALESCING_ENABLED
+	ADF_ETRMGR_BANK "%d" ADF_ETRMGR_COALESCING_ENABLED
 #define ADF_ETRMGR_COALESCE_TIMER "InterruptCoalescingTimerNs"
 #define ADF_ETRMGR_COALESCE_TIMER_FORMAT \
-	ADF_ETRMGR_BANK"%d"ADF_ETRMGR_COALESCE_TIMER
+	ADF_ETRMGR_BANK "%d" ADF_ETRMGR_COALESCE_TIMER
 #define ADF_ETRMGR_COALESCING_MSG_ENABLED "InterruptCoalescingNumResponses"
 #define ADF_ETRMGR_COALESCING_MSG_ENABLED_FORMAT \
-	ADF_ETRMGR_BANK"%d"ADF_ETRMGR_COALESCING_MSG_ENABLED
+	ADF_ETRMGR_BANK "%d" ADF_ETRMGR_COALESCING_MSG_ENABLED
 #define ADF_ETRMGR_CORE_AFFINITY "CoreAffinity"
 #define ADF_ETRMGR_CORE_AFFINITY_FORMAT \
-	ADF_ETRMGR_BANK"%d"ADF_ETRMGR_CORE_AFFINITY
+	ADF_ETRMGR_BANK "%d" ADF_ETRMGR_CORE_AFFINITY
 #define ADF_ACCEL_STR "Accelerator%d"
 #endif
