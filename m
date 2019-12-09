Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018EBC43603
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 15:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C95E52077B
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 15:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575904916;
	bh=XU+EqYv6IRJZKcvr2xpcoM6aIIGJNwdJYny7W0MFY0c=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=UfLStQ34jnb6qfNoYWRRUpCJgqxNV6vc1PgwtkSJ2tY1FruP06LMZiC0nWVEw0Xmi
	 9CWsT/GiGTKWsnppX3rZhmkuOzfk71/fz5taiYKKI8Ux4LLljKCcJiTliE55vyiGP5
	 iAD3rFcFV8YK3rX5DpVUddw/kgeK5rKEBuaTVRj4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfLIPV4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 10:21:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfLIPV4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 10:21:56 -0500
Received: from localhost (unknown [89.205.132.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B3212068E;
        Mon,  9 Dec 2019 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575904915;
        bh=XU+EqYv6IRJZKcvr2xpcoM6aIIGJNwdJYny7W0MFY0c=;
        h=Date:From:To:Cc:Subject:From;
        b=TUegjVkm/gKG+NeiexIYp/CkYJ9GXYs92RwO+vXYqqYb1o1gqf1sLrQRFoIcmcXP9
         6NfYEk31/ZUnky4LvPiOQYTNaV4Eo9TUxHjZf8jhAWEgk+b6FpsAG/N8fiGJmIPbV5
         urapI+iA8dSLJFRGJUbngYwTGlSrv7An5QjXb91o=
Date:   Mon, 9 Dec 2019 16:21:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hisilicon - still no need to check return value of
 debugfs_create functions
Message-ID: <20191209152151.GA1282293@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Just like in 4a97bfc79619 ("crypto: hisilicon - no need to check return
value of debugfs_create functions"), there still is no need to ever
check the return value.  The function can work or not, but the code
logic should never do something different based on this.

Cc: Zhou Wang <wangzhou1@hisilicon.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 28 +++++------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 34e0424410bf..711f5d18b641 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -557,7 +557,7 @@ static const struct file_operations hpre_ctrl_debug_fops = {
 static int hpre_create_debugfs_file(struct hpre_debug *dbg, struct dentry *dir,
 				    enum hpre_ctrl_dbgfs_file type, int indx)
 {
-	struct dentry *tmp, *file_dir;
+	struct dentry *file_dir;
 
 	if (dir)
 		file_dir = dir;
@@ -571,10 +571,8 @@ static int hpre_create_debugfs_file(struct hpre_debug *dbg, struct dentry *dir,
 	dbg->files[indx].debug = dbg;
 	dbg->files[indx].type = type;
 	dbg->files[indx].index = indx;
-	tmp = debugfs_create_file(hpre_debug_file_name[type], 0600, file_dir,
-				  dbg->files + indx, &hpre_ctrl_debug_fops);
-	if (!tmp)
-		return -ENOENT;
+	debugfs_create_file(hpre_debug_file_name[type], 0600, file_dir,
+			    dbg->files + indx, &hpre_ctrl_debug_fops);
 
 	return 0;
 }
@@ -585,7 +583,6 @@ static int hpre_pf_comm_regs_debugfs_init(struct hpre_debug *debug)
 	struct hisi_qm *qm = &hpre->qm;
 	struct device *dev = &qm->pdev->dev;
 	struct debugfs_regset32 *regset;
-	struct dentry *tmp;
 
 	regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
 	if (!regset)
@@ -595,10 +592,7 @@ static int hpre_pf_comm_regs_debugfs_init(struct hpre_debug *debug)
 	regset->nregs = ARRAY_SIZE(hpre_com_dfx_regs);
 	regset->base = qm->io_base;
 
-	tmp = debugfs_create_regset32("regs", 0444,  debug->debug_root, regset);
-	if (!tmp)
-		return -ENOENT;
-
+	debugfs_create_regset32("regs", 0444,  debug->debug_root, regset);
 	return 0;
 }
 
@@ -609,15 +603,12 @@ static int hpre_cluster_debugfs_init(struct hpre_debug *debug)
 	struct device *dev = &qm->pdev->dev;
 	char buf[HPRE_DBGFS_VAL_MAX_LEN];
 	struct debugfs_regset32 *regset;
-	struct dentry *tmp_d, *tmp;
+	struct dentry *tmp_d;
 	int i, ret;
 
 	for (i = 0; i < HPRE_CLUSTERS_NUM; i++) {
 		sprintf(buf, "cluster%d", i);
-
 		tmp_d = debugfs_create_dir(buf, debug->debug_root);
-		if (!tmp_d)
-			return -ENOENT;
 
 		regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
 		if (!regset)
@@ -627,9 +618,7 @@ static int hpre_cluster_debugfs_init(struct hpre_debug *debug)
 		regset->nregs = ARRAY_SIZE(hpre_cluster_dfx_regs);
 		regset->base = qm->io_base + hpre_cluster_offsets[i];
 
-		tmp = debugfs_create_regset32("regs", 0444, tmp_d, regset);
-		if (!tmp)
-			return -ENOENT;
+		debugfs_create_regset32("regs", 0444, tmp_d, regset);
 		ret = hpre_create_debugfs_file(debug, tmp_d, HPRE_CLUSTER_CTRL,
 					       i + HPRE_CLUSTER_CTRL);
 		if (ret)
@@ -668,9 +657,6 @@ static int hpre_debugfs_init(struct hpre *hpre)
 	int ret;
 
 	dir = debugfs_create_dir(dev_name(dev), hpre_debugfs_root);
-	if (!dir)
-		return -ENOENT;
-
 	qm->debug.debug_root = dir;
 
 	ret = hisi_qm_debug_init(qm);
@@ -1014,8 +1000,6 @@ static void hpre_register_debugfs(void)
 		return;
 
 	hpre_debugfs_root = debugfs_create_dir(hpre_name, NULL);
-	if (IS_ERR_OR_NULL(hpre_debugfs_root))
-		hpre_debugfs_root = NULL;
 }
 
 static void hpre_unregister_debugfs(void)
-- 
2.24.0

