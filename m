From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - remove unused structure members
Date: Wed, 13 May 2015 14:45:30 -0700
Message-ID: <20150513214530.30612.5748.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25455 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbbEMVsw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2015 17:48:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Cleanup unused structure members.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_cfg_user.h |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg_user.h b/drivers/crypto/qat/qat_common/adf_cfg_user.h
index 0c38a15..ef5988a 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_user.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_user.h
@@ -54,14 +54,6 @@ struct adf_user_cfg_key_val {
 	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
 	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
 	union {
-		char *user_val_ptr;
-		uint64_t padding1;
-	};
-	union {
-		struct adf_user_cfg_key_val *prev;
-		uint64_t padding2;
-	};
-	union {
 		struct adf_user_cfg_key_val *next;
 		uint64_t padding3;
 	};
@@ -75,10 +67,6 @@ struct adf_user_cfg_section {
 		uint64_t padding1;
 	};
 	union {
-		struct adf_user_cfg_section *prev;
-		uint64_t padding2;
-	};
-	union {
 		struct adf_user_cfg_section *next;
 		uint64_t padding3;
 	};
