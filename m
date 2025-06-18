Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC31F2DE1FB;
	Wed, 18 Jun 2025 11:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246266; cv=none; b=vA58vrehAy1j6YRH8Amvq+1PikuQIjUNHf9iLbjHwPukD4WbzoQqQwgi8qg344myznbaBOFtcdf7xVWMWMEMc5kSkH6lq7wpwxFJ4nWlE3cPcDakEMhbNjgOiw3QsHPcXjyUgFtRzmCoia7T6vfyx5y7v7GEBDAuldEg9tKhvwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246266; c=relaxed/simple;
	bh=PFWYLyIoIt4cTapU/Na90+p9QAzw3OdbfKGAWXPb2Pc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJwg5zPNnwUjska3MbEmc5pILJTIPJ27OhFVUb4xyS/YSW666sQDfuYWsKlMlR9y4wWjPNSBERBKkdqIFL/z1TsqgniOH/eMBSvq1WB2uZv0UpPtav3YSnKEQTRSyeOKVh4gzeMXno33mxrJduvT+aOXF9W5f0EmNEhybZC0ZPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=BQDB0FSB; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BQDB0FSB"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7sfFg027085;
	Wed, 18 Jun 2025 04:30:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=i
	Le9p3KhtGYjUyD0QrbVR+Dw+UM6lLqMmetl9QM08NI=; b=BQDB0FSBwfYx4zwmK
	5TwR+SBgEL1oaHOOZfy+zXT7XT5KcgTtM0mSvYhmsV8xpLeB6YfWd0hy0kyCDQH8
	/HbTNrA9jo3OAPulaFwOwcTOxixZqhCOocQngO4MHkaWnzm57DFOy5iPjB77730Z
	XTE4IPFU4M+dTgqoiu4ctg2bfkEiulMaqdEQiQCQ4pKJY4nat1Iz2NUW7Ce9g9tj
	wb+vOk+zQx6zd6zQPHK9KtSVAWtOL8oFPam3bmWnntBVDu7DlwrhOhwWqgqO4fpG
	Uhzej5aumTdWA8Ly4hTFKCVKbWNz8ONlinhUwd1HlBXF2E9rXTS9nDG44Aj/0tLj
	P9Nxw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47bsf2recm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:30:43 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:30:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:30:42 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 1D1AD3F7058;
	Wed, 18 Jun 2025 04:30:38 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v2 01/14] crypto: octeontx2: Share engine group info with AF driver
Date: Wed, 18 Jun 2025 16:59:55 +0530
Message-ID: <20250618113020.130888-2-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: xG-Y9vfK3agI7Z0bgr20DXcd--l10VAg
X-Proofpoint-GUID: xG-Y9vfK3agI7Z0bgr20DXcd--l10VAg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5NyBTYWx0ZWRfXx9i5IjsJhzuP XamHQ1iNUs5tqYtID/vz6R22ffvG44IyggMQ/0YU42M/5NJmBixLpmQIrdwk25x7Q0wAMEmV9hj XmbsJJEIm+mjMNB9gzUV9q3LlcwoJpxCpOPx8OH13kmtCQB+PUNDhmebxzbGGUtrdM51pRgUAfJ
 pgD9+/uk3AvQabxGcz4q13fLZJYJMfPCaD/1G4bXRu76nJhyfMt5fQTOXdhqJ7QPggbwKqEmsUF eRu8AkPZmwAKg2Xp46XJOMu93fAz0Vqtg7ojgy+9DPqIBuumvVyyLZ5LEi0D6aEDEf/1TGErOYB p1mgSyeRx4ZKs4orpNqB7hwujO+Nf2riH10NJ7PEVecxiZwE6KuaMP+Q+Uc/askqu1J2IICSXLC
 hckGTfWaMFuAkXq52qdvTOUvDd9xHV59aA8GWI01rutW2ZmmDrh14HI8hUfi3aQPigyvptAB
X-Authority-Analysis: v=2.4 cv=Yu4PR5YX c=1 sm=1 tr=0 ts=6852a363 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=GI_xRDtv3xhmJ9wnqnoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

From: Bharat Bhushan <bbhushan2@marvell.com>

CPT crypto hardware have multiple engines of different type
and these engines of a give type are attached to one of the
engine group. Software will submit ecnap/decap work to these
engine group. Engine group details are available with CPT
crypto driver. This is shared with AF driver using mailbox
message to enable use cases like inline-ipsec etc.

Also, no need to try to delete engine groups if engine group
initialization fails. Engine groups will never be created
before engine group initialization.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---

Changes in v2:
- None 

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-2-tanmay@marvell.com/

 .../marvell/octeontx2/otx2_cpt_common.h       |   7 --
 .../marvell/octeontx2/otx2_cptpf_main.c       |   4 +-
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |   1 +
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 116 ++++++++++++++++--
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |   3 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  16 +++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  10 ++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  21 ++++
 8 files changed, 160 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 062def303dce..89d4dfbb1e8e 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -31,13 +31,6 @@
 
 #define BAD_OTX2_CPT_ENG_TYPE OTX2_CPT_MAX_ENG_TYPES
 
-enum otx2_cpt_eng_type {
-	OTX2_CPT_AE_TYPES = 1,
-	OTX2_CPT_SE_TYPES = 2,
-	OTX2_CPT_IE_TYPES = 3,
-	OTX2_CPT_MAX_ENG_TYPES,
-};
-
 /* Take mbox id from end of CPT mbox range in AF (range 0xA00 - 0xBFF) */
 #define MBOX_MSG_RX_INLINE_IPSEC_LF_CFG 0xBFE
 #define MBOX_MSG_GET_ENG_GRP_NUM        0xBFF
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 1c5c262af48d..1bceabe5f0e2 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -819,7 +819,7 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 sysfs_grp_del:
 	sysfs_remove_group(&dev->kobj, &cptpf_sysfs_group);
 cleanup_eng_grps:
-	otx2_cpt_cleanup_eng_grps(pdev, &cptpf->eng_grps);
+	otx2_cpt_cleanup_eng_grps(cptpf);
 free_lmtst:
 	cn10k_cpt_lmtst_free(pdev, &cptpf->lfs);
 unregister_intr:
@@ -851,7 +851,7 @@ static void otx2_cptpf_remove(struct pci_dev *pdev)
 	/* Delete sysfs entry created for kernel VF limits */
 	sysfs_remove_group(&pdev->dev.kobj, &cptpf_sysfs_group);
 	/* Cleanup engine groups */
-	otx2_cpt_cleanup_eng_grps(pdev, &cptpf->eng_grps);
+	otx2_cpt_cleanup_eng_grps(cptpf);
 	/* Disable AF-PF mailbox interrupt */
 	cptpf_disable_afpf_mbox_intr(cptpf);
 	/* Destroy AF-PF mbox */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index b4b2d3d1cbc2..3ff3a49bd82b 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -502,6 +502,7 @@ static void process_afpf_mbox_msg(struct otx2_cptpf_dev *cptpf,
 	case MBOX_MSG_NIX_INLINE_IPSEC_CFG:
 	case MBOX_MSG_CPT_LF_RESET:
 	case MBOX_MSG_LMTST_TBL_SETUP:
+	case MBOX_MSG_CPT_SET_ENG_GRP_NUM:
 		break;
 
 	default:
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 7180944ece50..b8c1d95d2c45 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1144,6 +1144,68 @@ int otx2_cpt_get_eng_grp(struct otx2_cpt_eng_grps *eng_grps, int eng_type)
 	return eng_grp_num;
 }
 
+static int otx2_cpt_get_eng_grp_type(struct otx2_cpt_eng_grps *eng_grps,
+				     int grp_num)
+{
+	struct otx2_cpt_eng_grp_info *grp;
+
+	grp = &eng_grps->grp[grp_num];
+	if (!grp->is_enabled)
+		return 0;
+
+	if (eng_grp_has_eng_type(grp, OTX2_CPT_SE_TYPES) &&
+	    !eng_grp_has_eng_type(grp, OTX2_CPT_IE_TYPES))
+		return OTX2_CPT_SE_TYPES;
+
+	if (eng_grp_has_eng_type(grp, OTX2_CPT_IE_TYPES))
+		return OTX2_CPT_IE_TYPES;
+
+	if (eng_grp_has_eng_type(grp, OTX2_CPT_AE_TYPES))
+		return OTX2_CPT_AE_TYPES;
+	return 0;
+}
+
+static int otx2_cpt_set_eng_grp_num(struct otx2_cptpf_dev *cptpf,
+				    enum otx2_cpt_eng_type eng_type, bool set)
+{
+	struct cpt_set_egrp_num *req;
+	struct pci_dev *pdev = cptpf->pdev;
+
+	if (!eng_type || eng_type >= OTX2_CPT_MAX_ENG_TYPES)
+		return -EINVAL;
+
+	req = (struct cpt_set_egrp_num *)
+	      otx2_mbox_alloc_msg_rsp(&cptpf->afpf_mbox, 0,
+				      sizeof(*req), sizeof(struct msg_rsp));
+	if (!req) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	memset(req, 0, sizeof(*req));
+	req->hdr.id = MBOX_MSG_CPT_SET_ENG_GRP_NUM;
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	req->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(cptpf->pdev, cptpf->pf_id, 0);
+	req->set = set;
+	req->eng_type = eng_type;
+	req->eng_grp_num = otx2_cpt_get_eng_grp(&cptpf->eng_grps, eng_type);
+
+	return otx2_cpt_send_mbox_msg(&cptpf->afpf_mbox, pdev);
+}
+
+static int otx2_cpt_set_eng_grp_nums(struct otx2_cptpf_dev *cptpf, bool set)
+{
+	enum otx2_cpt_eng_type type;
+	int ret;
+
+	for (type = OTX2_CPT_AE_TYPES; type < OTX2_CPT_MAX_ENG_TYPES; type++) {
+		ret = otx2_cpt_set_eng_grp_num(cptpf, type, set);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 			     struct otx2_cpt_eng_grps *eng_grps)
 {
@@ -1224,6 +1286,10 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	if (ret)
 		goto delete_eng_grp;
 
+	ret = otx2_cpt_set_eng_grp_nums(cptpf, 1);
+	if (ret)
+		goto unset_eng_grp;
+
 	eng_grps->is_grps_created = true;
 
 	cpt_ucode_release_fw(&fw_info);
@@ -1271,6 +1337,8 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	mutex_unlock(&eng_grps->lock);
 	return 0;
 
+unset_eng_grp:
+	otx2_cpt_set_eng_grp_nums(cptpf, 0);
 delete_eng_grp:
 	delete_engine_grps(pdev, eng_grps);
 release_fw:
@@ -1350,9 +1418,10 @@ int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf)
 	return cptx_disable_all_cores(cptpf, total_cores, BLKADDR_CPT0);
 }
 
-void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
-			       struct otx2_cpt_eng_grps *eng_grps)
+void otx2_cpt_cleanup_eng_grps(struct otx2_cptpf_dev *cptpf)
 {
+	struct otx2_cpt_eng_grps *eng_grps = &cptpf->eng_grps;
+	struct pci_dev *pdev = cptpf->pdev;
 	struct otx2_cpt_eng_grp_info *grp;
 	int i, j;
 
@@ -1366,6 +1435,8 @@ void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
 			grp->engs[j].bmap = NULL;
 		}
 	}
+
+	otx2_cpt_set_eng_grp_nums(cptpf, 0);
 	mutex_unlock(&eng_grps->lock);
 }
 
@@ -1388,8 +1459,7 @@ int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
 		dev_err(&pdev->dev,
 			"Number of engines %d > than max supported %d\n",
 			eng_grps->engs_num, OTX2_CPT_MAX_ENGINES);
-		ret = -EINVAL;
-		goto cleanup_eng_grps;
+		return -EINVAL;
 	}
 
 	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
@@ -1403,14 +1473,20 @@ int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
 					sizeof(long), GFP_KERNEL);
 			if (!grp->engs[j].bmap) {
 				ret = -ENOMEM;
-				goto cleanup_eng_grps;
+				goto release_bmap;
 			}
 		}
 	}
 	return 0;
 
-cleanup_eng_grps:
-	otx2_cpt_cleanup_eng_grps(pdev, eng_grps);
+release_bmap:
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		grp = &eng_grps->grp[i];
+		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
+			kfree(grp->engs[j].bmap);
+			grp->engs[j].bmap = NULL;
+		}
+	}
 	return ret;
 }
 
@@ -1590,6 +1666,7 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
 	bool has_se, has_ie, has_ae;
 	struct fw_info_t fw_info;
 	int ucode_idx = 0;
+	int egrp;
 
 	if (!eng_grps->is_grps_created) {
 		dev_err(dev, "Not allowed before creating the default groups\n");
@@ -1727,7 +1804,21 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
 	}
 	ret = create_engine_group(dev, eng_grps, engs, grp_idx,
 				  (void **)uc_info, 1);
+	if (ret)
+		goto release_fw;
 
+	ret = otx2_cpt_set_eng_grp_num(cptpf, engs[0].type, 1);
+	if (ret) {
+		egrp = otx2_cpt_get_eng_grp(eng_grps, engs[0].type);
+		ret = delete_engine_group(dev, &eng_grps->grp[egrp]);
+	}
+	if (ucode_idx > 1) {
+		ret = otx2_cpt_set_eng_grp_num(cptpf, engs[1].type, 1);
+		if (ret) {
+			egrp = otx2_cpt_get_eng_grp(eng_grps, engs[1].type);
+			ret = delete_engine_group(dev, &eng_grps->grp[egrp]);
+		}
+	}
 release_fw:
 	cpt_ucode_release_fw(&fw_info);
 err_unlock:
@@ -1745,6 +1836,7 @@ int otx2_cpt_dl_custom_egrp_delete(struct otx2_cptpf_dev *cptpf,
 	struct device *dev = &cptpf->pdev->dev;
 	char *tmp, *err_msg;
 	int egrp;
+	int type;
 	int ret;
 
 	err_msg = "Invalid input string format(ex: egrp:0)";
@@ -1766,6 +1858,16 @@ int otx2_cpt_dl_custom_egrp_delete(struct otx2_cptpf_dev *cptpf,
 		return -EINVAL;
 	}
 	mutex_lock(&eng_grps->lock);
+	type = otx2_cpt_get_eng_grp_type(eng_grps, egrp);
+	if (!type) {
+		mutex_unlock(&eng_grps->lock);
+		return -EINVAL;
+	}
+	ret = otx2_cpt_set_eng_grp_num(cptpf, type, 0);
+	if (ret) {
+		mutex_unlock(&eng_grps->lock);
+		return -EINVAL;
+	}
 	ret = delete_engine_group(dev, &eng_grps->grp[egrp]);
 	mutex_unlock(&eng_grps->lock);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
index 7e6a6a4ec37c..85ead693e359 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
@@ -155,8 +155,7 @@ struct otx2_cpt_eng_grps {
 struct otx2_cptpf_dev;
 int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
 			   struct otx2_cpt_eng_grps *eng_grps);
-void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
-			       struct otx2_cpt_eng_grps *eng_grps);
+void otx2_cpt_cleanup_eng_grps(struct otx2_cptpf_dev *cptpf);
 int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 			     struct otx2_cpt_eng_grps *eng_grps);
 int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index b3562d658d45..f0342c0001c2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -219,6 +219,8 @@ M(CPT_CTX_CACHE_SYNC,   0xA07, cpt_ctx_cache_sync, msg_req, msg_rsp)    \
 M(CPT_LF_RESET,         0xA08, cpt_lf_reset, cpt_lf_rst_req, msg_rsp)	\
 M(CPT_FLT_ENG_INFO,     0xA09, cpt_flt_eng_info, cpt_flt_eng_info_req,	\
 			       cpt_flt_eng_info_rsp)			\
+M(CPT_SET_ENG_GRP_NUM,  0xA0A, cpt_set_eng_grp_num, cpt_set_egrp_num,   \
+				msg_rsp)				\
 /* SDP mbox IDs (range 0x1000 - 0x11FF) */				\
 M(SET_SDP_CHAN_INFO, 0x1000, set_sdp_chan_info, sdp_chan_info_msg, msg_rsp) \
 M(GET_SDP_CHAN_INFO, 0x1001, get_sdp_chan_info, msg_req, sdp_get_chan_info_msg) \
@@ -1951,6 +1953,20 @@ struct cpt_flt_eng_info_rsp {
 	u64 rsvd;
 };
 
+enum otx2_cpt_eng_type {
+	OTX2_CPT_AE_TYPES = 1,
+	OTX2_CPT_SE_TYPES = 2,
+	OTX2_CPT_IE_TYPES = 3,
+	OTX2_CPT_MAX_ENG_TYPES,
+};
+
+struct cpt_set_egrp_num {
+	struct mbox_msghdr hdr;
+	bool set;
+	u8 eng_type;
+	u8 eng_grp_num;
+};
+
 struct sdp_node_info {
 	/* Node to which this PF belons to */
 	u8 node_id;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 7ee1fdeb5295..4537b7ecfd90 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -565,6 +565,15 @@ struct rep_evtq_ent {
 	struct rep_event event;
 };
 
+struct rvu_cpt_eng_grp {
+	u8 eng_type;
+	u8 grp_num;
+};
+
+struct rvu_cpt {
+	struct rvu_cpt_eng_grp eng_grp[OTX2_CPT_MAX_ENG_TYPES];
+};
+
 struct rvu {
 	void __iomem		*afreg_base;
 	void __iomem		*pfreg_base;
@@ -645,6 +654,7 @@ struct rvu {
 	spinlock_t		mcs_intrq_lock;
 	/* CPT interrupt lock */
 	spinlock_t		cpt_intr_lock;
+	struct rvu_cpt		rvu_cpt;
 
 	struct mutex		mbox_lock; /* Serialize mbox up and down msgs */
 	u16			rep_pcifunc;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index f404117bf6c8..69c1796fba44 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -656,6 +656,27 @@ static int cpt_inline_ipsec_cfg_outbound(struct rvu *rvu, int blkaddr, u8 cptlf,
 	return 0;
 }
 
+int rvu_mbox_handler_cpt_set_eng_grp_num(struct rvu *rvu,
+					 struct cpt_set_egrp_num *req,
+					 struct msg_rsp *rsp)
+{
+	struct rvu_cpt *rvu_cpt = &rvu->rvu_cpt;
+	u8 eng_type = req->eng_type;
+
+	if (!eng_type || eng_type >= OTX2_CPT_MAX_ENG_TYPES)
+		return -EINVAL;
+
+	if (req->set) {
+		rvu_cpt->eng_grp[eng_type].grp_num = req->eng_grp_num;
+		rvu_cpt->eng_grp[eng_type].eng_type = eng_type;
+	} else {
+		rvu_cpt->eng_grp[eng_type].grp_num = 0;
+		rvu_cpt->eng_grp[eng_type].eng_type = 0;
+	}
+
+	return 0;
+}
+
 int rvu_mbox_handler_cpt_inline_ipsec_cfg(struct rvu *rvu,
 					  struct cpt_inline_ipsec_cfg_msg *req,
 					  struct msg_rsp *rsp)
-- 
2.43.0

