Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C226B28FFE5;
	Wed, 18 Jun 2025 11:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246273; cv=none; b=IUhjlhM7BcVauvJIjyNEMAvhzljcO6mQsVYLBTXelDu8PicAV8uQeUP7YH5vB1W9cpoguKGKe0hNfPczM9mUY9J94wqeADQYbEpkfgQ7QrRIKsDHB6IC8JCy/07wchzApeo8a1uaQ+DGlY0Ao79FJxpRcVbr/1CvOLKEwzEVktA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246273; c=relaxed/simple;
	bh=m714Gy9iEksRMEPf3x0wcbG7t4PoVB1CcRcBRodRTII=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sLMXREXIAt+jbGFkKX9DUJ3N23tg1pPJvmYD8/frxtY0h3wZExaIyVWcF3HaiWB2HrbseVhGGL0g/HJulria+Bay5JIGMvcJAHsSvb7AZDWvVAOW+Z3PF6wPCK/2+utOUOpVdUmg4CSV2+fu9ezAGPm7oJACYi/Xyi88Q6sDdMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jL8qSlap; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jL8qSlap"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I901di026159;
	Wed, 18 Jun 2025 04:30:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=L
	CXUzKDBVjcsuEKgC+cZ9zhepnxQVTPz1IctDDOt2mU=; b=jL8qSlapGR7YLLsT1
	Dd4BfT9EUFYieuih62AlDabZbIkI22pkcDTDkaf82rbT2d9PNftVc5IzciWMdYsI
	O1qWKZdH1/A1fWZQQj9fAw0gJkDByLLLTHf9sBLXPhP1S1mNiTzvvPWmMhzH9rJP
	wSnNf8rg6fDWQyqm2C7/BJA7QA1S4T+TLXagw9HnCymF/VekZ3vTdM6zHS3gSkIF
	HdgSogke3OSn6iNkA/PwIEFmnx5gGrIR9Tuj/hlghcaLuA2wZMuSrtTou/Ph56Gv
	2aNkMHmyMWO6Xj1Svms0H5SD3U+14hE12SlC5P4t5aBV9bgCv3OXMV0Vcs0vvUr/
	v6TKw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 47bj4xs8yr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:30:57 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:30:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:30:56 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 0FBF63F7058;
	Wed, 18 Jun 2025 04:30:52 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v2 04/14] octeontx2-af: Handle inbound inline ipsec config in AF
Date: Wed, 18 Jun 2025 16:59:58 +0530
Message-ID: <20250618113020.130888-5-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250618113020.130888-1-tanmay@marvell.com>
References: <20250618113020.130888-1-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ULrdHDfy c=1 sm=1 tr=0 ts=6852a371 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=96XU9uIN0XmNUpR-8MgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5NyBTYWx0ZWRfXwKGDieDfK+MT RMjY0sXT8vUJTZVB5gSO5iiJPtiDjud5Y286Wonkp2uxv4vlwMYMs1KCFBNHKozHnERJ5XHv1sL aqotrV24dytP2V97e4qRcmh4WaO0oZYos3O8YmNN0+1k3ypL68H2iNiDVeqQwab6rheGSsLsnag
 Ng9XWdR70vtjEwKYJfhselFmjEacLUfqCkzRswa0ZM9wwJKNw4ft6nd4ush6Ow57T9xXFDL00Kp cUT8vz5heYGb51iDxg5jgixcnR/OpYBkrO7xh1vJZUIcfLWBeLS7R8Y+o2Yf7PznlKgQHd0fNI1 Md40gRWUzsfg4Hf8j7rQUaKeHwITYblcT/9UTM5tlc6iT7uQQz83EUFDN+F8dsQ/RnbUsgHf0jt
 CP/F2GIdTh7rCxclPjhL4+RBdum5yBpRAb0vFs17NF0TzWQLDPYXGi+9PVtkttZHyfsnPmVe
X-Proofpoint-GUID: -xW3oz4n6Ctjv52XfpEY_AFHTXlAZjLd
X-Proofpoint-ORIG-GUID: -xW3oz4n6Ctjv52XfpEY_AFHTXlAZjLd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

From: Bharat Bhushan <bbhushan2@marvell.com>

Now CPT context flush can be handled in AF as CPT LF
can be attached to it. With that AF driver can completely
handle inbound inline ipsec configuration mailbox, so
forward this mailbox to AF driver and remove all the
related code from CPT driver.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V2:
- RCT order definition
- Squashed patch 05/15 from v1 to avoid unused function warning

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-5-tanmay@marvell.com/

 .../marvell/octeontx2/otx2_cpt_common.h       |   1 -
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |  10 -
 .../marvell/octeontx2/otx2_cptpf_main.c       |  46 ---
 .../marvell/octeontx2/otx2_cptpf_mbox.c       | 281 +-----------------
 .../net/ethernet/marvell/octeontx2/af/mbox.c  |   3 -
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  11 -
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  71 ++---
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   1 +
 8 files changed, 34 insertions(+), 390 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 89d4dfbb1e8e..f8e32e98eff8 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -32,7 +32,6 @@
 #define BAD_OTX2_CPT_ENG_TYPE OTX2_CPT_MAX_ENG_TYPES
 
 /* Take mbox id from end of CPT mbox range in AF (range 0xA00 - 0xBFF) */
-#define MBOX_MSG_RX_INLINE_IPSEC_LF_CFG 0xBFE
 #define MBOX_MSG_GET_ENG_GRP_NUM        0xBFF
 #define MBOX_MSG_GET_CAPS               0xBFD
 #define MBOX_MSG_GET_KVF_LIMITS         0xBFC
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index e5859a1e1c60..b7d1298e2b85 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -41,9 +41,6 @@ struct otx2_cptpf_dev {
 	struct work_struct	afpf_mbox_work;
 	struct workqueue_struct *afpf_mbox_wq;
 
-	struct otx2_mbox	afpf_mbox_up;
-	struct work_struct	afpf_mbox_up_work;
-
 	/* VF <=> PF mbox */
 	struct otx2_mbox	vfpf_mbox;
 	struct workqueue_struct *vfpf_mbox_wq;
@@ -56,10 +53,8 @@ struct otx2_cptpf_dev {
 	u8 pf_id;               /* RVU PF number */
 	u8 max_vfs;		/* Maximum number of VFs supported by CPT */
 	u8 enabled_vfs;		/* Number of enabled VFs */
-	u8 sso_pf_func_ovrd;	/* SSO PF_FUNC override bit */
 	u8 kvf_limits;		/* Kernel crypto limits */
 	bool has_cpt1;
-	u8 rsrc_req_blkaddr;
 
 	/* Devlink */
 	struct devlink *dl;
@@ -67,12 +62,7 @@ struct otx2_cptpf_dev {
 
 irqreturn_t otx2_cptpf_afpf_mbox_intr(int irq, void *arg);
 void otx2_cptpf_afpf_mbox_handler(struct work_struct *work);
-void otx2_cptpf_afpf_mbox_up_handler(struct work_struct *work);
 irqreturn_t otx2_cptpf_vfpf_mbox_intr(int irq, void *arg);
 void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work);
 
-int otx2_inline_cptlf_setup(struct otx2_cptpf_dev *cptpf,
-			    struct otx2_cptlfs_info *lfs, u8 egrp, int num_lfs);
-void otx2_inline_cptlf_cleanup(struct otx2_cptlfs_info *lfs);
-
 #endif /* __OTX2_CPTPF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 1bceabe5f0e2..4791cd460eaa 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -13,7 +13,6 @@
 #define OTX2_CPT_DRV_NAME    "rvu_cptpf"
 #define OTX2_CPT_DRV_STRING  "Marvell RVU CPT Physical Function Driver"
 
-#define CPT_UC_RID_CN9K_B0   1
 #define CPT_UC_RID_CN10K_A   4
 #define CPT_UC_RID_CN10K_B   5
 
@@ -477,19 +476,10 @@ static int cptpf_afpf_mbox_init(struct otx2_cptpf_dev *cptpf)
 	if (err)
 		goto error;
 
-	err = otx2_mbox_init(&cptpf->afpf_mbox_up, cptpf->afpf_mbox_base,
-			     pdev, cptpf->reg_base, MBOX_DIR_PFAF_UP, 1);
-	if (err)
-		goto mbox_cleanup;
-
 	INIT_WORK(&cptpf->afpf_mbox_work, otx2_cptpf_afpf_mbox_handler);
-	INIT_WORK(&cptpf->afpf_mbox_up_work, otx2_cptpf_afpf_mbox_up_handler);
 	mutex_init(&cptpf->lock);
-
 	return 0;
 
-mbox_cleanup:
-	otx2_mbox_destroy(&cptpf->afpf_mbox);
 error:
 	destroy_workqueue(cptpf->afpf_mbox_wq);
 	return err;
@@ -499,33 +489,6 @@ static void cptpf_afpf_mbox_destroy(struct otx2_cptpf_dev *cptpf)
 {
 	destroy_workqueue(cptpf->afpf_mbox_wq);
 	otx2_mbox_destroy(&cptpf->afpf_mbox);
-	otx2_mbox_destroy(&cptpf->afpf_mbox_up);
-}
-
-static ssize_t sso_pf_func_ovrd_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
-{
-	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%d\n", cptpf->sso_pf_func_ovrd);
-}
-
-static ssize_t sso_pf_func_ovrd_store(struct device *dev,
-				      struct device_attribute *attr,
-				      const char *buf, size_t count)
-{
-	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
-	u8 sso_pf_func_ovrd;
-
-	if (!(cptpf->pdev->revision == CPT_UC_RID_CN9K_B0))
-		return count;
-
-	if (kstrtou8(buf, 0, &sso_pf_func_ovrd))
-		return -EINVAL;
-
-	cptpf->sso_pf_func_ovrd = sso_pf_func_ovrd;
-
-	return count;
 }
 
 static ssize_t kvf_limits_show(struct device *dev,
@@ -558,11 +521,9 @@ static ssize_t kvf_limits_store(struct device *dev,
 }
 
 static DEVICE_ATTR_RW(kvf_limits);
-static DEVICE_ATTR_RW(sso_pf_func_ovrd);
 
 static struct attribute *cptpf_attrs[] = {
 	&dev_attr_kvf_limits.attr,
-	&dev_attr_sso_pf_func_ovrd.attr,
 	NULL
 };
 
@@ -841,13 +802,6 @@ static void otx2_cptpf_remove(struct pci_dev *pdev)
 	cptpf_sriov_disable(pdev);
 	otx2_cpt_unregister_dl(cptpf);
 
-	/* Cleanup Inline CPT LF's if attached */
-	if (cptpf->lfs.lfs_num)
-		otx2_inline_cptlf_cleanup(&cptpf->lfs);
-
-	if (cptpf->cpt1_lfs.lfs_num)
-		otx2_inline_cptlf_cleanup(&cptpf->cpt1_lfs);
-
 	/* Delete sysfs entry created for kernel VF limits */
 	sysfs_remove_group(&pdev->dev.kobj, &cptpf_sysfs_group);
 	/* Cleanup engine groups */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index 3ff3a49bd82b..326f5c802242 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -5,20 +5,6 @@
 #include "otx2_cptpf.h"
 #include "rvu_reg.h"
 
-/* Fastpath ipsec opcode with inplace processing */
-#define CPT_INLINE_RX_OPCODE (0x26 | (1 << 6))
-#define CN10K_CPT_INLINE_RX_OPCODE (0x29 | (1 << 6))
-
-#define cpt_inline_rx_opcode(pdev)                      \
-({                                                      \
-	u8 opcode;                                      \
-	if (is_dev_otx2(pdev))                          \
-		opcode = CPT_INLINE_RX_OPCODE;          \
-	else                                            \
-		opcode = CN10K_CPT_INLINE_RX_OPCODE;    \
-	(opcode);                                       \
-})
-
 /*
  * CPT PF driver version, It will be incremented by 1 for every feature
  * addition in CPT mailbox messages.
@@ -126,182 +112,6 @@ static int handle_msg_kvf_limits(struct otx2_cptpf_dev *cptpf,
 	return 0;
 }
 
-static int send_inline_ipsec_inbound_msg(struct otx2_cptpf_dev *cptpf,
-					 int sso_pf_func, u8 slot)
-{
-	struct cpt_inline_ipsec_cfg_msg *req;
-	struct pci_dev *pdev = cptpf->pdev;
-
-	req = (struct cpt_inline_ipsec_cfg_msg *)
-	      otx2_mbox_alloc_msg_rsp(&cptpf->afpf_mbox, 0,
-				      sizeof(*req), sizeof(struct msg_rsp));
-	if (req == NULL) {
-		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
-		return -EFAULT;
-	}
-	memset(req, 0, sizeof(*req));
-	req->hdr.id = MBOX_MSG_CPT_INLINE_IPSEC_CFG;
-	req->hdr.sig = OTX2_MBOX_REQ_SIG;
-	req->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(cptpf->pdev, cptpf->pf_id, 0);
-	req->dir = CPT_INLINE_INBOUND;
-	req->slot = slot;
-	req->sso_pf_func_ovrd = cptpf->sso_pf_func_ovrd;
-	req->sso_pf_func = sso_pf_func;
-	req->enable = 1;
-
-	return otx2_cpt_send_mbox_msg(&cptpf->afpf_mbox, pdev);
-}
-
-static int rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf, u8 egrp,
-				  struct otx2_cpt_rx_inline_lf_cfg *req)
-{
-	struct nix_inline_ipsec_cfg *nix_req;
-	struct pci_dev *pdev = cptpf->pdev;
-	int ret;
-
-	nix_req = (struct nix_inline_ipsec_cfg *)
-		   otx2_mbox_alloc_msg_rsp(&cptpf->afpf_mbox, 0,
-					   sizeof(*nix_req),
-					   sizeof(struct msg_rsp));
-	if (nix_req == NULL) {
-		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
-		return -EFAULT;
-	}
-	memset(nix_req, 0, sizeof(*nix_req));
-	nix_req->hdr.id = MBOX_MSG_NIX_INLINE_IPSEC_CFG;
-	nix_req->hdr.sig = OTX2_MBOX_REQ_SIG;
-	nix_req->enable = 1;
-	nix_req->credit_th = req->credit_th;
-	nix_req->bpid = req->bpid;
-	if (!req->credit || req->credit > OTX2_CPT_INST_QLEN_MSGS)
-		nix_req->cpt_credit = OTX2_CPT_INST_QLEN_MSGS - 1;
-	else
-		nix_req->cpt_credit = req->credit - 1;
-	nix_req->gen_cfg.egrp = egrp;
-	if (req->opcode)
-		nix_req->gen_cfg.opcode = req->opcode;
-	else
-		nix_req->gen_cfg.opcode = cpt_inline_rx_opcode(pdev);
-	nix_req->gen_cfg.param1 = req->param1;
-	nix_req->gen_cfg.param2 = req->param2;
-	nix_req->inst_qsel.cpt_pf_func =
-		OTX2_CPT_RVU_PFFUNC(cptpf->pdev, cptpf->pf_id, 0);
-	nix_req->inst_qsel.cpt_slot = 0;
-	ret = otx2_cpt_send_mbox_msg(&cptpf->afpf_mbox, pdev);
-	if (ret)
-		return ret;
-
-	if (cptpf->has_cpt1) {
-		ret = send_inline_ipsec_inbound_msg(cptpf, req->sso_pf_func, 1);
-		if (ret)
-			return ret;
-	}
-
-	return send_inline_ipsec_inbound_msg(cptpf, req->sso_pf_func, 0);
-}
-
-int
-otx2_inline_cptlf_setup(struct otx2_cptpf_dev *cptpf,
-			struct otx2_cptlfs_info *lfs, u8 egrp, int num_lfs)
-{
-	int ret;
-
-	ret = otx2_cptlf_init(lfs, 1 << egrp, OTX2_CPT_QUEUE_HI_PRIO, 1);
-	if (ret) {
-		dev_err(&cptpf->pdev->dev,
-			"LF configuration failed for RX inline ipsec.\n");
-		return ret;
-	}
-
-	/* Get msix offsets for attached LFs */
-	ret = otx2_cpt_msix_offset_msg(lfs);
-	if (ret)
-		goto cleanup_lf;
-
-	/* Register for CPT LF Misc interrupts */
-	ret = otx2_cptlf_register_misc_interrupts(lfs);
-	if (ret)
-		goto free_irq;
-
-	return 0;
-free_irq:
-	otx2_cptlf_unregister_misc_interrupts(lfs);
-cleanup_lf:
-	otx2_cptlf_shutdown(lfs);
-	return ret;
-}
-
-void
-otx2_inline_cptlf_cleanup(struct otx2_cptlfs_info *lfs)
-{
-	/* Unregister misc interrupt */
-	otx2_cptlf_unregister_misc_interrupts(lfs);
-
-	/* Cleanup LFs */
-	otx2_cptlf_shutdown(lfs);
-}
-
-static int handle_msg_rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf,
-					     struct mbox_msghdr *req)
-{
-	struct otx2_cpt_rx_inline_lf_cfg *cfg_req;
-	int num_lfs = 1, ret;
-	u8 egrp;
-
-	cfg_req = (struct otx2_cpt_rx_inline_lf_cfg *)req;
-	if (cptpf->lfs.lfs_num) {
-		dev_err(&cptpf->pdev->dev,
-			"LF is already configured for RX inline ipsec.\n");
-		return -EEXIST;
-	}
-	/*
-	 * Allow LFs to execute requests destined to only grp IE_TYPES and
-	 * set queue priority of each LF to high
-	 */
-	egrp = otx2_cpt_get_eng_grp(&cptpf->eng_grps, OTX2_CPT_IE_TYPES);
-	if (egrp == OTX2_CPT_INVALID_CRYPTO_ENG_GRP) {
-		dev_err(&cptpf->pdev->dev,
-			"Engine group for inline ipsec is not available\n");
-		return -ENOENT;
-	}
-
-	cptpf->lfs.global_slot = 0;
-	cptpf->lfs.ctx_ilen_ovrd = cfg_req->ctx_ilen_valid;
-	cptpf->lfs.ctx_ilen = cfg_req->ctx_ilen;
-
-	ret = otx2_inline_cptlf_setup(cptpf, &cptpf->lfs, egrp, num_lfs);
-	if (ret) {
-		dev_err(&cptpf->pdev->dev, "Inline-Ipsec CPT0 LF setup failed.\n");
-		return ret;
-	}
-
-	if (cptpf->has_cpt1) {
-		cptpf->rsrc_req_blkaddr = BLKADDR_CPT1;
-		cptpf->cpt1_lfs.global_slot = num_lfs;
-		cptpf->cpt1_lfs.ctx_ilen_ovrd = cfg_req->ctx_ilen_valid;
-		cptpf->cpt1_lfs.ctx_ilen = cfg_req->ctx_ilen;
-		ret = otx2_inline_cptlf_setup(cptpf, &cptpf->cpt1_lfs, egrp,
-					      num_lfs);
-		if (ret) {
-			dev_err(&cptpf->pdev->dev, "Inline CPT1 LF setup failed.\n");
-			goto lf_cleanup;
-		}
-		cptpf->rsrc_req_blkaddr = 0;
-	}
-
-	ret = rx_inline_ipsec_lf_cfg(cptpf, egrp, cfg_req);
-	if (ret)
-		goto lf1_cleanup;
-
-	return 0;
-
-lf1_cleanup:
-	otx2_inline_cptlf_cleanup(&cptpf->cpt1_lfs);
-lf_cleanup:
-	otx2_inline_cptlf_cleanup(&cptpf->lfs);
-	return ret;
-}
-
 static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
 			       struct otx2_cptvf_info *vf,
 			       struct mbox_msghdr *req, int size)
@@ -322,9 +132,6 @@ static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
 	case MBOX_MSG_GET_KVF_LIMITS:
 		err = handle_msg_kvf_limits(cptpf, vf, req);
 		break;
-	case MBOX_MSG_RX_INLINE_IPSEC_LF_CFG:
-		err = handle_msg_rx_inline_ipsec_lf_cfg(cptpf, req);
-		break;
 
 	default:
 		err = forward_to_af(cptpf, vf, req, size);
@@ -417,28 +224,14 @@ void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work)
 irqreturn_t otx2_cptpf_afpf_mbox_intr(int __always_unused irq, void *arg)
 {
 	struct otx2_cptpf_dev *cptpf = arg;
-	struct otx2_mbox_dev *mdev;
-	struct otx2_mbox *mbox;
-	struct mbox_hdr *hdr;
 	u64 intr;
 
 	/* Read the interrupt bits */
 	intr = otx2_cpt_read64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT);
 
 	if (intr & 0x1ULL) {
-		mbox = &cptpf->afpf_mbox;
-		mdev = &mbox->dev[0];
-		hdr = mdev->mbase + mbox->rx_start;
-		if (hdr->num_msgs)
-			/* Schedule work queue function to process the MBOX request */
-			queue_work(cptpf->afpf_mbox_wq, &cptpf->afpf_mbox_work);
-
-		mbox = &cptpf->afpf_mbox_up;
-		mdev = &mbox->dev[0];
-		hdr = mdev->mbase + mbox->rx_start;
-		if (hdr->num_msgs)
-			/* Schedule work queue function to process the MBOX request */
-			queue_work(cptpf->afpf_mbox_wq, &cptpf->afpf_mbox_up_work);
+		/* Schedule work queue function to process the MBOX request */
+		queue_work(cptpf->afpf_mbox_wq, &cptpf->afpf_mbox_work);
 		/* Clear and ack the interrupt */
 		otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT,
 				 0x1ULL);
@@ -464,8 +257,6 @@ static void process_afpf_mbox_msg(struct otx2_cptpf_dev *cptpf,
 			msg->sig, msg->id);
 		return;
 	}
-	if (cptpf->rsrc_req_blkaddr == BLKADDR_CPT1)
-		lfs = &cptpf->cpt1_lfs;
 
 	switch (msg->id) {
 	case MBOX_MSG_READY:
@@ -592,71 +383,3 @@ void otx2_cptpf_afpf_mbox_handler(struct work_struct *work)
 	}
 	otx2_mbox_reset(afpf_mbox, 0);
 }
-
-static void handle_msg_cpt_inst_lmtst(struct otx2_cptpf_dev *cptpf,
-				      struct mbox_msghdr *msg)
-{
-	struct cpt_inst_lmtst_req *req = (struct cpt_inst_lmtst_req *)msg;
-	struct otx2_cptlfs_info *lfs = &cptpf->lfs;
-	struct msg_rsp *rsp;
-
-	if (cptpf->lfs.lfs_num)
-		lfs->ops->send_cmd((union otx2_cpt_inst_s *)req->inst, 1,
-				   &lfs->lf[0]);
-
-	rsp = (struct msg_rsp *)otx2_mbox_alloc_msg(&cptpf->afpf_mbox_up, 0,
-						    sizeof(*rsp));
-	if (!rsp)
-		return;
-
-	rsp->hdr.id = msg->id;
-	rsp->hdr.sig = OTX2_MBOX_RSP_SIG;
-	rsp->hdr.pcifunc = 0;
-	rsp->hdr.rc = 0;
-}
-
-static void process_afpf_mbox_up_msg(struct otx2_cptpf_dev *cptpf,
-				     struct mbox_msghdr *msg)
-{
-	if (msg->id >= MBOX_MSG_MAX) {
-		dev_err(&cptpf->pdev->dev,
-			"MBOX msg with unknown ID %d\n", msg->id);
-		return;
-	}
-
-	switch (msg->id) {
-	case MBOX_MSG_CPT_INST_LMTST:
-		handle_msg_cpt_inst_lmtst(cptpf, msg);
-		break;
-	default:
-		otx2_reply_invalid_msg(&cptpf->afpf_mbox_up, 0, 0, msg->id);
-	}
-}
-
-void otx2_cptpf_afpf_mbox_up_handler(struct work_struct *work)
-{
-	struct otx2_cptpf_dev *cptpf;
-	struct otx2_mbox_dev *mdev;
-	struct mbox_hdr *rsp_hdr;
-	struct mbox_msghdr *msg;
-	struct otx2_mbox *mbox;
-	int offset, i;
-
-	cptpf = container_of(work, struct otx2_cptpf_dev, afpf_mbox_up_work);
-	mbox = &cptpf->afpf_mbox_up;
-	mdev = &mbox->dev[0];
-	/* Sync mbox data into memory */
-	smp_wmb();
-
-	rsp_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
-	offset = mbox->rx_start + ALIGN(sizeof(*rsp_hdr), MBOX_MSG_ALIGN);
-
-	for (i = 0; i < rsp_hdr->num_msgs; i++) {
-		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
-
-		process_afpf_mbox_up_msg(cptpf, msg);
-
-		offset = mbox->rx_start + msg->next_msgoff;
-	}
-	otx2_mbox_msg_send(mbox, 0);
-}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
index 75872d257eca..861025bb93c6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
@@ -555,9 +555,6 @@ const char *otx2_mbox_id2name(u16 id)
 	MBOX_UP_CGX_MESSAGES
 #undef M
 
-#define M(_name, _id, _1, _2, _3) case _id: return # _name;
-	MBOX_UP_CPT_MESSAGES
-#undef M
 	default:
 		return "INVALID ID";
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 0b488af118cc..dafba59564d8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -394,9 +394,6 @@ M(MCS_CUSTOM_TAG_CFG_GET, 0xa021, mcs_custom_tag_cfg_get,			\
 #define MBOX_UP_CGX_MESSAGES						\
 M(CGX_LINK_EVENT,	0xC00, cgx_link_event, cgx_link_info_msg, msg_rsp)
 
-#define MBOX_UP_CPT_MESSAGES						\
-M(CPT_INST_LMTST,	0xD00, cpt_inst_lmtst, cpt_inst_lmtst_req, msg_rsp)
-
 #define MBOX_UP_MCS_MESSAGES						\
 M(MCS_INTR_NOTIFY,	0xE00, mcs_intr_notify, mcs_intr_info, msg_rsp)
 
@@ -407,7 +404,6 @@ enum {
 #define M(_name, _id, _1, _2, _3) MBOX_MSG_ ## _name = _id,
 MBOX_MESSAGES
 MBOX_UP_CGX_MESSAGES
-MBOX_UP_CPT_MESSAGES
 MBOX_UP_MCS_MESSAGES
 MBOX_UP_REP_MESSAGES
 #undef M
@@ -1925,13 +1921,6 @@ struct cpt_rxc_time_cfg_req {
 	u16 active_limit;
 };
 
-/* Mailbox message request format to request for CPT_INST_S lmtst. */
-struct cpt_inst_lmtst_req {
-	struct mbox_msghdr hdr;
-	u64 inst[8];
-	u64 rsvd;
-};
-
 /* Mailbox message format to request for CPT LF reset */
 struct cpt_lf_rst_req {
 	struct mbox_msghdr hdr;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 154c13dec3ad..bf2cb3aa8eec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -12,6 +12,7 @@
 #include "mbox.h"
 #include "rvu.h"
 #include "rvu_cpt.h"
+#include <linux/soc/marvell/octeontx2/asm.h>
 
 /* CPT PF device id */
 #define	PCI_DEVID_OTX2_CPT_PF	0xA0FD
@@ -26,6 +27,10 @@
 /* Default CPT_AF_RXC_CFG1:max_rxc_icb_cnt */
 #define CPT_DFLT_MAX_RXC_ICB_CNT  0xC0ULL
 
+/* CPT LMTST */
+#define LMT_LINE_SIZE   128 /* LMT line size in bytes */
+#define LMT_BURST_SIZE  32  /* 32 LMTST lines for burst */
+
 #define cpt_get_eng_sts(e_min, e_max, rsp, etype)                   \
 ({                                                                  \
 	u64 free_sts = 0, busy_sts = 0;                             \
@@ -699,10 +704,6 @@ int rvu_mbox_handler_cpt_inline_ipsec_cfg(struct rvu *rvu,
 		return CPT_AF_ERR_LF_INVALID;
 
 	switch (req->dir) {
-	case CPT_INLINE_INBOUND:
-		ret = cpt_inline_ipsec_cfg_inbound(rvu, blkaddr, cptlf, req);
-		break;
-
 	case CPT_INLINE_OUTBOUND:
 		ret = cpt_inline_ipsec_cfg_outbound(rvu, blkaddr, cptlf, req);
 		break;
@@ -1253,20 +1254,36 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf, int s
 	return 0;
 }
 
+static void cn10k_cpt_inst_flush(struct rvu *rvu, u64 *inst, u64 size)
+{
+	u64 blkaddr = BLKADDR_CPT0;
+	u64 val = 0, tar_addr = 0;
+	void __iomem *io_addr;
+
+	io_addr	= rvu->pfreg_base + CPT_RVU_FUNC_ADDR_S(blkaddr, 0, CPT_LF_NQX);
+
+	/* Target address for LMTST flush tells HW how many 128bit
+	 * words are present.
+	 * tar_addr[6:4] size of first LMTST - 1 in units of 128b.
+	 */
+	tar_addr |= (__force u64)io_addr | (((size / 16) - 1) & 0x7) << 4;
+	dma_wmb();
+	memcpy((u64 *)rvu->rvu_cpt.lmt_addr, inst, size);
+	cn10k_lmt_flush(val, tar_addr);
+	dma_wmb();
+}
+
 #define CPT_RES_LEN    16
 #define CPT_SE_IE_EGRP 1ULL
 
 static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
 				      int nix_blkaddr)
 {
-	int cpt_pf_num = rvu->cpt_pf_num;
-	struct cpt_inst_lmtst_req *req;
 	dma_addr_t res_daddr;
 	int timeout = 3000;
+	u64 inst[8];
 	u8 cpt_idx;
-	u64 *inst;
 	u16 *res;
-	int rc;
 
 	res = kzalloc(CPT_RES_LEN, GFP_KERNEL);
 	if (!res)
@@ -1276,24 +1293,11 @@ static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
 				   DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(rvu->dev, res_daddr)) {
 		dev_err(rvu->dev, "DMA mapping failed for CPT result\n");
-		rc = -EFAULT;
-		goto res_free;
+		kfree(res);
+		return -EFAULT;
 	}
 	*res = 0xFFFF;
 
-	/* Send mbox message to CPT PF */
-	req = (struct cpt_inst_lmtst_req *)
-	       otx2_mbox_alloc_msg_rsp(&rvu->afpf_wq_info.mbox_up,
-				       cpt_pf_num, sizeof(*req),
-				       sizeof(struct msg_rsp));
-	if (!req) {
-		rc = -ENOMEM;
-		goto res_daddr_unmap;
-	}
-	req->hdr.sig = OTX2_MBOX_REQ_SIG;
-	req->hdr.id = MBOX_MSG_CPT_INST_LMTST;
-
-	inst = req->inst;
 	/* Prepare CPT_INST_S */
 	inst[0] = 0;
 	inst[1] = res_daddr;
@@ -1314,11 +1318,8 @@ static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
 	rvu_write64(rvu, nix_blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx),
 		    BIT_ULL(22) - 1);
 
-	otx2_mbox_msg_send(&rvu->afpf_wq_info.mbox_up, cpt_pf_num);
-	rc = otx2_mbox_wait_for_rsp(&rvu->afpf_wq_info.mbox_up, cpt_pf_num);
-	if (rc)
-		dev_warn(rvu->dev, "notification to pf %d failed\n",
-			 cpt_pf_num);
+	cn10k_cpt_inst_flush(rvu, inst, 64);
+
 	/* Wait for CPT instruction to be completed */
 	do {
 		mdelay(1);
@@ -1331,11 +1332,8 @@ static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
 	if (timeout == 0)
 		dev_warn(rvu->dev, "Poll for result hits hard loop counter\n");
 
-res_daddr_unmap:
 	dma_unmap_single(rvu->dev, res_daddr, CPT_RES_LEN, DMA_BIDIRECTIONAL);
-res_free:
 	kfree(res);
-
 	return 0;
 }
 
@@ -1381,23 +1379,16 @@ int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc)
 		goto unlock;
 	}
 
-	/* Enable BAR2 ALIAS for this pcifunc. */
-	reg = BIT_ULL(16) | pcifunc;
-	rvu_bar2_sel_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
-
 	for (i = 0; i < max_ctx_entries; i++) {
 		cam_data = rvu_read64(rvu, blkaddr, CPT_AF_CTX_CAM_DATA(i));
 
 		if ((FIELD_GET(CTX_CAM_PF_FUNC, cam_data) == pcifunc) &&
 		    FIELD_GET(CTX_CAM_CPTR, cam_data)) {
 			reg = BIT_ULL(46) | FIELD_GET(CTX_CAM_CPTR, cam_data);
-			rvu_write64(rvu, blkaddr,
-				    CPT_AF_BAR2_ALIASX(slot, CPT_LF_CTX_FLUSH),
-				    reg);
+			otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot,
+					 CPT_LF_CTX_FLUSH, reg);
 		}
 	}
-	rvu_bar2_sel_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, 0);
-
 unlock:
 	mutex_unlock(&rvu->rsrc_lock);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index d92c154b08cf..b24d9e7c8df4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -581,6 +581,7 @@
 #define CPT_LF_Q_SIZE                   0x100
 #define CPT_LF_Q_INST_PTR               0x110
 #define CPT_LF_Q_GRP_PTR                0x120
+#define CPT_LF_NQX                      0x400
 #define CPT_LF_CTX_FLUSH                0x510
 
 #define NPC_AF_BLK_RST                  (0x00040)
-- 
2.43.0

