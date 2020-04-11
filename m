Return-Path: <SRS0=qmX+=53=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F4BC2BA2B
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Apr 2020 10:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1A0A20787
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Apr 2020 10:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgDKKpO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Apr 2020 06:45:14 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:59629 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgDKKpO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Apr 2020 06:45:14 -0400
Received: from localhost.localdomain ([93.22.135.18])
        by mwinf5d25 with ME
        id RNkz2200Q0Pz5GD03Nkzvf; Sat, 11 Apr 2020 12:45:11 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 11 Apr 2020 12:45:11 +0200
X-ME-IP: 93.22.135.18
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        lbartosik@marvell.com, colin.king@canonical.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: marvell/octeontx - Add missing '\n' in log messages
Date:   Sat, 11 Apr 2020 12:44:58 +0200
Message-Id: <20200411104458.21526-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Message logged by 'dev_xxx()' or 'pr_xxx()' should end with a '\n'.

While at it, I've introduced a few pr_cont that looked logical to me.

Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
Fixes: d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT engine")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 .../crypto/marvell/octeontx/otx_cptpf_main.c  |  4 +-
 .../crypto/marvell/octeontx/otx_cptpf_mbox.c  | 12 +--
 .../crypto/marvell/octeontx/otx_cptpf_ucode.c | 91 ++++++++++---------
 .../crypto/marvell/octeontx/otx_cptvf_algs.c  |  6 +-
 .../crypto/marvell/octeontx/otx_cptvf_main.c  | 12 +--
 .../marvell/octeontx/otx_cptvf_reqmgr.c       | 10 +-
 6 files changed, 68 insertions(+), 67 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_main.c b/drivers/crypto/marvell/octeontx/otx_cptpf_main.c
index 200fb3303db0..34bb3063eb70 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_main.c
@@ -79,13 +79,13 @@ static int otx_cpt_device_init(struct otx_cpt_device *cpt)
 	/* Check BIST status */
 	bist = (u64)otx_cpt_check_bist_status(cpt);
 	if (bist) {
-		dev_err(dev, "RAM BIST failed with code 0x%llx", bist);
+		dev_err(dev, "RAM BIST failed with code 0x%llx\n", bist);
 		return -ENODEV;
 	}
 
 	bist = otx_cpt_check_exe_bist_status(cpt);
 	if (bist) {
-		dev_err(dev, "Engine BIST failed with code 0x%llx", bist);
+		dev_err(dev, "Engine BIST failed with code 0x%llx\n", bist);
 		return -ENODEV;
 	}
 
diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c b/drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c
index a6774232e9a3..a9e3de65875a 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c
@@ -63,11 +63,11 @@ static void dump_mbox_msg(struct otx_cpt_mbox *mbox_msg, int vf_id)
 	hex_dump_to_buffer(mbox_msg, sizeof(struct otx_cpt_mbox), 16, 8,
 			   raw_data_str, OTX_CPT_MAX_MBOX_DATA_STR_SIZE, false);
 	if (vf_id >= 0)
-		pr_debug("MBOX opcode %s received from VF%d raw_data %s",
+		pr_debug("MBOX opcode %s received from VF%d raw_data %s\n",
 			 get_mbox_opcode_str(mbox_msg->msg), vf_id,
 			 raw_data_str);
 	else
-		pr_debug("MBOX opcode %s received from PF raw_data %s",
+		pr_debug("MBOX opcode %s received from PF raw_data %s\n",
 			 get_mbox_opcode_str(mbox_msg->msg), raw_data_str);
 }
 
@@ -140,20 +140,20 @@ static int otx_cpt_bind_vq_to_grp(struct otx_cpt_device *cpt, u8 q, u8 grp)
 	struct otx_cpt_ucode *ucode;
 
 	if (q >= cpt->max_vfs) {
-		dev_err(dev, "Requested queue %d is > than maximum avail %d",
+		dev_err(dev, "Requested queue %d is > than maximum avail %d\n",
 			q, cpt->max_vfs);
 		return -EINVAL;
 	}
 
 	if (grp >= OTX_CPT_MAX_ENGINE_GROUPS) {
-		dev_err(dev, "Requested group %d is > than maximum avail %d",
+		dev_err(dev, "Requested group %d is > than maximum avail %d\n",
 			grp, OTX_CPT_MAX_ENGINE_GROUPS);
 		return -EINVAL;
 	}
 
 	eng_grp = &cpt->eng_grps.grp[grp];
 	if (!eng_grp->is_enabled) {
-		dev_err(dev, "Requested engine group %d is disabled", grp);
+		dev_err(dev, "Requested engine group %d is disabled\n", grp);
 		return -EINVAL;
 	}
 
@@ -212,7 +212,7 @@ static void otx_cpt_handle_mbox_intr(struct otx_cpt_device *cpt, int vf)
 		vftype = otx_cpt_bind_vq_to_grp(cpt, vf, (u8)mbx.data);
 		if ((vftype != OTX_CPT_AE_TYPES) &&
 		    (vftype != OTX_CPT_SE_TYPES)) {
-			dev_err(dev, "VF%d binding to eng group %llu failed",
+			dev_err(dev, "VF%d binding to eng group %llu failed\n",
 				vf, mbx.data);
 			otx_cptpf_mbox_send_nack(cpt, vf, &mbx);
 		} else {
diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index d04baa319592..dedc3626b8a2 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -62,7 +62,7 @@ static struct otx_cpt_bitmap get_cores_bmap(struct device *dev,
 	int i;
 
 	if (eng_grp->g->engs_num > OTX_CPT_MAX_ENGINES) {
-		dev_err(dev, "unsupported number of engines %d on octeontx",
+		dev_err(dev, "unsupported number of engines %d on octeontx\n",
 			eng_grp->g->engs_num);
 		return bmap;
 	}
@@ -78,7 +78,7 @@ static struct otx_cpt_bitmap get_cores_bmap(struct device *dev,
 	}
 
 	if (!found)
-		dev_err(dev, "No engines reserved for engine group %d",
+		dev_err(dev, "No engines reserved for engine group %d\n",
 			eng_grp->idx);
 	return bmap;
 }
@@ -306,7 +306,7 @@ static int process_tar_file(struct device *dev,
 	ucode_size = ntohl(ucode_hdr->code_length) * 2;
 	if (!ucode_size || (size < round_up(ucode_size, 16) +
 	    sizeof(struct otx_cpt_ucode_hdr) + OTX_CPT_UCODE_SIGN_LEN)) {
-		dev_err(dev, "Ucode %s invalid size", filename);
+		dev_err(dev, "Ucode %s invalid size\n", filename);
 		return -EINVAL;
 	}
 
@@ -379,18 +379,18 @@ static void print_tar_dbg_info(struct tar_arch_info_t *tar_arch,
 {
 	struct tar_ucode_info_t *curr;
 
-	pr_debug("Tar archive filename %s", tar_filename);
-	pr_debug("Tar archive pointer %p, size %ld", tar_arch->fw->data,
+	pr_debug("Tar archive filename %s\n", tar_filename);
+	pr_debug("Tar archive pointer %p, size %ld\n", tar_arch->fw->data,
 		 tar_arch->fw->size);
 	list_for_each_entry(curr, &tar_arch->ucodes, list) {
-		pr_debug("Ucode filename %s", curr->ucode.filename);
-		pr_debug("Ucode version string %s", curr->ucode.ver_str);
-		pr_debug("Ucode version %d.%d.%d.%d",
+		pr_debug("Ucode filename %s\n", curr->ucode.filename);
+		pr_debug("Ucode version string %s\n", curr->ucode.ver_str);
+		pr_debug("Ucode version %d.%d.%d.%d\n",
 			 curr->ucode.ver_num.nn, curr->ucode.ver_num.xx,
 			 curr->ucode.ver_num.yy, curr->ucode.ver_num.zz);
-		pr_debug("Ucode type (%d) %s", curr->ucode.type,
+		pr_debug("Ucode type (%d) %s\n", curr->ucode.type,
 			 get_ucode_type_str(curr->ucode.type));
-		pr_debug("Ucode size %d", curr->ucode.size);
+		pr_debug("Ucode size %d\n", curr->ucode.size);
 		pr_debug("Ucode ptr %p\n", curr->ucode_ptr);
 	}
 }
@@ -417,14 +417,14 @@ static struct tar_arch_info_t *load_tar_archive(struct device *dev,
 		goto release_tar_arch;
 
 	if (tar_arch->fw->size < TAR_BLOCK_LEN) {
-		dev_err(dev, "Invalid tar archive %s ", tar_filename);
+		dev_err(dev, "Invalid tar archive %s\n", tar_filename);
 		goto release_tar_arch;
 	}
 
 	tar_size = tar_arch->fw->size;
 	tar_blk = (struct tar_blk_t *) tar_arch->fw->data;
 	if (strncmp(tar_blk->hdr.magic, TAR_MAGIC, TAR_MAGIC_LEN - 1)) {
-		dev_err(dev, "Unsupported format of tar archive %s",
+		dev_err(dev, "Unsupported format of tar archive %s\n",
 			tar_filename);
 		goto release_tar_arch;
 	}
@@ -437,7 +437,7 @@ static struct tar_arch_info_t *load_tar_archive(struct device *dev,
 
 		if (tar_offs + cur_size > tar_size ||
 		    tar_offs + 2*TAR_BLOCK_LEN > tar_size) {
-			dev_err(dev, "Invalid tar archive %s ", tar_filename);
+			dev_err(dev, "Invalid tar archive %s\n", tar_filename);
 			goto release_tar_arch;
 		}
 
@@ -458,7 +458,7 @@ static struct tar_arch_info_t *load_tar_archive(struct device *dev,
 
 		/* Check for the end of the archive */
 		if (tar_offs + 2*TAR_BLOCK_LEN > tar_size) {
-			dev_err(dev, "Invalid tar archive %s ", tar_filename);
+			dev_err(dev, "Invalid tar archive %s\n", tar_filename);
 			goto release_tar_arch;
 		}
 
@@ -563,13 +563,13 @@ static void print_engs_info(struct otx_cpt_eng_grp_info *eng_grp,
 
 static void print_ucode_dbg_info(struct otx_cpt_ucode *ucode)
 {
-	pr_debug("Ucode info");
-	pr_debug("Ucode version string %s", ucode->ver_str);
-	pr_debug("Ucode version %d.%d.%d.%d", ucode->ver_num.nn,
+	pr_debug("Ucode info\n");
+	pr_debug("Ucode version string %s\n", ucode->ver_str);
+	pr_debug("Ucode version %d.%d.%d.%d\n", ucode->ver_num.nn,
 		 ucode->ver_num.xx, ucode->ver_num.yy, ucode->ver_num.zz);
-	pr_debug("Ucode type %s", get_ucode_type_str(ucode->type));
-	pr_debug("Ucode size %d", ucode->size);
-	pr_debug("Ucode virt address %16.16llx", (u64)ucode->align_va);
+	pr_debug("Ucode type %s\n", get_ucode_type_str(ucode->type));
+	pr_debug("Ucode size %d\n", ucode->size);
+	pr_debug("Ucode virt address %16.16llx\n", (u64)ucode->align_va);
 	pr_debug("Ucode phys address %16.16llx\n", ucode->align_dma);
 }
 
@@ -600,19 +600,19 @@ static void print_dbg_info(struct device *dev,
 	u32 mask[4];
 	int i, j;
 
-	pr_debug("Engine groups global info");
-	pr_debug("max SE %d, max AE %d",
+	pr_debug("Engine groups global info\n");
+	pr_debug("max SE %d, max AE %d\n",
 		 eng_grps->avail.max_se_cnt, eng_grps->avail.max_ae_cnt);
-	pr_debug("free SE %d", eng_grps->avail.se_cnt);
-	pr_debug("free AE %d", eng_grps->avail.ae_cnt);
+	pr_debug("free SE %d\n", eng_grps->avail.se_cnt);
+	pr_debug("free AE %d\n", eng_grps->avail.ae_cnt);
 
 	for (i = 0; i < OTX_CPT_MAX_ENGINE_GROUPS; i++) {
 		grp = &eng_grps->grp[i];
-		pr_debug("engine_group%d, state %s", i, grp->is_enabled ?
+		pr_debug("engine_group%d, state %s\n", i, grp->is_enabled ?
 			 "enabled" : "disabled");
 		if (grp->is_enabled) {
 			mirrored_grp = &eng_grps->grp[grp->mirror.idx];
-			pr_debug("Ucode0 filename %s, version %s",
+			pr_debug("Ucode0 filename %s, version %s\n",
 				 grp->mirror.is_ena ?
 				 mirrored_grp->ucode[0].filename :
 				 grp->ucode[0].filename,
@@ -629,15 +629,15 @@ static void print_dbg_info(struct device *dev,
 				pr_debug("Slot%d: %s", j, engs_info);
 				bitmap_to_arr32(mask, engs->bmap,
 						eng_grps->engs_num);
-				pr_debug("Mask:  %8.8x %8.8x %8.8x %8.8x",
-					 mask[3], mask[2], mask[1], mask[0]);
+				pr_cont(" Mask: %8.8x %8.8x %8.8x %8.8x\n",
+					mask[3], mask[2], mask[1], mask[0]);
 			} else
-				pr_debug("Slot%d not used", j);
+				pr_debug("Slot%d not used\n", j);
 		}
 		if (grp->is_enabled) {
 			cpt_print_engines_mask(grp, dev, engs_mask,
 					       OTX_CPT_UCODE_NAME_LENGTH);
-			pr_debug("Cmask: %s", engs_mask);
+			pr_debug("Cmask: %s\n", engs_mask);
 		}
 	}
 }
@@ -766,7 +766,7 @@ static int check_engines_availability(struct device *dev,
 
 	if (avail_cnt < req_eng->count) {
 		dev_err(dev,
-			"Error available %s engines %d < than requested %d",
+			"Error available %s engines %d < than requested %d\n",
 			get_eng_type_str(req_eng->type),
 			avail_cnt, req_eng->count);
 		return -EBUSY;
@@ -867,7 +867,7 @@ static int copy_ucode_to_dma_mem(struct device *dev,
 				       OTX_CPT_UCODE_ALIGNMENT,
 				       &ucode->dma, GFP_KERNEL);
 	if (!ucode->va) {
-		dev_err(dev, "Unable to allocate space for microcode");
+		dev_err(dev, "Unable to allocate space for microcode\n");
 		return -ENOMEM;
 	}
 	ucode->align_va = PTR_ALIGN(ucode->va, OTX_CPT_UCODE_ALIGNMENT);
@@ -905,15 +905,15 @@ static int ucode_load(struct device *dev, struct otx_cpt_ucode *ucode,
 	ucode->size = ntohl(ucode_hdr->code_length) * 2;
 	if (!ucode->size || (fw->size < round_up(ucode->size, 16)
 	    + sizeof(struct otx_cpt_ucode_hdr) + OTX_CPT_UCODE_SIGN_LEN)) {
-		dev_err(dev, "Ucode %s invalid size", ucode_filename);
+		dev_err(dev, "Ucode %s invalid size\n", ucode_filename);
 		ret = -EINVAL;
 		goto release_fw;
 	}
 
 	ret = get_ucode_type(ucode_hdr, &ucode->type);
 	if (ret) {
-		dev_err(dev, "Microcode %s unknown type 0x%x", ucode->filename,
-			ucode->type);
+		dev_err(dev, "Microcode %s unknown type 0x%x\n",
+			ucode->filename, ucode->type);
 		goto release_fw;
 	}
 
@@ -1083,7 +1083,7 @@ static int eng_grp_update_masks(struct device *dev,
 			break;
 
 		default:
-			dev_err(dev, "Invalid engine type %d", engs->type);
+			dev_err(dev, "Invalid engine type %d\n", engs->type);
 			return -EINVAL;
 		}
 
@@ -1147,8 +1147,9 @@ static int delete_engine_group(struct device *dev,
 		for (i = 0; i < OTX_CPT_MAX_ENGINE_GROUPS; i++) {
 			if (eng_grp->g->grp[i].mirror.is_ena &&
 			    eng_grp->g->grp[i].mirror.idx == eng_grp->idx)
-				dev_err(dev, "engine_group%d", i);
+				pr_cont(" engine_group%d", i);
 		}
+		pr_cont("\n");
 		return -EINVAL;
 	}
 
@@ -1182,7 +1183,7 @@ static int validate_1_ucode_scenario(struct device *dev,
 		if (!otx_cpt_uc_supports_eng_type(&eng_grp->ucode[0],
 						  engs[i].type)) {
 			dev_err(dev,
-				"Microcode %s does not support %s engines",
+				"Microcode %s does not support %s engines\n",
 				eng_grp->ucode[0].filename,
 				get_eng_type_str(engs[i].type));
 			return -EINVAL;
@@ -1220,7 +1221,7 @@ static int create_engine_group(struct device *dev,
 	/* Validate if requested engine types are supported by this device */
 	for (i = 0; i < engs_cnt; i++)
 		if (!dev_supports_eng_type(eng_grps, engs[i].type)) {
-			dev_err(dev, "Device does not support %s engines",
+			dev_err(dev, "Device does not support %s engines\n",
 				get_eng_type_str(engs[i].type));
 			return -EPERM;
 		}
@@ -1228,7 +1229,7 @@ static int create_engine_group(struct device *dev,
 	/* Find engine group which is not used */
 	eng_grp = find_unused_eng_grp(eng_grps);
 	if (!eng_grp) {
-		dev_err(dev, "Error all engine groups are being used");
+		dev_err(dev, "Error all engine groups are being used\n");
 		return -ENOSPC;
 	}
 
@@ -1298,11 +1299,11 @@ static int create_engine_group(struct device *dev,
 	eng_grp->is_enabled = true;
 	if (eng_grp->mirror.is_ena)
 		dev_info(dev,
-			 "Engine_group%d: reuse microcode %s from group %d",
+			 "Engine_group%d: reuse microcode %s from group %d\n",
 			 eng_grp->idx, mirrored_eng_grp->ucode[0].ver_str,
 			 mirrored_eng_grp->idx);
 	else
-		dev_info(dev, "Engine_group%d: microcode loaded %s",
+		dev_info(dev, "Engine_group%d: microcode loaded %s\n",
 			 eng_grp->idx, eng_grp->ucode[0].ver_str);
 
 	return 0;
@@ -1412,14 +1413,14 @@ static ssize_t ucode_load_store(struct device *dev,
 	} else {
 		if (del_grp_idx < 0 ||
 		    del_grp_idx >= OTX_CPT_MAX_ENGINE_GROUPS) {
-			dev_err(dev, "Invalid engine group index %d",
+			dev_err(dev, "Invalid engine group index %d\n",
 				del_grp_idx);
 			ret = -EINVAL;
 			return ret;
 		}
 
 		if (!eng_grps->grp[del_grp_idx].is_enabled) {
-			dev_err(dev, "Error engine_group%d is not configured",
+			dev_err(dev, "Error engine_group%d is not configured\n",
 				del_grp_idx);
 			ret = -EINVAL;
 			return ret;
@@ -1568,7 +1569,7 @@ void otx_cpt_disable_all_cores(struct otx_cpt_device *cpt)
 		udelay(CSR_DELAY);
 		reg = readq(cpt->reg_base + OTX_CPT_PF_EXEC_BUSY);
 		if (timeout--) {
-			dev_warn(&cpt->pdev->dev, "Cores still busy");
+			dev_warn(&cpt->pdev->dev, "Cores still busy\n");
 			break;
 		}
 	}
@@ -1626,7 +1627,7 @@ int otx_cpt_init_eng_grps(struct pci_dev *pdev,
 			     eng_grps->avail.max_ae_cnt;
 	if (eng_grps->engs_num > OTX_CPT_MAX_ENGINES) {
 		dev_err(&pdev->dev,
-			"Number of engines %d > than max supported %d",
+			"Number of engines %d > than max supported %d\n",
 			eng_grps->engs_num, OTX_CPT_MAX_ENGINES);
 		ret = -EINVAL;
 		goto err;
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 06202bcffb33..60e744f680d3 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -1660,7 +1660,7 @@ int otx_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
 	case OTX_CPT_SE_TYPES:
 		count = atomic_read(&se_devices.count);
 		if (count >= CPT_MAX_VF_NUM) {
-			dev_err(&pdev->dev, "No space to add a new device");
+			dev_err(&pdev->dev, "No space to add a new device\n");
 			ret = -ENOSPC;
 			goto err;
 		}
@@ -1687,7 +1687,7 @@ int otx_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
 	case OTX_CPT_AE_TYPES:
 		count = atomic_read(&ae_devices.count);
 		if (count >= CPT_MAX_VF_NUM) {
-			dev_err(&pdev->dev, "No space to a add new device");
+			dev_err(&pdev->dev, "No space to a add new device\n");
 			ret = -ENOSPC;
 			goto err;
 		}
@@ -1728,7 +1728,7 @@ void otx_cpt_crypto_exit(struct pci_dev *pdev, struct module *mod,
 		}
 
 	if (!dev_found) {
-		dev_err(&pdev->dev, "%s device not found", __func__);
+		dev_err(&pdev->dev, "%s device not found\n", __func__);
 		goto exit;
 	}
 
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index a91860b5dc77..ce3168327a39 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -584,7 +584,7 @@ static irqreturn_t cptvf_done_intr_handler(int __always_unused irq,
 		cptvf_write_vq_done_ack(cptvf, intr);
 		wqe = get_cptvf_vq_wqe(cptvf, 0);
 		if (unlikely(!wqe)) {
-			dev_err(&pdev->dev, "No work to schedule for VF (%d)",
+			dev_err(&pdev->dev, "No work to schedule for VF (%d)\n",
 				cptvf->vfid);
 			return IRQ_NONE;
 		}
@@ -602,7 +602,7 @@ static void cptvf_set_irq_affinity(struct otx_cptvf *cptvf, int vec)
 	if (!zalloc_cpumask_var(&cptvf->affinity_mask[vec],
 				GFP_KERNEL)) {
 		dev_err(&pdev->dev,
-			"Allocation failed for affinity_mask for VF %d",
+			"Allocation failed for affinity_mask for VF %d\n",
 			cptvf->vfid);
 		return;
 	}
@@ -691,7 +691,7 @@ static ssize_t vf_engine_group_store(struct device *dev,
 		return -EINVAL;
 
 	if (val >= OTX_CPT_MAX_ENGINE_GROUPS) {
-		dev_err(dev, "Engine group >= than max available groups %d",
+		dev_err(dev, "Engine group >= than max available groups %d\n",
 			OTX_CPT_MAX_ENGINE_GROUPS);
 		return -EINVAL;
 	}
@@ -837,7 +837,7 @@ static int otx_cptvf_probe(struct pci_dev *pdev,
 			  cptvf_misc_intr_handler, 0, "CPT VF misc intr",
 			  cptvf);
 	if (err) {
-		dev_err(dev, "Failed to request misc irq");
+		dev_err(dev, "Failed to request misc irq\n");
 		goto free_vectors;
 	}
 
@@ -854,7 +854,7 @@ static int otx_cptvf_probe(struct pci_dev *pdev,
 	cptvf->cqinfo.qchunksize = OTX_CPT_CMD_QCHUNK_SIZE;
 	err = cptvf_sw_init(cptvf, OTX_CPT_CMD_QLEN, OTX_CPT_NUM_QS_PER_VF);
 	if (err) {
-		dev_err(dev, "cptvf_sw_init() failed");
+		dev_err(dev, "cptvf_sw_init() failed\n");
 		goto free_misc_irq;
 	}
 	/* Convey VQ LEN to PF */
@@ -946,7 +946,7 @@ static void otx_cptvf_remove(struct pci_dev *pdev)
 
 	/* Convey DOWN to PF */
 	if (otx_cptvf_send_vf_down(cptvf)) {
-		dev_err(&pdev->dev, "PF not responding to DOWN msg");
+		dev_err(&pdev->dev, "PF not responding to DOWN msg\n");
 	} else {
 		sysfs_remove_group(&pdev->dev.kobj, &otx_cptvf_sysfs_group);
 		otx_cpt_crypto_exit(pdev, THIS_MODULE, cptvf->vftype);
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
index df839b880354..239195cccf93 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
@@ -314,7 +314,7 @@ static int process_request(struct pci_dev *pdev, struct otx_cpt_req_info *req,
 							      GFP_ATOMIC;
 	ret = setup_sgio_list(pdev, &info, req, gfp);
 	if (unlikely(ret)) {
-		dev_err(&pdev->dev, "Setting up SG list failed");
+		dev_err(&pdev->dev, "Setting up SG list failed\n");
 		goto request_cleanup;
 	}
 	cpt_req->dlen = info->dlen;
@@ -410,17 +410,17 @@ int otx_cpt_do_request(struct pci_dev *pdev, struct otx_cpt_req_info *req,
 	struct otx_cptvf *cptvf = pci_get_drvdata(pdev);
 
 	if (!otx_cpt_device_ready(cptvf)) {
-		dev_err(&pdev->dev, "CPT Device is not ready");
+		dev_err(&pdev->dev, "CPT Device is not ready\n");
 		return -ENODEV;
 	}
 
 	if ((cptvf->vftype == OTX_CPT_SE_TYPES) && (!req->ctrl.s.se_req)) {
-		dev_err(&pdev->dev, "CPTVF-%d of SE TYPE got AE request",
+		dev_err(&pdev->dev, "CPTVF-%d of SE TYPE got AE request\n",
 			cptvf->vfid);
 		return -EINVAL;
 	} else if ((cptvf->vftype == OTX_CPT_AE_TYPES) &&
 		   (req->ctrl.s.se_req)) {
-		dev_err(&pdev->dev, "CPTVF-%d of AE TYPE got SE request",
+		dev_err(&pdev->dev, "CPTVF-%d of AE TYPE got SE request\n",
 			cptvf->vfid);
 		return -EINVAL;
 	}
@@ -461,7 +461,7 @@ static int cpt_process_ccode(struct pci_dev *pdev,
 		/* check for timeout */
 		if (time_after_eq(jiffies, cpt_info->time_in +
 				  OTX_CPT_COMMAND_TIMEOUT * HZ))
-			dev_warn(&pdev->dev, "Request timed out 0x%p", req);
+			dev_warn(&pdev->dev, "Request timed out 0x%p\n", req);
 		else if (cpt_info->extra_time < OTX_CPT_TIME_IN_RESET_COUNT) {
 			cpt_info->time_in = jiffies;
 			cpt_info->extra_time++;
-- 
2.20.1

