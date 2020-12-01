Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6640DC64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD3320637
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgLAO0O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 09:26:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:7317 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728702AbgLAO0O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 09:26:14 -0500
IronPort-SDR: Pvg0ys1kurO9GD1EFLaqf/TtpgdjOaGOioqy1IF4JxfBtVzSLWSJoGmZgrKHFR7zNeWQXAJFKr
 FwmIC2yQWw2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="160603451"
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="160603451"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 06:24:57 -0800
IronPort-SDR: NmQ+BS67WkVM7HilVJQO4Sc0XalHAEStjJujGRlqaPbn7GG919UBWXeEWdesdptUEou7T/cgqw
 oopPPnPiq60g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="345478639"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 01 Dec 2020 06:24:56 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Tomasz Kowalik <tomaszx.kowalik@intel.com>,
        Mateusz Polrola <mateuszx.potrola@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/3] crypto: qat - add AES-CTR support for QAT GEN4 devices
Date:   Tue,  1 Dec 2020 14:24:49 +0000
Message-Id: <20201201142451.138221-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201201142451.138221-1-giovanni.cabiddu@intel.com>
References: <20201201142451.138221-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Add support for AES-CTR for QAT GEN4 devices.
Also, introduce the capability ICP_ACCEL_CAPABILITIES_AES_V2 and the
helper macro HW_CAP_AES_V2, which allow to distinguish between
different HW generations.

Co-developed-by: Tomasz Kowalik <tomaszx.kowalik@intel.com>
Signed-off-by: Tomasz Kowalik <tomaszx.kowalik@intel.com>
Co-developed-by: Mateusz Polrola <mateuszx.potrola@intel.com>
Signed-off-by: Mateusz Polrola <mateuszx.potrola@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_fw_la.h |  7 +++++++
 drivers/crypto/qat/qat_common/icp_qat_hw.h    | 17 ++++++++++++++++-
 drivers/crypto/qat/qat_common/qat_algs.c      | 17 ++++++++++++++++-
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_la.h b/drivers/crypto/qat/qat_common/icp_qat_fw_la.h
index 6757ec09d81f..28fa17f14be4 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_la.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_la.h
@@ -33,6 +33,9 @@ struct icp_qat_fw_la_bulk_req {
 	struct icp_qat_fw_comn_req_cd_ctrl cd_ctrl;
 };
 
+#define ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE 1
+#define QAT_LA_SLICE_TYPE_BITPOS 14
+#define QAT_LA_SLICE_TYPE_MASK 0x3
 #define ICP_QAT_FW_LA_GCM_IV_LEN_12_OCTETS 1
 #define ICP_QAT_FW_LA_GCM_IV_LEN_NOT_12_OCTETS 0
 #define QAT_FW_LA_ZUC_3G_PROTO_FLAG_BITPOS 12
@@ -179,6 +182,10 @@ struct icp_qat_fw_la_bulk_req {
 	QAT_FIELD_SET(flags, val, QAT_LA_PARTIAL_BITPOS, \
 	QAT_LA_PARTIAL_MASK)
 
+#define ICP_QAT_FW_LA_SLICE_TYPE_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_LA_SLICE_TYPE_BITPOS, \
+	QAT_LA_SLICE_TYPE_MASK)
+
 struct icp_qat_fw_cipher_req_hdr_cd_pars {
 	union {
 		struct {
diff --git a/drivers/crypto/qat/qat_common/icp_qat_hw.h b/drivers/crypto/qat/qat_common/icp_qat_hw.h
index 4aa5d724e11b..e39e8a2d51a7 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hw.h
@@ -65,6 +65,11 @@ struct icp_qat_hw_auth_config {
 	__u32 reserved;
 };
 
+struct icp_qat_hw_ucs_cipher_config {
+	__u32 val;
+	__u32 reserved[3];
+};
+
 enum icp_qat_slice_mask {
 	ICP_ACCEL_MASK_CIPHER_SLICE = BIT(0),
 	ICP_ACCEL_MASK_AUTH_SLICE = BIT(1),
@@ -86,6 +91,8 @@ enum icp_qat_capabilities_mask {
 	ICP_ACCEL_CAPABILITIES_RAND = BIT(7),
 	ICP_ACCEL_CAPABILITIES_ZUC = BIT(8),
 	ICP_ACCEL_CAPABILITIES_SHA3 = BIT(9),
+	/* Bits 10-25 are currently reserved */
+	ICP_ACCEL_CAPABILITIES_AES_V2 = BIT(26)
 };
 
 #define QAT_AUTH_MODE_BITPOS 4
@@ -278,7 +285,15 @@ struct icp_qat_hw_cipher_aes256_f8 {
 	__u8 key[ICP_QAT_HW_AES_256_F8_KEY_SZ];
 };
 
+struct icp_qat_hw_ucs_cipher_aes256_f8 {
+	struct icp_qat_hw_ucs_cipher_config cipher_config;
+	__u8 key[ICP_QAT_HW_AES_256_F8_KEY_SZ];
+};
+
 struct icp_qat_hw_cipher_algo_blk {
-	struct icp_qat_hw_cipher_aes256_f8 aes;
+	union {
+		struct icp_qat_hw_cipher_aes256_f8 aes;
+		struct icp_qat_hw_ucs_cipher_aes256_f8 ucs_aes;
+	};
 } __aligned(64);
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index b3a68d986417..84d1a3545c3a 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -33,6 +33,10 @@
 				       ICP_QAT_HW_CIPHER_KEY_CONVERT, \
 				       ICP_QAT_HW_CIPHER_DECRYPT)
 
+#define HW_CAP_AES_V2(accel_dev) \
+	(GET_HW_DATA(accel_dev)->accel_capabilities_mask & \
+	 ICP_ACCEL_CAPABILITIES_AES_V2)
+
 static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
@@ -416,12 +420,23 @@ static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
 	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req->cd_pars;
 	struct icp_qat_fw_comn_req_hdr *header = &req->comn_hdr;
 	struct icp_qat_fw_cipher_cd_ctrl_hdr *cd_ctrl = (void *)&req->cd_ctrl;
+	bool aes_v2_capable = HW_CAP_AES_V2(ctx->inst->accel_dev);
+	int mode = ctx->mode;
 
-	memcpy(cd->aes.key, key, keylen);
 	qat_alg_init_common_hdr(header);
 	header->service_cmd_id = ICP_QAT_FW_LA_CMD_CIPHER;
 	cd_pars->u.s.content_desc_params_sz =
 				sizeof(struct icp_qat_hw_cipher_algo_blk) >> 3;
+
+	if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
+		ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
+					     ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
+		keylen = round_up(keylen, 16);
+		memcpy(cd->ucs_aes.key, key, keylen);
+	} else {
+		memcpy(cd->aes.key, key, keylen);
+	}
+
 	/* Cipher CD config setup */
 	cd_ctrl->cipher_key_sz = keylen >> 3;
 	cd_ctrl->cipher_state_sz = AES_BLOCK_SIZE >> 3;
-- 
2.28.0

