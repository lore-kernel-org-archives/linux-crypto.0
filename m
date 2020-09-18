Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D26C43463
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 01:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B81B3208C3
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 01:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgIRBan (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 21:30:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13278 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726185AbgIRBam (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 21:30:42 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A3F447BEBEFA84273856;
        Fri, 18 Sep 2020 09:30:40 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 09:30:33 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next v2] crypto: allwinner - Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Fri, 18 Sep 2020 09:31:08 +0800
Message-ID: <20200918013108.82558-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
v2: based on linux-next(20200917), and can be applied to
    mainline cleanly now.

 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 15 ++-------------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 15 ++-------------
 2 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 138759dc8..65ac1c360 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -283,7 +283,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 };
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
+static int sun8i_ce_debugfs_show(struct seq_file *seq, void *v)
 {
 	struct sun8i_ce_dev *ce = seq->private;
 	int i;
@@ -306,18 +306,7 @@ static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int sun8i_ce_dbgfs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, sun8i_ce_dbgfs_read, inode->i_private);
-}
-
-static const struct file_operations sun8i_ce_debugfs_fops = {
-	.owner = THIS_MODULE,
-	.open = sun8i_ce_dbgfs_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(sun8i_ce_debugfs);
 #endif
 
 static void sun8i_ce_free_chanlist(struct sun8i_ce_dev *ce, int i)
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 9a2351578..a27484d57 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -267,7 +267,7 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 };
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
-static int sun8i_ss_dbgfs_read(struct seq_file *seq, void *v)
+static int sun8i_ss_debugfs_show(struct seq_file *seq, void *v)
 {
 	struct sun8i_ss_dev *ss = seq->private;
 	int i;
@@ -290,18 +290,7 @@ static int sun8i_ss_dbgfs_read(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int sun8i_ss_dbgfs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, sun8i_ss_dbgfs_read, inode->i_private);
-}
-
-static const struct file_operations sun8i_ss_debugfs_fops = {
-	.owner = THIS_MODULE,
-	.open = sun8i_ss_dbgfs_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(sun8i_ss_debugfs);
 #endif
 
 static void sun8i_ss_free_flows(struct sun8i_ss_dev *ss, int i)
-- 
2.23.0

