Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="K5Cz+0BC"
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9E2BD;
	Tue, 12 Dec 2023 23:31:26 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BCMH45A019781;
	Tue, 12 Dec 2023 23:31:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=Wa0wpuQGXwrmJ1+dOU9+alV35zjlmfGZCbrSlux5O5w=; b=K5C
	z+0BCpqGLo7yTG3kjz/9vi04sYJDGZu+5ba2GcG1YmgGo/OEg4zfD/jbp61cjC6F
	evH4EL0APxGeNwpfexGuUoGY2kgXwJ9vCQ0+sUuVZTUWtm0GTj/wVx3ws8dvnVrz
	+vNcAPBVhuif5bi/TfYWNkD4+NfVM3jKTihSZDbeMyA0qVtTkzcJ6U+VofAu78dW
	NV7JV3mX1HyHgdvp6fRqSSRqy8mwjfJpboiXfGIEy50eycbEn3fZp+jO43dtSNvw
	3mv2bkIrqMhn113HJjfiYupqECwpRuBKVovSLfVbRLa3FWMk6e1s0rlhEP8K/6l9
	2hEVgKuqVRirumPTE5w==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3uvrmjvrjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 23:31:18 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 12 Dec
 2023 23:31:16 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 12 Dec 2023 23:31:15 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 979B63F70A4;
	Tue, 12 Dec 2023 23:31:11 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kuba@kernel.org>, <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <corbet@lwn.net>, <kalesh-anakkur.purayil@broadcom.com>,
        <horms@kernel.org>, <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <jerinj@marvell.com>, <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v3 3/9] crypto: octeontx2: add devlink option to set t106 mode
Date: Wed, 13 Dec 2023 13:00:49 +0530
Message-ID: <20231213073055.588530-4-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231213073055.588530-1-schalla@marvell.com>
References: <20231213073055.588530-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: kc5XiJmRrz5Ekll79_dHiSjrRE1uS8d5
X-Proofpoint-ORIG-GUID: kc5XiJmRrz5Ekll79_dHiSjrRE1uS8d5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

On CN10KA B0/CN10KB, CPT scatter gather format has modified
to support multi-seg in inline IPsec. Due to this CPT requires
new firmware and doesn't work with CN10KA0/A1 firmware. To make
HW works in backward compatibility mode or works with CN10KA0/A1
firmware, a bit(T106_MODE) is introduced in HW CSR.

This patch adds devlink parameter for configuring T106_MODE.
This patch also documents the devlink parameter under
Documentation/crypto/device_drivers.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 Documentation/crypto/device_drivers/index.rst |  9 ++++
 .../crypto/device_drivers/octeontx2.rst       | 25 +++++++++++
 Documentation/crypto/index.rst                |  1 +
 .../marvell/octeontx2/otx2_cpt_common.h       |  8 ++++
 .../marvell/octeontx2/otx2_cpt_devlink.c      | 44 ++++++++++++++++++-
 .../marvell/octeontx2/otx2_cptpf_main.c       |  4 +-
 6 files changed, 87 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/crypto/device_drivers/index.rst
 create mode 100644 Documentation/crypto/device_drivers/octeontx2.rst

diff --git a/Documentation/crypto/device_drivers/index.rst b/Documentation/crypto/device_drivers/index.rst
new file mode 100644
index 000000000000..c81d311ac61b
--- /dev/null
+++ b/Documentation/crypto/device_drivers/index.rst
@@ -0,0 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Hardware Device Driver Specific Documentation
+---------------------------------------------
+
+.. toctree::
+   :maxdepth: 1
+
+   octeontx2
diff --git a/Documentation/crypto/device_drivers/octeontx2.rst b/Documentation/crypto/device_drivers/octeontx2.rst
new file mode 100644
index 000000000000..7e469b173ac8
--- /dev/null
+++ b/Documentation/crypto/device_drivers/octeontx2.rst
@@ -0,0 +1,25 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+octeontx2 devlink support
+=========================
+
+This document describes the devlink features implemented by the ``octeontx2 CPT``
+device drivers.
+
+Parameters
+==========
+
+The ``octeontx2`` driver implements the following driver-specific parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``t106_mode``
+     - u8
+     - runtime
+     - Used to configure CN10KA B0/CN10KB CPT to work as CN10KA A0/A1.
diff --git a/Documentation/crypto/index.rst b/Documentation/crypto/index.rst
index da5d5ad2bdf3..945ca1505ad9 100644
--- a/Documentation/crypto/index.rst
+++ b/Documentation/crypto/index.rst
@@ -28,3 +28,4 @@ for cryptographic use cases, as well as programming examples.
    api
    api-samples
    descore-readme
+   device_drivers/index
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 284bbdef06ca..746b049c6c44 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -187,6 +187,14 @@ static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
 }
 
 
+static inline bool cpt_feature_sgv2(struct pci_dev *pdev)
+{
+	if (!is_dev_otx2(pdev) && !is_dev_cn10ka_ax(pdev))
+		return true;
+
+	return false;
+}
+
 int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
index a2aba0b0d68a..d2b8d26db968 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
@@ -23,11 +23,46 @@ static int otx2_cpt_dl_egrp_delete(struct devlink *dl, u32 id,
 
 static int otx2_cpt_dl_uc_info(struct devlink *dl, u32 id,
 			       struct devlink_param_gset_ctx *ctx)
+{
+	ctx->val.vstr[0] = '\0';
+
+	return 0;
+}
+
+static int otx2_cpt_dl_t106_mode_get(struct devlink *dl, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
 {
 	struct otx2_cpt_devlink *cpt_dl = devlink_priv(dl);
 	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
+	struct pci_dev *pdev = cptpf->pdev;
+	u64 reg_val = 0;
+
+	otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL, &reg_val,
+			     BLKADDR_CPT0);
+	ctx->val.vu8 = (reg_val >> 18) & 0x1;
+
+	return 0;
+}
 
-	otx2_cpt_print_uc_dbg_info(cptpf);
+static int otx2_cpt_dl_t106_mode_set(struct devlink *dl, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_cpt_devlink *cpt_dl = devlink_priv(dl);
+	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
+	struct pci_dev *pdev = cptpf->pdev;
+	u64 reg_val = 0;
+
+	if (cptpf->enabled_vfs != 0 || cptpf->eng_grps.is_grps_created)
+		return -EPERM;
+
+	if (cpt_feature_sgv2(pdev)) {
+		otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL,
+				     &reg_val, BLKADDR_CPT0);
+		reg_val &= ~(0x1ULL << 18);
+		reg_val |= ((u64)ctx->val.vu8 & 0x1) << 18;
+		return otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev,
+					     CPT_AF_CTL, reg_val, BLKADDR_CPT0);
+	}
 
 	return 0;
 }
@@ -36,6 +71,7 @@ enum otx2_cpt_dl_param_id {
 	OTX2_CPT_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	OTX2_CPT_DEVLINK_PARAM_ID_EGRP_CREATE,
 	OTX2_CPT_DEVLINK_PARAM_ID_EGRP_DELETE,
+	OTX2_CPT_DEVLINK_PARAM_ID_T106_MODE,
 };
 
 static const struct devlink_param otx2_cpt_dl_params[] = {
@@ -49,6 +85,11 @@ static const struct devlink_param otx2_cpt_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     otx2_cpt_dl_uc_info, otx2_cpt_dl_egrp_delete,
 			     NULL),
+	DEVLINK_PARAM_DRIVER(OTX2_CPT_DEVLINK_PARAM_ID_T106_MODE,
+			     "t106_mode", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     otx2_cpt_dl_t106_mode_get, otx2_cpt_dl_t106_mode_set,
+			     NULL),
 };
 
 static int otx2_cpt_dl_info_firmware_version_put(struct devlink_info_req *req,
@@ -120,7 +161,6 @@ int otx2_cpt_register_dl(struct otx2_cptpf_dev *cptpf)
 		devlink_free(dl);
 		return ret;
 	}
-
 	devlink_register(dl);
 
 	return 0;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 6d9ea4a7fc79..f5e1bd590d1b 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -600,10 +600,10 @@ static void cptpf_get_rid(struct pci_dev *pdev, struct otx2_cptpf_dev *cptpf)
 	}
 	otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL, &reg_val,
 			     BLKADDR_CPT0);
-	if ((is_dev_cn10ka_b0(pdev) && (reg_val & BIT_ULL(18))) ||
+	if ((cpt_feature_sgv2(pdev) && (reg_val & BIT_ULL(18))) ||
 	    is_dev_cn10ka_ax(pdev))
 		eng_grps->rid = CPT_UC_RID_CN10K_A;
-	else if (is_dev_cn10kb(pdev) || is_dev_cn10ka_b0(pdev))
+	else if (cpt_feature_sgv2(pdev))
 		eng_grps->rid = CPT_UC_RID_CN10K_B;
 }
 
-- 
2.25.1

