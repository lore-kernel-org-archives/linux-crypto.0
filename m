Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E29C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Dec 2021 09:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhLAJFv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Dec 2021 04:05:51 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41524 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237420AbhLAJFu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Dec 2021 04:05:50 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B10nHjZ029075;
        Wed, 1 Dec 2021 01:02:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=2rgadRgmcxW764LsyyI+uUtYi8L/dW4R/haXM0GZCeA=;
 b=TPj598htDN7+gtbZ6Vnwvz01QTHTbl+phGAyGQ74cTFshVExVQJ9XMeBKpPksgTSbxHq
 o7QNjWFS81ASx8Q+ux0qF4mmSoPbBDml8YG4qluD51OmmmKgBUAXUjCPXl2EIpiqVSDi
 Sldw36k5TwNbwR+XQcWmAE8JNNfQJ3quqimwani8fQ4Y4LjJicLGgJVfmppKeQQlR4Xd
 ApFzj++70bCpVQitpWpSBYf9gqdIpQ2dy9S9EBjFnhDLaORCv69HjigUIDVjkqbHJ999
 GCwwPgGO3N4aeO7jfjQzxquTaTdtOdALgZsv5U/qSRv47G9Wamqkwy6ymOtT+aNQHAdk Xg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cnqvyuga1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 Dec 2021 01:02:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Dec
 2021 01:02:21 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 1 Dec 2021 01:02:21 -0800
Received: from localhost.localdomain (unknown [10.28.34.29])
        by maili.marvell.com (Postfix) with ESMTP id 7982D5B6949;
        Wed,  1 Dec 2021 01:02:18 -0800 (PST)
From:   Shijith Thotton <sthotton@marvell.com>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Srujana Challa <schalla@marvell.com>,
        <linux-crypto@vger.kernel.org>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, <gcherian@marvell.com>,
        <ndabilpuram@marvell.com>, Shijith Thotton <sthotton@marvell.com>
Subject: [PATCH 1/2] crypto: octeontx2: add apis for custom engine groups
Date:   Wed, 1 Dec 2021 14:32:00 +0530
Message-ID: <feaa0f22e9b8577dde433eb6c2544e5ca2b82dff.1638348922.git.sthotton@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638348922.git.sthotton@marvell.com>
References: <cover.1638348922.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ZjSHDthc6wsGqV5a8ZOBqO6M0nLb8BeI
X-Proofpoint-GUID: ZjSHDthc6wsGqV5a8ZOBqO6M0nLb8BeI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>

Octeon TX2 CPT has three type of engines to handle symmetric, asymmetric
and ipsec specific workload. For better utilization, these engines can
be grouped to custom groups at runtime.

This patch adds APIs to create and delete custom CPT engine groups.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Shijith Thotton <sthotton@marvell.com>
---
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 322 +++++++++++++++++-
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |   7 +-
 2 files changed, 322 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index dff34b3ec09e..57307eac541c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1110,18 +1110,19 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	struct otx2_cpt_engines engs[OTX2_CPT_MAX_ETYPES_PER_GRP] = { {0} };
 	struct pci_dev *pdev = cptpf->pdev;
 	struct fw_info_t fw_info;
-	int ret;
+	int ret = 0;
 
+	mutex_lock(&eng_grps->lock);
 	/*
 	 * We don't create engine groups if it was already
 	 * made (when user enabled VFs for the first time)
 	 */
 	if (eng_grps->is_grps_created)
-		return 0;
+		goto unlock;
 
 	ret = cpt_ucode_load_fw(pdev, &fw_info);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	/*
 	 * Create engine group with SE engines for kernel
@@ -1186,7 +1187,7 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	cpt_ucode_release_fw(&fw_info);
 
 	if (is_dev_otx2(pdev))
-		return 0;
+		goto unlock;
 	/*
 	 * Configure engine group mask to allow context prefetching
 	 * for the groups.
@@ -1201,12 +1202,15 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	 */
 	otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTX_FLUSH_TIMER,
 			      CTX_FLUSH_TIMER_CNT, BLKADDR_CPT0);
+	mutex_unlock(&eng_grps->lock);
 	return 0;
 
 delete_eng_grp:
 	delete_engine_grps(pdev, eng_grps);
 release_fw:
 	cpt_ucode_release_fw(&fw_info);
+unlock:
+	mutex_unlock(&eng_grps->lock);
 	return ret;
 }
 
@@ -1286,6 +1290,7 @@ void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
 	struct otx2_cpt_eng_grp_info *grp;
 	int i, j;
 
+	mutex_lock(&eng_grps->lock);
 	delete_engine_grps(pdev, eng_grps);
 	/* Release memory */
 	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
@@ -1295,6 +1300,7 @@ void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
 			grp->engs[j].bmap = NULL;
 		}
 	}
+	mutex_unlock(&eng_grps->lock);
 }
 
 int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
@@ -1303,6 +1309,7 @@ int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
 	struct otx2_cpt_eng_grp_info *grp;
 	int i, j, ret;
 
+	mutex_init(&eng_grps->lock);
 	eng_grps->obj = pci_get_drvdata(pdev);
 	eng_grps->avail.se_cnt = eng_grps->avail.max_se_cnt;
 	eng_grps->avail.ie_cnt = eng_grps->avail.max_ie_cnt;
@@ -1349,11 +1356,14 @@ static int create_eng_caps_discovery_grps(struct pci_dev *pdev,
 	struct fw_info_t fw_info;
 	int ret;
 
+	mutex_lock(&eng_grps->lock);
 	ret = cpt_ucode_load_fw(pdev, &fw_info);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&eng_grps->lock);
 		return ret;
+	}
 
-	uc_info[0] = get_ucode(&fw_info, OTX2_CPT_SE_TYPES);
+	uc_info[0] = get_ucode(&fw_info, OTX2_CPT_AE_TYPES);
 	if (uc_info[0] == NULL) {
 		dev_err(&pdev->dev, "Unable to find firmware for AE\n");
 		ret = -EINVAL;
@@ -1396,12 +1406,14 @@ static int create_eng_caps_discovery_grps(struct pci_dev *pdev,
 		goto delete_eng_grp;
 
 	cpt_ucode_release_fw(&fw_info);
+	mutex_unlock(&eng_grps->lock);
 	return 0;
 
 delete_eng_grp:
 	delete_engine_grps(pdev, eng_grps);
 release_fw:
 	cpt_ucode_release_fw(&fw_info);
+	mutex_unlock(&eng_grps->lock);
 	return ret;
 }
 
@@ -1501,3 +1513,301 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 
 	return ret;
 }
+
+static void swap_engines(struct otx2_cpt_engines *engsl,
+			 struct otx2_cpt_engines *engsr)
+{
+	struct otx2_cpt_engines engs;
+
+	engs = *engsl;
+	*engsl = *engsr;
+	*engsr = engs;
+}
+
+int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_cpt_engines engs[OTX2_CPT_MAX_ETYPES_PER_GRP] = { { 0 } };
+	struct otx2_cpt_uc_info_t *uc_info[OTX2_CPT_MAX_ETYPES_PER_GRP] = {};
+	struct otx2_cpt_eng_grps *eng_grps = &cptpf->eng_grps;
+	char *ucode_filename[OTX2_CPT_MAX_ETYPES_PER_GRP];
+	char tmp_buf[OTX2_CPT_NAME_LENGTH] = { 0 };
+	struct device *dev = &cptpf->pdev->dev;
+	char *start, *val, *err_msg, *tmp;
+	int grp_idx = 0, ret = -EINVAL;
+	bool has_se, has_ie, has_ae;
+	struct fw_info_t fw_info;
+	int ucode_idx = 0;
+
+	if (!eng_grps->is_grps_created) {
+		dev_err(dev, "Not allowed before creating the default groups\n");
+		return -EINVAL;
+	}
+	err_msg = "Invalid engine group format";
+	strscpy(tmp_buf, ctx->val.vstr, strlen(ctx->val.vstr) + 1);
+	start = tmp_buf;
+
+	has_se = has_ie = has_ae = false;
+
+	for (;;) {
+		val = strsep(&start, ";");
+		if (!val)
+			break;
+		val = strim(val);
+		if (!*val)
+			continue;
+
+		if (!strncasecmp(val, "se", 2) && strchr(val, ':')) {
+			if (has_se || ucode_idx)
+				goto err_print;
+			tmp = strim(strsep(&val, ":"));
+			if (!val)
+				goto err_print;
+			if (strlen(tmp) != 2)
+				goto err_print;
+			if (kstrtoint(strim(val), 10, &engs[grp_idx].count))
+				goto err_print;
+			engs[grp_idx++].type = OTX2_CPT_SE_TYPES;
+			has_se = true;
+		} else if (!strncasecmp(val, "ae", 2) && strchr(val, ':')) {
+			if (has_ae || ucode_idx)
+				goto err_print;
+			tmp = strim(strsep(&val, ":"));
+			if (!val)
+				goto err_print;
+			if (strlen(tmp) != 2)
+				goto err_print;
+			if (kstrtoint(strim(val), 10, &engs[grp_idx].count))
+				goto err_print;
+			engs[grp_idx++].type = OTX2_CPT_AE_TYPES;
+			has_ae = true;
+		} else if (!strncasecmp(val, "ie", 2) && strchr(val, ':')) {
+			if (has_ie || ucode_idx)
+				goto err_print;
+			tmp = strim(strsep(&val, ":"));
+			if (!val)
+				goto err_print;
+			if (strlen(tmp) != 2)
+				goto err_print;
+			if (kstrtoint(strim(val), 10, &engs[grp_idx].count))
+				goto err_print;
+			engs[grp_idx++].type = OTX2_CPT_IE_TYPES;
+			has_ie = true;
+		} else {
+			if (ucode_idx > 1)
+				goto err_print;
+			if (!strlen(val))
+				goto err_print;
+			if (strnstr(val, " ", strlen(val)))
+				goto err_print;
+			ucode_filename[ucode_idx++] = val;
+		}
+	}
+
+	/* Validate input parameters */
+	if (!(grp_idx && ucode_idx))
+		goto err_print;
+
+	if (ucode_idx > 1 && grp_idx < 2)
+		goto err_print;
+
+	if (grp_idx > OTX2_CPT_MAX_ETYPES_PER_GRP) {
+		err_msg = "Error max 2 engine types can be attached";
+		goto err_print;
+	}
+
+	if (grp_idx > 1) {
+		if ((engs[0].type + engs[1].type) !=
+		    (OTX2_CPT_SE_TYPES + OTX2_CPT_IE_TYPES)) {
+			err_msg = "Only combination of SE+IE engines is allowed";
+			goto err_print;
+		}
+		/* Keep SE engines at zero index */
+		if (engs[1].type == OTX2_CPT_SE_TYPES)
+			swap_engines(&engs[0], &engs[1]);
+	}
+	mutex_lock(&eng_grps->lock);
+
+	if (cptpf->enabled_vfs) {
+		dev_err(dev, "Disable VFs before modifying engine groups\n");
+		ret = -EACCES;
+		goto err_unlock;
+	}
+	INIT_LIST_HEAD(&fw_info.ucodes);
+	ret = load_fw(dev, &fw_info, ucode_filename[0]);
+	if (ret) {
+		dev_err(dev, "Unable to load firmware %s\n", ucode_filename[0]);
+		goto err_unlock;
+	}
+	if (ucode_idx > 1) {
+		ret = load_fw(dev, &fw_info, ucode_filename[1]);
+		if (ret) {
+			dev_err(dev, "Unable to load firmware %s\n",
+				ucode_filename[1]);
+			goto release_fw;
+		}
+	}
+	uc_info[0] = get_ucode(&fw_info, engs[0].type);
+	if (uc_info[0] == NULL) {
+		dev_err(dev, "Unable to find firmware for %s\n",
+			get_eng_type_str(engs[0].type));
+		ret = -EINVAL;
+		goto release_fw;
+	}
+	if (ucode_idx > 1) {
+		uc_info[1] = get_ucode(&fw_info, engs[1].type);
+		if (uc_info[1] == NULL) {
+			dev_err(dev, "Unable to find firmware for %s\n",
+				get_eng_type_str(engs[1].type));
+			ret = -EINVAL;
+			goto release_fw;
+		}
+	}
+	ret = create_engine_group(dev, eng_grps, engs, grp_idx,
+				  (void **)uc_info, 1);
+
+release_fw:
+	cpt_ucode_release_fw(&fw_info);
+err_unlock:
+	mutex_unlock(&eng_grps->lock);
+	return ret;
+err_print:
+	dev_err(dev, "%s\n", err_msg);
+	return ret;
+}
+
+int otx2_cpt_dl_custom_egrp_delete(struct otx2_cptpf_dev *cptpf,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_cpt_eng_grps *eng_grps = &cptpf->eng_grps;
+	struct device *dev = &cptpf->pdev->dev;
+	char *tmp, *err_msg;
+	int egrp;
+	int ret;
+
+	err_msg = "Invalid input string format(ex: egrp:0)";
+	if (strncasecmp(ctx->val.vstr, "egrp", 4))
+		goto err_print;
+	tmp = ctx->val.vstr;
+	strsep(&tmp, ":");
+	if (!tmp)
+		goto err_print;
+	if (kstrtoint(tmp, 10, &egrp))
+		goto err_print;
+
+	if (egrp >= OTX2_CPT_MAX_ENGINE_GROUPS) {
+		dev_err(dev, "Invalid engine group %d", egrp);
+		return -EINVAL;
+	}
+	if (!eng_grps->grp[egrp].is_enabled) {
+		dev_err(dev, "Error engine_group%d is not configured", egrp);
+		return -EINVAL;
+	}
+	mutex_lock(&eng_grps->lock);
+	ret = delete_engine_group(dev, &eng_grps->grp[egrp]);
+	mutex_unlock(&eng_grps->lock);
+
+	return ret;
+
+err_print:
+	dev_err(dev, "%s\n", err_msg);
+	return -EINVAL;
+}
+
+static void get_engs_info(struct otx2_cpt_eng_grp_info *eng_grp, char *buf,
+			  int size, int idx)
+{
+	struct otx2_cpt_engs_rsvd *mirrored_engs = NULL;
+	struct otx2_cpt_engs_rsvd *engs;
+	int len, i;
+
+	buf[0] = '\0';
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		engs = &eng_grp->engs[i];
+		if (!engs->type)
+			continue;
+		if (idx != -1 && idx != i)
+			continue;
+
+		if (eng_grp->mirror.is_ena)
+			mirrored_engs = find_engines_by_type(
+				&eng_grp->g->grp[eng_grp->mirror.idx],
+				engs->type);
+		if (i > 0 && idx == -1) {
+			len = strlen(buf);
+			scnprintf(buf + len, size - len, ", ");
+		}
+
+		len = strlen(buf);
+		scnprintf(buf + len, size - len, "%d %s ",
+			  mirrored_engs ? engs->count + mirrored_engs->count :
+					  engs->count,
+			  get_eng_type_str(engs->type));
+		if (mirrored_engs) {
+			len = strlen(buf);
+			scnprintf(buf + len, size - len,
+				  "(%d shared with engine_group%d) ",
+				  engs->count <= 0 ?
+					  engs->count + mirrored_engs->count :
+					  mirrored_engs->count,
+				  eng_grp->mirror.idx);
+		}
+	}
+}
+
+void otx2_cpt_print_uc_dbg_info(struct otx2_cptpf_dev *cptpf)
+{
+	struct otx2_cpt_eng_grps *eng_grps = &cptpf->eng_grps;
+	struct otx2_cpt_eng_grp_info *mirrored_grp;
+	char engs_info[2 * OTX2_CPT_NAME_LENGTH];
+	struct otx2_cpt_eng_grp_info *grp;
+	struct otx2_cpt_engs_rsvd *engs;
+	u32 mask[4];
+	int i, j;
+
+	pr_debug("Engine groups global info");
+	pr_debug("max SE %d, max IE %d, max AE %d", eng_grps->avail.max_se_cnt,
+		 eng_grps->avail.max_ie_cnt, eng_grps->avail.max_ae_cnt);
+	pr_debug("free SE %d", eng_grps->avail.se_cnt);
+	pr_debug("free IE %d", eng_grps->avail.ie_cnt);
+	pr_debug("free AE %d", eng_grps->avail.ae_cnt);
+
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		grp = &eng_grps->grp[i];
+		pr_debug("engine_group%d, state %s", i,
+			 grp->is_enabled ? "enabled" : "disabled");
+		if (grp->is_enabled) {
+			mirrored_grp = &eng_grps->grp[grp->mirror.idx];
+			pr_debug("Ucode0 filename %s, version %s",
+				 grp->mirror.is_ena ?
+					 mirrored_grp->ucode[0].filename :
+					 grp->ucode[0].filename,
+				 grp->mirror.is_ena ?
+					 mirrored_grp->ucode[0].ver_str :
+					 grp->ucode[0].ver_str);
+			if (is_2nd_ucode_used(grp))
+				pr_debug("Ucode1 filename %s, version %s",
+					 grp->ucode[1].filename,
+					 grp->ucode[1].ver_str);
+		}
+
+		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
+			engs = &grp->engs[j];
+			if (engs->type) {
+				get_engs_info(grp, engs_info,
+					      2 * OTX2_CPT_NAME_LENGTH, j);
+				pr_debug("Slot%d: %s", j, engs_info);
+				bitmap_to_arr32(mask, engs->bmap,
+						eng_grps->engs_num);
+				if (is_dev_otx2(cptpf->pdev))
+					pr_debug("Mask: %8.8x %8.8x %8.8x %8.8x",
+						 mask[3], mask[2], mask[1],
+						 mask[0]);
+				else
+					pr_debug("Mask: %8.8x %8.8x %8.8x %8.8x %8.8x",
+						 mask[4], mask[3], mask[2], mask[1],
+						 mask[0]);
+			}
+		}
+	}
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
index fe019ab730b2..8f4d4e5f531a 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
@@ -143,6 +143,7 @@ struct otx2_cpt_eng_grp_info {
 };
 
 struct otx2_cpt_eng_grps {
+	struct mutex lock;
 	struct otx2_cpt_eng_grp_info grp[OTX2_CPT_MAX_ENGINE_GROUPS];
 	struct otx2_cpt_engs_available avail;
 	void *obj;			/* device specific data */
@@ -160,5 +161,9 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf);
 int otx2_cpt_get_eng_grp(struct otx2_cpt_eng_grps *eng_grps, int eng_type);
 int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf);
-
+int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
+				   struct devlink_param_gset_ctx *ctx);
+int otx2_cpt_dl_custom_egrp_delete(struct otx2_cptpf_dev *cptpf,
+				   struct devlink_param_gset_ctx *ctx);
+void otx2_cpt_print_uc_dbg_info(struct otx2_cptpf_dev *cptpf);
 #endif /* __OTX2_CPTPF_UCODE_H */
-- 
2.25.1

