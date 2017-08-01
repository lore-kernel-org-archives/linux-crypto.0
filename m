From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3] crypto: caam: Remove unused dentry members
Date: Tue,  1 Aug 2017 10:45:01 -0300
Message-ID: <1501595101-13919-1-git-send-email-festevam@gmail.com>
Cc: horia.geanta@nxp.com, linux-crypto@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35161 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdHANpI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 09:45:08 -0400
Received: by mail-qt0-f193.google.com with SMTP id t37so1569153qtg.2
        for <linux-crypto@vger.kernel.org>; Tue, 01 Aug 2017 06:45:08 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Most of the dentry members from structure caam_drv_private
are never used at all, so it is safe to remove them.

Since debugfs_remove_recursive() is called, we don't need the
file entries.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v2:
- Add missing space
Changes since v1:
- Remove all the unused dentry members (Horia)

 drivers/crypto/caam/ctrl.c   | 81 ++++++++++++++++----------------------------
 drivers/crypto/caam/intern.h |  8 -----
 drivers/crypto/caam/qi.c     |  6 ++--
 3 files changed, 32 insertions(+), 63 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 7338f15..dc65fed 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -734,59 +734,38 @@ static int caam_probe(struct platform_device *pdev)
 		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
 
 #ifdef CONFIG_DEBUG_FS
-
-	ctrlpriv->ctl_rq_dequeued =
-		debugfs_create_file("rq_dequeued",
-				    S_IRUSR | S_IRGRP | S_IROTH,
-				    ctrlpriv->ctl, &perfmon->req_dequeued,
-				    &caam_fops_u64_ro);
-	ctrlpriv->ctl_ob_enc_req =
-		debugfs_create_file("ob_rq_encrypted",
-				    S_IRUSR | S_IRGRP | S_IROTH,
-				    ctrlpriv->ctl, &perfmon->ob_enc_req,
-				    &caam_fops_u64_ro);
-	ctrlpriv->ctl_ib_dec_req =
-		debugfs_create_file("ib_rq_decrypted",
-				    S_IRUSR | S_IRGRP | S_IROTH,
-				    ctrlpriv->ctl, &perfmon->ib_dec_req,
-				    &caam_fops_u64_ro);
-	ctrlpriv->ctl_ob_enc_bytes =
-		debugfs_create_file("ob_bytes_encrypted",
-				    S_IRUSR | S_IRGRP | S_IROTH,
-				    ctrlpriv->ctl, &perfmon->ob_enc_bytes,
-				    &caam_fops_u64_ro);
-	ctrlpriv->ctl_ob_prot_bytes =
-		debugfs_create_file("ob_bytes_protected",
-				    S_IRUSR | S_IRGRP | S_IROTH,
-				    ctrlpriv->ctl, &perfmon->ob_prot_bytes,
-				    &caam_fops_u64_ro);
-	ctrlpriv->ctl_ib_dec_bytes =
-		debugfs_create_file("ib_bytes_decrypted",
-				    S_IRUSR | S_IRGRP | S_IROTH,
-				    ctrlpriv->ctl, &perfmon->ib_dec_bytes,
-				    &caam_fops_u64_ro);
-	ctrlpriv->ctl_ib_valid_bytes =
-		debugfs_create_file("ib_bytes_validated",
-				    S_IRUSR | S_IRGRP | S_IROTH,
-				    ctrlpriv->ctl, &perfmon->ib_valid_bytes,
-				    &caam_fops_u64_ro);
+	debugfs_create_file("rq_dequeued", S_IRUSR | S_IRGRP | S_IROTH,
+			    ctrlpriv->ctl, &perfmon->req_dequeued,
+			    &caam_fops_u64_ro);
+	debugfs_create_file("ob_rq_encrypted", S_IRUSR | S_IRGRP | S_IROTH,
+			    ctrlpriv->ctl, &perfmon->ob_enc_req,
+			    &caam_fops_u64_ro);
+	debugfs_create_file("ib_rq_decrypted", S_IRUSR | S_IRGRP | S_IROTH,
+			    ctrlpriv->ctl, &perfmon->ib_dec_req,
+			    &caam_fops_u64_ro);
+	debugfs_create_file("ob_bytes_encrypted", S_IRUSR | S_IRGRP | S_IROTH,
+			    ctrlpriv->ctl, &perfmon->ob_enc_bytes,
+			    &caam_fops_u64_ro);
+	debugfs_create_file("ob_bytes_protected", S_IRUSR | S_IRGRP | S_IROTH,
+			    ctrlpriv->ctl, &perfmon->ob_prot_bytes,
+			    &caam_fops_u64_ro);
+	debugfs_create_file("ib_bytes_decrypted", S_IRUSR | S_IRGRP | S_IROTH,
+			    ctrlpriv->ctl, &perfmon->ib_dec_bytes,
+			    &caam_fops_u64_ro);
+	debugfs_create_file("ib_bytes_validated", S_IRUSR | S_IRGRP | S_IROTH,
+			    ctrlpriv->ctl, &perfmon->ib_valid_bytes,
+			    &caam_fops_u64_ro);
 
 	/* Controller level - global status values */
-	ctrlpriv->ctl_faultaddr =
-		debugfs_create_file("fault_addr",
-				    S_IRUSR | S_IRGRP | S_IROTH,
-				    ctrlpriv->ctl, &perfmon->faultaddr,
-				    &caam_fops_u32_ro);
-	ctrlpriv->ctl_faultdetail =
-		debugfs_create_file("fault_detail",
-				    S_IRUSR | S_IRGRP | S_IROTH,
-				    ctrlpriv->ctl, &perfmon->faultdetail,
-				    &caam_fops_u32_ro);
-	ctrlpriv->ctl_faultstatus =
-		debugfs_create_file("fault_status",
-				    S_IRUSR | S_IRGRP | S_IROTH,
-				    ctrlpriv->ctl, &perfmon->status,
-				    &caam_fops_u32_ro);
+	debugfs_create_file("fault_addr", S_IRUSR | S_IRGRP | S_IROTH,
+			    ctrlpriv->ctl, &perfmon->faultaddr,
+			    &caam_fops_u32_ro);
+	debugfs_create_file("fault_detail", S_IRUSR | S_IRGRP | S_IROTH,
+			    ctrlpriv->ctl, &perfmon->faultdetail,
+			    &caam_fops_u32_ro);
+	debugfs_create_file("fault_status", S_IRUSR | S_IRGRP | S_IROTH,
+			    ctrlpriv->ctl, &perfmon->status,
+			    &caam_fops_u32_ro);
 
 	/* Internal covering keys (useful in non-secure mode only) */
 	ctrlpriv->ctl_kek_wrap.data = (__force void *)&ctrlpriv->ctrl->kek[0];
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 9e3f3e0..a523612 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -102,16 +102,8 @@ struct caam_drv_private {
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dfs_root;
 	struct dentry *ctl; /* controller dir */
-	struct dentry *ctl_rq_dequeued, *ctl_ob_enc_req, *ctl_ib_dec_req;
-	struct dentry *ctl_ob_enc_bytes, *ctl_ob_prot_bytes;
-	struct dentry *ctl_ib_dec_bytes, *ctl_ib_valid_bytes;
-	struct dentry *ctl_faultaddr, *ctl_faultdetail, *ctl_faultstatus;
-
 	struct debugfs_blob_wrapper ctl_kek_wrap, ctl_tkek_wrap, ctl_tdsk_wrap;
 	struct dentry *ctl_kek, *ctl_tkek, *ctl_tdsk;
-#ifdef CONFIG_CAAM_QI
-	struct dentry *qi_congested;
-#endif
 #endif
 };
 
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 9a4151a..e4cf000 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -791,10 +791,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
 	/* Done with the CGRs; restore the cpus allowed mask */
 	set_cpus_allowed_ptr(current, &old_cpumask);
 #ifdef CONFIG_DEBUG_FS
-	ctrlpriv->qi_congested = debugfs_create_file("qi_congested", 0444,
-						     ctrlpriv->ctl,
-						     &times_congested,
-						     &caam_fops_u64_ro);
+	debugfs_create_file("qi_congested", 0444, ctrlpriv->ctl,
+			    &times_congested, &caam_fops_u64_ro);
 #endif
 	dev_info(qidev, "Linux CAAM Queue I/F driver initialised\n");
 	return 0;
-- 
2.7.4
