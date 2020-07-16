Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F237BC433E8
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 09:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D63F12071B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 09:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgGPJCn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:02:43 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726830AbgGPJCm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 05:02:42 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 667F23729D547BA16FCB;
        Thu, 16 Jul 2020 17:02:40 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 16 Jul 2020 17:02:36 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] crypto: allwinner - Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 16 Jul 2020 17:06:32 +0800
Message-ID: <20200716090632.14124-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Chen Huang <chenhuang5@huawei.com>

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 15 ++-------------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 15 ++-------------
 2 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 52c7785c0..3fe7fe698 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -279,7 +279,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 };
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
+static int sun8i_ce_debugfs_show(struct seq_file *seq, void *v)
 {
 	struct sun8i_ce_dev *ce = seq->private;
 	int i;
@@ -302,18 +302,7 @@ static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
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
-	.read_iter = seq_read_iter,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(sun8i_ce_debugfs);
 #endif
 
 static void sun8i_ce_free_chanlist(struct sun8i_ce_dev *ce, int i)
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index fde536469..6fe3e009c 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -263,7 +263,7 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 };
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
-static int sun8i_ss_dbgfs_read(struct seq_file *seq, void *v)
+static int sun8i_ss_debugfs_show(struct seq_file *seq, void *v)
 {
 	struct sun8i_ss_dev *ss = seq->private;
 	int i;
@@ -286,18 +286,7 @@ static int sun8i_ss_dbgfs_read(struct seq_file *seq, void *v)
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
-	.read_iter = seq_read_iter,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(sun8i_ss_debugfs);
 #endif
 
 static void sun8i_ss_free_flows(struct sun8i_ss_dev *ss, int i)
-- 
2.17.1

