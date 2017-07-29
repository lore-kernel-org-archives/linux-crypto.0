From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: caam/qi - Remove unused 'qi_congested' entry
Date: Sat, 29 Jul 2017 19:55:01 -0300
Message-ID: <1501368901-8248-1-git-send-email-festevam@gmail.com>
Cc: horia.geanta@nxp.com, linux-crypto@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36832 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdG2WzK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Jul 2017 18:55:10 -0400
Received: by mail-qt0-f193.google.com with SMTP id c15so10248534qta.3
        for <linux-crypto@vger.kernel.org>; Sat, 29 Jul 2017 15:55:10 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

'qi_congested' member from structure caam_drv_private
is never used at all, so it is safe to remove it.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/crypto/caam/intern.h | 3 ---
 drivers/crypto/caam/qi.c     | 6 ++----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 9e3f3e0..9625b2d 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -109,9 +109,6 @@ struct caam_drv_private {
 
 	struct debugfs_blob_wrapper ctl_kek_wrap, ctl_tkek_wrap, ctl_tdsk_wrap;
 	struct dentry *ctl_kek, *ctl_tkek, *ctl_tdsk;
-#ifdef CONFIG_CAAM_QI
-	struct dentry *qi_congested;
-#endif
 #endif
 };
 
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 6d5a010..b2f7a42 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -793,10 +793,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
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
