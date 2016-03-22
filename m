From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Remove redundant nrbg rings
Date: Tue, 22 Mar 2016 11:25:21 -0700
Message-ID: <1458671121-23244-1-git-send-email-tadeusz.struk@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:3294 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbcCVSaS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 14:30:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ahsan Atta <ahsan.atta@intel.com>

Remove redundant nrbg rings.

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_cfg_strings.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
index 1357511..7632ed0 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_strings.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
@@ -57,10 +57,8 @@
 #define ADF_RING_DC_SIZE "NumConcurrentRequests"
 #define ADF_RING_ASYM_TX "RingAsymTx"
 #define ADF_RING_SYM_TX "RingSymTx"
-#define ADF_RING_RND_TX "RingNrbgTx"
 #define ADF_RING_ASYM_RX "RingAsymRx"
 #define ADF_RING_SYM_RX "RingSymRx"
-#define ADF_RING_RND_RX "RingNrbgRx"
 #define ADF_RING_DC_TX "RingTx"
 #define ADF_RING_DC_RX "RingRx"
 #define ADF_ETRMGR_BANK "Bank"
-- 
2.1.4
