Return-Path: <SRS0=gVpy=Y7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A21C5DF60
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Nov 2019 08:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD1AA2166E
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Nov 2019 08:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573116727;
	bh=D7fJbf/YlbzggoeKvmikXB4Uhwz5VXlZUeKI6QZk1lk=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=KsdcWeKMQ+EtfyHH9Hi+2VnIxZKg2xt6rnxjFmSsMD1pJ45R1rC12/BH7hcmSHFSH
	 lu+bUrk+2AtiInrV8wpgccgzNflM2ScgMovaXEfOD6WYNkRHljcv/fj8cAR+r9++O8
	 Ee+EWGq3zRHOFToOGp/buhs/NgLNJZAY445+TXbs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfKGIwG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbfKGIwG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Nov 2019 03:52:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8040A2077C;
        Thu,  7 Nov 2019 08:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573116723;
        bh=D7fJbf/YlbzggoeKvmikXB4Uhwz5VXlZUeKI6QZk1lk=;
        h=Date:From:To:Cc:Subject:From;
        b=Y9fiUz/eZanesu7evppYHgZE6pgFy/JCCk1xE455FY3Bfbn+B60edBsfjWMuO1t1F
         XaCIQLPBN53I4asESdV4mllWdjxye7FE4XM0oRT6Zy6uo/AEKP0avyVnUY6Gfxz1YH
         qWRtAREp30iJG/4BYxDf5TX1igsjGny2W8Bk/JGE=
Date:   Thu, 7 Nov 2019 09:52:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hisilicon: no need to check return value of
 debugfs_create functions
Message-ID: <20191107085200.GB1274176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Zhou Wang <wangzhou1@hisilicon.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/hisilicon/qm.c           | 19 +++++--------------
 drivers/crypto/hisilicon/zip/zip_main.c | 24 ++++++------------------
 2 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index f975c393a603..ed6f4c70bc19 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -963,13 +963,11 @@ static const struct file_operations qm_regs_fops = {
 
 static int qm_create_debugfs_file(struct hisi_qm *qm, enum qm_debug_file index)
 {
-	struct dentry *qm_d = qm->debug.qm_d, *tmp;
+	struct dentry *qm_d = qm->debug.qm_d;
 	struct debugfs_file *file = qm->debug.files + index;
 
-	tmp = debugfs_create_file(qm_debug_file_name[index], 0600, qm_d, file,
-				  &qm_debug_fops);
-	if (IS_ERR(tmp))
-		return -ENOENT;
+	debugfs_create_file(qm_debug_file_name[index], 0600, qm_d, file,
+			    &qm_debug_fops);
 
 	file->index = index;
 	mutex_init(&file->lock);
@@ -1780,12 +1778,10 @@ EXPORT_SYMBOL_GPL(hisi_qm_stop);
  */
 int hisi_qm_debug_init(struct hisi_qm *qm)
 {
-	struct dentry *qm_d, *qm_regs;
+	struct dentry *qm_d;
 	int i, ret;
 
 	qm_d = debugfs_create_dir("qm", qm->debug.debug_root);
-	if (IS_ERR(qm_d))
-		return -ENOENT;
 	qm->debug.qm_d = qm_d;
 
 	/* only show this in PF */
@@ -1796,12 +1792,7 @@ int hisi_qm_debug_init(struct hisi_qm *qm)
 				goto failed_to_create;
 			}
 
-	qm_regs = debugfs_create_file("qm_regs", 0444, qm->debug.qm_d, qm,
-				      &qm_regs_fops);
-	if (IS_ERR(qm_regs)) {
-		ret = -ENOENT;
-		goto failed_to_create;
-	}
+	debugfs_create_file("qm_regs", 0444, qm->debug.qm_d, qm, &qm_regs_fops);
 
 	return 0;
 
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 1b2ee96c888d..f203fa824912 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -511,7 +511,7 @@ static int hisi_zip_core_debug_init(struct hisi_zip_ctrl *ctrl)
 	struct hisi_qm *qm = &hisi_zip->qm;
 	struct device *dev = &qm->pdev->dev;
 	struct debugfs_regset32 *regset;
-	struct dentry *tmp_d, *tmp;
+	struct dentry *tmp_d;
 	char buf[HZIP_BUF_SIZE];
 	int i;
 
@@ -521,10 +521,6 @@ static int hisi_zip_core_debug_init(struct hisi_zip_ctrl *ctrl)
 		else
 			sprintf(buf, "decomp_core%d", i - HZIP_COMP_CORE_NUM);
 
-		tmp_d = debugfs_create_dir(buf, ctrl->debug_root);
-		if (!tmp_d)
-			return -ENOENT;
-
 		regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
 		if (!regset)
 			return -ENOENT;
@@ -533,9 +529,8 @@ static int hisi_zip_core_debug_init(struct hisi_zip_ctrl *ctrl)
 		regset->nregs = ARRAY_SIZE(hzip_dfx_regs);
 		regset->base = qm->io_base + core_offsets[i];
 
-		tmp = debugfs_create_regset32("regs", 0444, tmp_d, regset);
-		if (!tmp)
-			return -ENOENT;
+		tmp_d = debugfs_create_dir(buf, ctrl->debug_root);
+		debugfs_create_regset32("regs", 0444, tmp_d, regset);
 	}
 
 	return 0;
@@ -543,7 +538,6 @@ static int hisi_zip_core_debug_init(struct hisi_zip_ctrl *ctrl)
 
 static int hisi_zip_ctrl_debug_init(struct hisi_zip_ctrl *ctrl)
 {
-	struct dentry *tmp;
 	int i;
 
 	for (i = HZIP_CURRENT_QM; i < HZIP_DEBUG_FILE_NUM; i++) {
@@ -551,11 +545,9 @@ static int hisi_zip_ctrl_debug_init(struct hisi_zip_ctrl *ctrl)
 		ctrl->files[i].ctrl = ctrl;
 		ctrl->files[i].index = i;
 
-		tmp = debugfs_create_file(ctrl_debug_file_name[i], 0600,
-					  ctrl->debug_root, ctrl->files + i,
-					  &ctrl_debug_fops);
-		if (!tmp)
-			return -ENOENT;
+		debugfs_create_file(ctrl_debug_file_name[i], 0600,
+				    ctrl->debug_root, ctrl->files + i,
+				    &ctrl_debug_fops);
 	}
 
 	return hisi_zip_core_debug_init(ctrl);
@@ -569,8 +561,6 @@ static int hisi_zip_debugfs_init(struct hisi_zip *hisi_zip)
 	int ret;
 
 	dev_d = debugfs_create_dir(dev_name(dev), hzip_debugfs_root);
-	if (!dev_d)
-		return -ENOENT;
 
 	qm->debug.debug_root = dev_d;
 	ret = hisi_qm_debug_init(qm);
@@ -955,8 +945,6 @@ static void hisi_zip_register_debugfs(void)
 		return;
 
 	hzip_debugfs_root = debugfs_create_dir("hisi_zip", NULL);
-	if (IS_ERR_OR_NULL(hzip_debugfs_root))
-		hzip_debugfs_root = NULL;
 }
 
 static void hisi_zip_unregister_debugfs(void)
-- 
2.23.0

