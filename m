From: Yang Pingchao <pingchao.yang@intel.com>
Subject: [PATCH] crypto: qat - Change the definition of icp_qat_uof_regtype
Date: Thu,  3 Mar 2016 02:46:45 -0500
Message-ID: <1456991205-34197-1-git-send-email-pingchao.yang@intel.com>
Cc: <tadeusz.struk@intel.com>, <linux-crypto@vger.kernel.org>,
	Yang Pingchao <pingchao.yang@intel.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbcCCHth (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Mar 2016 02:49:37 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 The definition of icp_qat_uof_regtype should be coherent with
 the definition in firmware compiler.

Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_uclo.h | 42 ++++++++++++++--------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
index d97db99..5d1ee7e 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
@@ -112,27 +112,27 @@ enum icp_qat_uof_mem_region {
 };
 
 enum icp_qat_uof_regtype {
-	ICP_NO_DEST,
-	ICP_GPA_REL,
-	ICP_GPA_ABS,
-	ICP_GPB_REL,
-	ICP_GPB_ABS,
-	ICP_SR_REL,
-	ICP_SR_RD_REL,
-	ICP_SR_WR_REL,
-	ICP_SR_ABS,
-	ICP_SR_RD_ABS,
-	ICP_SR_WR_ABS,
-	ICP_DR_REL,
-	ICP_DR_RD_REL,
-	ICP_DR_WR_REL,
-	ICP_DR_ABS,
-	ICP_DR_RD_ABS,
-	ICP_DR_WR_ABS,
-	ICP_LMEM,
-	ICP_LMEM0,
-	ICP_LMEM1,
-	ICP_NEIGH_REL,
+	ICP_NO_DEST	= 0,
+	ICP_GPA_REL	= 1,
+	ICP_GPA_ABS	= 2,
+	ICP_GPB_REL	= 3,
+	ICP_GPB_ABS	= 4,
+	ICP_SR_REL	= 5,
+	ICP_SR_RD_REL	= 6,
+	ICP_SR_WR_REL	= 7,
+	ICP_SR_ABS	= 8,
+	ICP_SR_RD_ABS	= 9,
+	ICP_SR_WR_ABS	= 10,
+	ICP_DR_REL	= 19,
+	ICP_DR_RD_REL	= 20,
+	ICP_DR_WR_REL	= 21,
+	ICP_DR_ABS	= 22,
+	ICP_DR_RD_ABS	= 23,
+	ICP_DR_WR_ABS	= 24,
+	ICP_LMEM	= 26,
+	ICP_LMEM0	= 27,
+	ICP_LMEM1	= 28,
+	ICP_NEIGH_REL	= 31,
 };
 
 enum icp_qat_css_fwtype {
-- 
2.4.3
