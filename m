From: Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - Pack cfg ctl structs
Date: Mon, 11 Jan 2016 15:23:47 +0000
Message-ID: <1452525827-22588-1-git-send-email-ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:15961 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761009AbcAKPXu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jan 2016 10:23:50 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

	-This is required to support 32bit adf_ctl
	 utility on a 64bit driver

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/qat/qat_common/adf_cfg_user.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg_user.h b/drivers/crypto/qat/qat_common/adf_cfg_user.h
index ef5988a..b5484bf 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_user.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_user.h
@@ -58,7 +58,7 @@ struct adf_user_cfg_key_val {
 		uint64_t padding3;
 	};
 	enum adf_cfg_val_type type;
-};
+} __packed;
 
 struct adf_user_cfg_section {
 	char name[ADF_CFG_MAX_SECTION_LEN_IN_BYTES];
@@ -70,7 +70,7 @@ struct adf_user_cfg_section {
 		struct adf_user_cfg_section *next;
 		uint64_t padding3;
 	};
-};
+} __packed;
 
 struct adf_user_cfg_ctl_data {
 	union {
@@ -78,5 +78,5 @@ struct adf_user_cfg_ctl_data {
 		uint64_t padding;
 	};
 	uint8_t device_id;
-};
+} __packed;
 #endif
-- 
1.7.4.1
