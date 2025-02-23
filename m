Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69CBB644;
	Sun, 23 Feb 2025 00:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740272058; cv=none; b=rxMPMuxz+YXdqXQL78Q3xopEtEOoKBmR0dmvVw/GPwu8YBFkcjjDXrJfeIb2jl5Sns7T/ICp3JpXiE294+xC6m9SdsbQKBh/53sGyc9YSxTMOCtUpvF9f3GpYmoMLOGWtCx+yqEu/2sPek5fgY6Fqn6Y1pQh/7881zvgLxouJ20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740272058; c=relaxed/simple;
	bh=o+IWTTsfZ8UArbFpJBreW2WeqFSzgNQjjt9B0UwDcaE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dp8xvgrAmHTN1+sBaeX/q0XjQzHbCGvH3AIBByCVmYCR4Td6IfdehzqKzAc1QBdiXdLZT5DC+K5yPmNodCYsx5L+pBuPod0sOIajejczp+I8blbae9N02e+BPEtlocnTZ5SXeJIpOJmjkFt26X0uNUKcDxzd9jFW1U2B/DuGAYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=iEE8hZ3S; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="iEE8hZ3S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=GsDlBwmFycizDpQ9XAHJtEhdO9oAJRPC61SrSSIJHAc=; b=iEE8hZ3SBZJidvlO
	RLGkJGICfLfGs1XsFh5dNHJvALIEwiHkli/G4WdDt+OpBsvjY1VFiGiUmgqI6GY5d20zlT+dHwvFF
	usi1of5Mn2CteMO0J4VmY1GWsyiftg+M+g7/mMbnfUK4W06deq4JpDDnH8THLH5oowA+D2kclIMIB
	KVoi4PKJ9o4Gihn+0yvChVVkNASpf149odLmmQYfOr1aeZVXCljqCDY9aV4BQ6OaoxW3LEnGdd7yr
	uM0X8ra7rq77wbt5PF6bl7K62FibtXByDQ38AMbgAHjPyGu1Z6v0HlfjnL0nU3cFrAi0FADPMSNaW
	70Mmtbric04YqStDwA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tm0Fn-0008QV-11;
	Sun, 23 Feb 2025 00:53:55 +0000
From: linux@treblig.org
To: bbrezillon@kernel.org,
	arno@natisbad.org,
	schalla@marvell.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: octeontx2 - Remove unused otx2_cpt_print_uc_dbg_info
Date: Sun, 23 Feb 2025 00:53:54 +0000
Message-ID: <20250223005354.86234-1-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

otx2_cpt_print_uc_dbg_info() has been unused since 2023's
commit 82f89f1aa6ca ("crypto: octeontx2 - add devlink option to set t106
mode")

Remove it and the get_engs_info() helper it's the only user of.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 99 -------------------
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |  1 -
 2 files changed, 100 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 5c9484646172..0af34e0e46f2 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1774,102 +1774,3 @@ int otx2_cpt_dl_custom_egrp_delete(struct otx2_cptpf_dev *cptpf,
 	dev_err(dev, "%s\n", err_msg);
 	return -EINVAL;
 }
-
-static void get_engs_info(struct otx2_cpt_eng_grp_info *eng_grp, char *buf,
-			  int size, int idx)
-{
-	struct otx2_cpt_engs_rsvd *mirrored_engs = NULL;
-	struct otx2_cpt_engs_rsvd *engs;
-	int len, i;
-
-	buf[0] = '\0';
-	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
-		engs = &eng_grp->engs[i];
-		if (!engs->type)
-			continue;
-		if (idx != -1 && idx != i)
-			continue;
-
-		if (eng_grp->mirror.is_ena)
-			mirrored_engs = find_engines_by_type(
-				&eng_grp->g->grp[eng_grp->mirror.idx],
-				engs->type);
-		if (i > 0 && idx == -1) {
-			len = strlen(buf);
-			scnprintf(buf + len, size - len, ", ");
-		}
-
-		len = strlen(buf);
-		scnprintf(buf + len, size - len, "%d %s ",
-			  mirrored_engs ? engs->count + mirrored_engs->count :
-					  engs->count,
-			  get_eng_type_str(engs->type));
-		if (mirrored_engs) {
-			len = strlen(buf);
-			scnprintf(buf + len, size - len,
-				  "(%d shared with engine_group%d) ",
-				  engs->count <= 0 ?
-					  engs->count + mirrored_engs->count :
-					  mirrored_engs->count,
-				  eng_grp->mirror.idx);
-		}
-	}
-}
-
-void otx2_cpt_print_uc_dbg_info(struct otx2_cptpf_dev *cptpf)
-{
-	struct otx2_cpt_eng_grps *eng_grps = &cptpf->eng_grps;
-	struct otx2_cpt_eng_grp_info *mirrored_grp;
-	char engs_info[2 * OTX2_CPT_NAME_LENGTH];
-	struct otx2_cpt_eng_grp_info *grp;
-	struct otx2_cpt_engs_rsvd *engs;
-	int i, j;
-
-	pr_debug("Engine groups global info");
-	pr_debug("max SE %d, max IE %d, max AE %d", eng_grps->avail.max_se_cnt,
-		 eng_grps->avail.max_ie_cnt, eng_grps->avail.max_ae_cnt);
-	pr_debug("free SE %d", eng_grps->avail.se_cnt);
-	pr_debug("free IE %d", eng_grps->avail.ie_cnt);
-	pr_debug("free AE %d", eng_grps->avail.ae_cnt);
-
-	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
-		grp = &eng_grps->grp[i];
-		pr_debug("engine_group%d, state %s", i,
-			 grp->is_enabled ? "enabled" : "disabled");
-		if (grp->is_enabled) {
-			mirrored_grp = &eng_grps->grp[grp->mirror.idx];
-			pr_debug("Ucode0 filename %s, version %s",
-				 grp->mirror.is_ena ?
-					 mirrored_grp->ucode[0].filename :
-					 grp->ucode[0].filename,
-				 grp->mirror.is_ena ?
-					 mirrored_grp->ucode[0].ver_str :
-					 grp->ucode[0].ver_str);
-			if (is_2nd_ucode_used(grp))
-				pr_debug("Ucode1 filename %s, version %s",
-					 grp->ucode[1].filename,
-					 grp->ucode[1].ver_str);
-		}
-
-		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
-			engs = &grp->engs[j];
-			if (engs->type) {
-				u32 mask[5] = { };
-
-				get_engs_info(grp, engs_info,
-					      2 * OTX2_CPT_NAME_LENGTH, j);
-				pr_debug("Slot%d: %s", j, engs_info);
-				bitmap_to_arr32(mask, engs->bmap,
-						eng_grps->engs_num);
-				if (is_dev_otx2(cptpf->pdev))
-					pr_debug("Mask: %8.8x %8.8x %8.8x %8.8x",
-						 mask[3], mask[2], mask[1],
-						 mask[0]);
-				else
-					pr_debug("Mask: %8.8x %8.8x %8.8x %8.8x %8.8x",
-						 mask[4], mask[3], mask[2], mask[1],
-						 mask[0]);
-			}
-		}
-	}
-}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
index 365fe8943bd9..7e6a6a4ec37c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
@@ -166,7 +166,6 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
 				   struct devlink_param_gset_ctx *ctx);
 int otx2_cpt_dl_custom_egrp_delete(struct otx2_cptpf_dev *cptpf,
 				   struct devlink_param_gset_ctx *ctx);
-void otx2_cpt_print_uc_dbg_info(struct otx2_cptpf_dev *cptpf);
 struct otx2_cpt_engs_rsvd *find_engines_by_type(
 					struct otx2_cpt_eng_grp_info *eng_grp,
 					int eng_type);
-- 
2.48.1

