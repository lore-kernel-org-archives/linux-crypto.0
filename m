Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0875246765;
	Fri,  2 May 2025 13:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192151; cv=none; b=LL6zgwSPrvTOSk2Nsz3UXn/h052kEEZklUtVr9O2MpLMrs6n/OYNy/v6b+ZzdhQ16cChZYOpj2Y64Ws4T/qEPqBZPkQjnUMsv85vnm0eUAbzGljHh66CmNUJHw9pEPJZH6rnEpsPMD7Vm1qvRk2gQjSKkE4c+oAT9tIblt8URdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192151; c=relaxed/simple;
	bh=xAFWhinEGfnmv7WMulrUJNDvrDMWxQJyesJdHWgJLRw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AfbwqrkQrPf63Tod9bt5mEwGdD0V7HQ6Ayzjf66VboNai2cZCD6gOQK6cjecMJOq1aTWZpp2gJLdaNPWjAFiP8QeEQGK0YRpqkfvMyubW07xaLXpsWToW+xt8DNlPBq/+bZPZTntU4K+vcucbFCeBh9VW9BkDJ5HpzVKy1lOK5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SNQDdbpU; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SNQDdbpU"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5429m2mL008278;
	Fri, 2 May 2025 06:22:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Z
	4R6ZSfamybqac9UXtc3JpHVgsmI1U+RufUGucqL4pc=; b=SNQDdbpUTnhRZ1u/H
	JZ+zpq0+P8V2qZ/28iZ08jzdvo6I9lrGjn/EXPOkGzMXGUqbKlDst/zMCkIsy4Tn
	z/LgeB5+boT3U2xIIEchnbDp5Z9+FUfP5Gl4bC0BUsiQ+jGCsamicjPSgieQEySq
	2XeChUuCgOWO1IOeQx1ZzMz2I22Tup/jKIqK42dYWjAOi6pMRIiBdOAoF9kfF6iT
	2jKxbgmF7SuDwef8Ke7kdFaLEG+b3a8I2PlVeH9mF9M0GdO6Wlh+jVmC6YGq4laT
	mhrpddbx4utq+wB99i6jR4br50H4o6rA5/3pG10CExDWxt+YCc37htiCrd/IXoRg
	MPT6g==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cuqyr9ts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:22:11 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:22:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:22:10 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 32DDA5B6921;
	Fri,  2 May 2025 06:21:57 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <bbrezillon@kernel.org>, <arno@natisbad.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        <jerinj@marvell.com>, <hkelam@marvell.com>, <sbhatta@marvell.com>,
        <andrew+netdev@lunn.ch>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bbhushan2@marvell.com>, <bhelgaas@google.com>,
        <pstanner@redhat.com>, <gregkh@linuxfoundation.org>,
        <peterz@infradead.org>, <linux@treblig.org>,
        <krzysztof.kozlowski@linaro.org>, <giovanni.cabiddu@intel.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <rkannoth@marvell.com>, <sumang@marvell.com>,
        <gcherian@marvell.com>, Tanmay Jagdale <tanmay@marvell.com>
Subject: [net-next PATCH v1 05/15] crypto: octeontx2: Remove inbound inline ipsec config
Date: Fri, 2 May 2025 18:49:46 +0530
Message-ID: <20250502132005.611698-6-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250502132005.611698-1-tanmay@marvell.com>
References: <20250502132005.611698-1-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xGJy7vRJuEp6rc7A8__w22FqLiheYTma
X-Authority-Analysis: v=2.4 cv=JvPxrN4C c=1 sm=1 tr=0 ts=6814c704 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=DdTADUWHWwzGM8gDDMAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: xGJy7vRJuEp6rc7A8__w22FqLiheYTma
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX/3IqKprLki/Z dgLHrccpk2iORYE1B1nTOMySzJ6TOJ0332vQ4tNTZ9+yW3adXh5Z0Yx7dcgxm3VS7QAZd9n5Sfp ptlcm20GpBrDtE/D5Sd5C8OTnRNEtzJ7CrFI/Mox2No7K8IL4gDVxr9QO+ohahObtYK3TQUcJkd
 9eNo5bd0CsTjLy0W6CMKg2bg7nes0rcRy/zH8gi1GlDsRzJIChDK9WdM4uzwxLZXsC2DGpiWpHm fmtp57DL+WyrQijUItTO6W2DExJkhob/SpWzvLLaHtGsmP/6/hIIr4CW3hF6XzAYm0PimxlKApe vR+euaYc6GPYobdAyQgj1XnbEwol+RQbWYHtEfuHkupR2LfxOv9RQqZgSeL+pUslEhZHwrpDAeh
 ckx/ZYd6t1FUkxE5pzATtwpxKT2PXsAEOrjWra4E+cR0OtrX/crRPTteuUphl8Ina7WMBR1k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

From: Bharat Bhushan <bbhushan2@marvell.com>

Now AF driver can handle all inbound inline ipsec
configuration so remove this code from CPT driver.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |  10 -
 .../marvell/octeontx2/otx2_cptpf_main.c       |  46 ---
 .../marvell/octeontx2/otx2_cptpf_mbox.c       | 282 +-----------------
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  11 -
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |   4 -
 5 files changed, 2 insertions(+), 351 deletions(-)

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
index 8a7ed0152371..34dbfea7f974 100644
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
 
@@ -833,13 +794,6 @@ static void otx2_cptpf_remove(struct pci_dev *pdev)
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
index 222419bd5ac9..6b2881b534f5 100644
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
@@ -126,186 +112,6 @@ static int handle_msg_kvf_limits(struct otx2_cptpf_dev *cptpf,
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
-	req->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(cptpf->pf_id, 0);
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
-	nix_req->inst_qsel.cpt_pf_func = OTX2_CPT_RVU_PFFUNC(cptpf->pf_id, 0);
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
-	otx2_cptlf_set_dev_info(&cptpf->lfs, cptpf->pdev, cptpf->reg_base,
-				&cptpf->afpf_mbox, BLKADDR_CPT0);
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
-		otx2_cptlf_set_dev_info(&cptpf->cpt1_lfs, cptpf->pdev,
-					cptpf->reg_base, &cptpf->afpf_mbox,
-					BLKADDR_CPT1);
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
@@ -419,28 +225,14 @@ void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work)
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
@@ -466,8 +258,6 @@ static void process_afpf_mbox_msg(struct otx2_cptpf_dev *cptpf,
 			msg->sig, msg->id);
 		return;
 	}
-	if (cptpf->rsrc_req_blkaddr == BLKADDR_CPT1)
-		lfs = &cptpf->cpt1_lfs;
 
 	switch (msg->id) {
 	case MBOX_MSG_READY:
@@ -594,71 +384,3 @@ void otx2_cptpf_afpf_mbox_handler(struct work_struct *work)
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
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index ad74a27888da..f9321084abb6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -386,9 +386,6 @@ M(MCS_CUSTOM_TAG_CFG_GET, 0xa021, mcs_custom_tag_cfg_get,			\
 #define MBOX_UP_CGX_MESSAGES						\
 M(CGX_LINK_EVENT,	0xC00, cgx_link_event, cgx_link_info_msg, msg_rsp)
 
-#define MBOX_UP_CPT_MESSAGES						\
-M(CPT_INST_LMTST,	0xD00, cpt_inst_lmtst, cpt_inst_lmtst_req, msg_rsp)
-
 #define MBOX_UP_MCS_MESSAGES						\
 M(MCS_INTR_NOTIFY,	0xE00, mcs_intr_notify, mcs_intr_info, msg_rsp)
 
@@ -399,7 +396,6 @@ enum {
 #define M(_name, _id, _1, _2, _3) MBOX_MSG_ ## _name = _id,
 MBOX_MESSAGES
 MBOX_UP_CGX_MESSAGES
-MBOX_UP_CPT_MESSAGES
 MBOX_UP_MCS_MESSAGES
 MBOX_UP_REP_MESSAGES
 #undef M
@@ -1915,13 +1911,6 @@ struct cpt_rxc_time_cfg_req {
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
index 2e8ac71979ae..c7e46e77eab0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -704,10 +704,6 @@ int rvu_mbox_handler_cpt_inline_ipsec_cfg(struct rvu *rvu,
 		return CPT_AF_ERR_LF_INVALID;
 
 	switch (req->dir) {
-	case CPT_INLINE_INBOUND:
-		ret = cpt_inline_ipsec_cfg_inbound(rvu, blkaddr, cptlf, req);
-		break;
-
 	case CPT_INLINE_OUTBOUND:
 		ret = cpt_inline_ipsec_cfg_outbound(rvu, blkaddr, cptlf, req);
 		break;
-- 
2.43.0

