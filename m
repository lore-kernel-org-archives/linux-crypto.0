Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79088C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 21:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55AAA2075F
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 21:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgFKVWC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 17:22:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:17090 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgFKVWB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 17:22:01 -0400
IronPort-SDR: UnM2FpNMhVttYtCsigqHtHCznY+9fMjmORQqunikhOh7DOpKvoXGe4RoCv7gvGasojxaVUMGP7
 d3ASMP7uwX/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 14:22:01 -0700
IronPort-SDR: 5Uy9dZ+uO+d4DTmIsNBiT1ApguDe3qhRyRmL8UVm29Q2OoxBjDmujaLbOXM49x++mUYlEi/jl9
 n2P8x1jJKeFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="314926391"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jun 2020 14:21:59 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/3] crypto: qat - update fw init admin msg
Date:   Thu, 11 Jun 2020 22:14:47 +0100
Message-Id: <20200611211449.76144-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611211449.76144-1-giovanni.cabiddu@intel.com>
References: <20200611211449.76144-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wojciech Ziemba <wojciech.ziemba@intel.com>

This patch tidies up the definition of init/admin request and response
messages by removing the icp_qat_fw_init_admin_resp_pars structure
and embedding it into icp_qat_fw_init_admin_resp.

Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_admin.c     |  4 +-
 .../qat/qat_common/icp_qat_fw_init_admin.h    | 75 ++++++++++++-------
 2 files changed, 52 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index e363d13dcd78..a51ba0039cff 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -152,7 +152,7 @@ static int adf_send_admin_cmd(struct adf_accel_dev *accel_dev, int cmd)
 	int i;
 
 	memset(&req, 0, sizeof(struct icp_qat_fw_init_admin_req));
-	req.init_admin_cmd_id = cmd;
+	req.cmd_id = cmd;
 
 	if (cmd == ICP_QAT_FW_CONSTANTS_CFG) {
 		req.init_cfg_sz = 1024;
@@ -161,7 +161,7 @@ static int adf_send_admin_cmd(struct adf_accel_dev *accel_dev, int cmd)
 	for (i = 0; i < hw_device->get_num_aes(hw_device); i++) {
 		memset(&resp, 0, sizeof(struct icp_qat_fw_init_admin_resp));
 		if (adf_put_admin_msg_sync(accel_dev, i, &req, &resp) ||
-		    resp.init_resp_hdr.status)
+		    resp.status)
 			return -EFAULT;
 	}
 	return 0;
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
index c867e9a0a540..d4d188cd7ed0 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
@@ -25,48 +25,73 @@ enum icp_qat_fw_init_admin_resp_status {
 struct icp_qat_fw_init_admin_req {
 	__u16 init_cfg_sz;
 	__u8 resrvd1;
-	__u8 init_admin_cmd_id;
+	__u8 cmd_id;
 	__u32 resrvd2;
 	__u64 opaque_data;
 	__u64 init_cfg_ptr;
-	__u64 resrvd3;
+
+	union {
+		struct {
+			__u16 ibuf_size_in_kb;
+			__u16 resrvd3;
+		};
+		__u32 idle_filter;
+	};
+
+	__u32 resrvd4;
 };
 
-struct icp_qat_fw_init_admin_resp_hdr {
+struct icp_qat_fw_init_admin_resp {
 	__u8 flags;
 	__u8 resrvd1;
 	__u8 status;
-	__u8 init_admin_cmd_id;
-};
-
-struct icp_qat_fw_init_admin_resp_pars {
+	__u8 cmd_id;
+	union {
+		__u32 resrvd2;
+		struct {
+			__u16 version_minor_num;
+			__u16 version_major_num;
+		};
+	};
+	__u64 opaque_data;
 	union {
-		__u32 resrvd1[ICP_QAT_FW_NUM_LONGWORDS_4];
+		__u32 resrvd3[ICP_QAT_FW_NUM_LONGWORDS_4];
 		struct {
 			__u32 version_patch_num;
 			__u8 context_id;
 			__u8 ae_id;
-			__u16 resrvd1;
-			__u64 resrvd2;
-		} s1;
+			__u16 resrvd4;
+			__u64 resrvd5;
+		};
 		struct {
 			__u64 req_rec_count;
 			__u64 resp_sent_count;
-		} s2;
-	} u;
-};
-
-struct icp_qat_fw_init_admin_resp {
-	struct icp_qat_fw_init_admin_resp_hdr init_resp_hdr;
-	union {
-		__u32 resrvd2;
+		};
 		struct {
-			__u16 version_minor_num;
-			__u16 version_major_num;
-		} s;
-	} u;
-	__u64 opaque_data;
-	struct icp_qat_fw_init_admin_resp_pars init_resp_pars;
+			__u16 compression_algos;
+			__u16 checksum_algos;
+			__u32 deflate_capabilities;
+			__u32 resrvd6;
+			__u32 lzs_capabilities;
+		};
+		struct {
+			__u32 cipher_algos;
+			__u32 hash_algos;
+			__u16 keygen_algos;
+			__u16 other;
+			__u16 public_key_algos;
+			__u16 prime_algos;
+		};
+		struct {
+			__u64 timestamp;
+			__u64 resrvd7;
+		};
+		struct {
+			__u32 successful_count;
+			__u32 unsuccessful_count;
+			__u64 resrvd8;
+		};
+	};
 };
 
 #define ICP_QAT_FW_COMN_HEARTBEAT_OK 0
-- 
2.26.2

