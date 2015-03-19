From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - fix typo in string
Date: Thu, 19 Mar 2015 16:03:39 -0700
Message-ID: <20150319230338.2818.77026.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59087 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbbCSXEA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Mar 2015 19:04:00 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t2JN3dZS002858
	for <linux-crypto@vger.kernel.org>; Thu, 19 Mar 2015 16:03:39 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/adf_cfg_strings.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
index c7ac758..0d1a77e 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_strings.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
@@ -59,7 +59,7 @@
 #define ADF_RING_SYM_TX "RingSymTx"
 #define ADF_RING_RND_TX "RingNrbgTx"
 #define ADF_RING_ASYM_RX "RingAsymRx"
-#define ADF_RING_SYM_RX "RinSymRx"
+#define ADF_RING_SYM_RX "RingSymRx"
 #define ADF_RING_RND_RX "RingNrbgRx"
 #define ADF_RING_DC_TX "RingTx"
 #define ADF_RING_DC_RX "RingRx"
