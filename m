From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 02/10] crypto: qat: Cleanup - checkpatch blank lines
Date: Fri, 25 Jul 2014 15:55:15 -0700
Message-ID: <20140725225515.24909.56399.stgit@gitlad.jf.intel.com>
References: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <tadeusz.struk@intel.com>, <davem@davemloft.net>,
	<bruce.w.allan@intel.com>, <bo.cui@intel.com>,
	<pingchao.yang@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51375 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaGYWzb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jul 2014 18:55:31 -0400
In-Reply-To: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix new checkpatch hits:
CHECK:LINE_SPACING: Please use a blank line after
function/struct/union/enum declarations

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 .../crypto/qat/qat_common/adf_transport_internal.h |    3 +++
 drivers/crypto/qat/qat_common/icp_qat_fw_la.h      |    1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index 4eb8969..f854bac 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -104,12 +104,15 @@ static inline int adf_bank_debugfs_add(struct adf_etr_bank_data *bank)
 {
 	return 0;
 }
+
 #define adf_bank_debugfs_rm(bank) do {} while (0)
+
 static inline int adf_ring_debugfs_add(struct adf_etr_ring_data *ring,
 				       const char *name)
 {
 	return 0;
 }
+
 #define adf_ring_debugfs_rm(ring) do {} while (0)
 #endif
 #endif
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_la.h b/drivers/crypto/qat/qat_common/icp_qat_fw_la.h
index d1d4802..c8d2669 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_la.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_la.h
@@ -358,6 +358,7 @@ struct icp_qat_fw_la_resp {
 	uint64_t opaque_data;
 	uint32_t resrvd[ICP_QAT_FW_NUM_LONGWORDS_4];
 };
+
 #define ICP_QAT_FW_CIPHER_NEXT_ID_GET(cd_ctrl_hdr_t) \
 	((((cd_ctrl_hdr_t)->next_curr_id_cipher) & \
 	  ICP_QAT_FW_COMN_NEXT_ID_MASK) >> (ICP_QAT_FW_COMN_NEXT_ID_BITPOS))
