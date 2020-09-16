Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED98C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 02:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C7820809
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 02:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIPC1v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 22:27:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12714 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgIPC1u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 22:27:50 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B2954665F4AF7498DE7E;
        Wed, 16 Sep 2020 10:27:48 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 10:27:41 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
CC:     <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH -next] crypto: qat - convert to use DEFINE_SEQ_ATTRIBUTE macro
Date:   Wed, 16 Sep 2020 10:50:17 +0800
Message-ID: <20200916025017.3992367-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use DEFINE_SEQ_ATTRIBUTE macro to simplify the code.

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 drivers/crypto/qat/qat_common/adf_cfg.c       | 19 +--------
 .../qat/qat_common/adf_transport_debug.c      | 42 ++-----------------
 2 files changed, 5 insertions(+), 56 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index ac462796cefc..22ae32838113 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -52,24 +52,7 @@ static const struct seq_operations qat_dev_cfg_sops = {
 	.show = qat_dev_cfg_show
 };
 
-static int qat_dev_cfg_open(struct inode *inode, struct file *file)
-{
-	int ret = seq_open(file, &qat_dev_cfg_sops);
-
-	if (!ret) {
-		struct seq_file *seq_f = file->private_data;
-
-		seq_f->private = inode->i_private;
-	}
-	return ret;
-}
-
-static const struct file_operations qat_dev_cfg_fops = {
-	.open = qat_dev_cfg_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release
-};
+DEFINE_SEQ_ATTRIBUTE(qat_dev_cfg);
 
 /**
  * adf_cfg_dev_add() - Create an acceleration device configuration table.
diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
index 2a2eccbf56ec..dac25ba47260 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -77,31 +77,14 @@ static void adf_ring_stop(struct seq_file *sfile, void *v)
 	mutex_unlock(&ring_read_lock);
 }
 
-static const struct seq_operations adf_ring_sops = {
+static const struct seq_operations adf_ring_debug_sops = {
 	.start = adf_ring_start,
 	.next = adf_ring_next,
 	.stop = adf_ring_stop,
 	.show = adf_ring_show
 };
 
-static int adf_ring_open(struct inode *inode, struct file *file)
-{
-	int ret = seq_open(file, &adf_ring_sops);
-
-	if (!ret) {
-		struct seq_file *seq_f = file->private_data;
-
-		seq_f->private = inode->i_private;
-	}
-	return ret;
-}
-
-static const struct file_operations adf_ring_debug_fops = {
-	.open = adf_ring_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release
-};
+DEFINE_SEQ_ATTRIBUTE(adf_ring_debug);
 
 int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
 {
@@ -188,31 +171,14 @@ static void adf_bank_stop(struct seq_file *sfile, void *v)
 	mutex_unlock(&bank_read_lock);
 }
 
-static const struct seq_operations adf_bank_sops = {
+static const struct seq_operations adf_bank_debug_sops = {
 	.start = adf_bank_start,
 	.next = adf_bank_next,
 	.stop = adf_bank_stop,
 	.show = adf_bank_show
 };
 
-static int adf_bank_open(struct inode *inode, struct file *file)
-{
-	int ret = seq_open(file, &adf_bank_sops);
-
-	if (!ret) {
-		struct seq_file *seq_f = file->private_data;
-
-		seq_f->private = inode->i_private;
-	}
-	return ret;
-}
-
-static const struct file_operations adf_bank_debug_fops = {
-	.open = adf_bank_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release
-};
+DEFINE_SEQ_ATTRIBUTE(adf_bank_debug);
 
 int adf_bank_debugfs_add(struct adf_etr_bank_data *bank)
 {
-- 
2.25.1

