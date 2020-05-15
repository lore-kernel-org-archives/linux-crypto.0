Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9222C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA1B32065C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgEOJPX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 05:15:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58012 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727861AbgEOJPW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 05:15:22 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AE982551CDF53B306D4F;
        Fri, 15 May 2020 17:15:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 15 May 2020 17:15:09 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 3/7] crypto: hisilicon/sec2 - add debugfs for Hisilicon SEC
Date:   Fri, 15 May 2020 17:13:56 +0800
Message-ID: <1589534040-50725-4-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589534040-50725-1-git-send-email-tanshukun1@huawei.com>
References: <1589534040-50725-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

Hisilicon SEC engine driver uses debugfs
to provides IO operation debug information

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 Documentation/ABI/testing/debugfs-hisi-sec | 54 ++++++++++++++++++++++++------
 drivers/crypto/hisilicon/sec2/sec.h        |  4 +++
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 15 +++++++--
 drivers/crypto/hisilicon/sec2/sec_main.c   | 43 ++++++++++++++++++++----
 4 files changed, 95 insertions(+), 21 deletions(-)

diff --git a/Documentation/ABI/testing/debugfs-hisi-sec b/Documentation/ABI/testing/debugfs-hisi-sec
index 54699a1..725c780 100644
--- a/Documentation/ABI/testing/debugfs-hisi-sec
+++ b/Documentation/ABI/testing/debugfs-hisi-sec
@@ -1,10 +1,4 @@
-What:           /sys/kernel/debug/hisi_sec/<bdf>/sec_dfx
-Date:           Oct 2019
-Contact:        linux-crypto@vger.kernel.org
-Description:    Dump the debug registers of SEC cores.
-		Only available for PF.
-
-What:           /sys/kernel/debug/hisi_sec/<bdf>/clear_enable
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/clear_enable
 Date:           Oct 2019
 Contact:        linux-crypto@vger.kernel.org
 Description:    Enabling/disabling of clear action after reading
@@ -12,7 +6,7 @@ Description:    Enabling/disabling of clear action after reading
 		0: disable, 1: enable.
 		Only available for PF, and take no other effect on SEC.
 
-What:           /sys/kernel/debug/hisi_sec/<bdf>/current_qm
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/current_qm
 Date:           Oct 2019
 Contact:        linux-crypto@vger.kernel.org
 Description:    One SEC controller has one PF and multiple VFs, each function
@@ -20,21 +14,21 @@ Description:    One SEC controller has one PF and multiple VFs, each function
 		qm refers to.
 		Only available for PF.
 
-What:           /sys/kernel/debug/hisi_sec/<bdf>/qm/qm_regs
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/qm_regs
 Date:           Oct 2019
 Contact:        linux-crypto@vger.kernel.org
 Description:    Dump of QM related debug registers.
 		Available for PF and VF in host. VF in guest currently only
 		has one debug register.
 
-What:           /sys/kernel/debug/hisi_sec/<bdf>/qm/current_q
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/current_q
 Date:           Oct 2019
 Contact:        linux-crypto@vger.kernel.org
 Description:    One QM of SEC may contain multiple queues. Select specific
 		queue to show its debug registers in above 'qm_regs'.
 		Only available for PF.
 
-What:           /sys/kernel/debug/hisi_sec/<bdf>/qm/clear_enable
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/clear_enable
 Date:           Oct 2019
 Contact:        linux-crypto@vger.kernel.org
 Description:    Enabling/disabling of clear action after reading
@@ -79,3 +73,41 @@ Contact:        linux-crypto@vger.kernel.org
 Description:    Dump the status of the QM.
 		Four states: initiated, started, stopped and closed.
 		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/sec_dfx/send_cnt
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the total number of sent requests.
+		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/sec_dfx/recv_cnt
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the total number of received requests.
+		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/sec_dfx/send_busy_cnt
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the total number of requests sent with returning busy.
+		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/sec_dfx/err_bd_cnt
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the total number of BD type error requests
+		to be received.
+		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/sec_dfx/invalid_req_cnt
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the total number of invalid requests being received.
+		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/sec_dfx/done_flag_cnt
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the total number of completed but marked error requests
+		to be received.
+		Available for both PF and VF, and take no other effect on SEC.
diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 2326634..7b64aca 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -160,6 +160,10 @@ struct sec_debug_file {
 struct sec_dfx {
 	atomic64_t send_cnt;
 	atomic64_t recv_cnt;
+	atomic64_t send_busy_cnt;
+	atomic64_t err_bd_cnt;
+	atomic64_t invalid_req_cnt;
+	atomic64_t done_flag_cnt;
 };
 
 struct sec_debug {
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 848ab49..64614a9 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -148,6 +148,7 @@ static int sec_aead_verify(struct sec_req *req)
 static void sec_req_cb(struct hisi_qp *qp, void *resp)
 {
 	struct sec_qp_ctx *qp_ctx = qp->qp_ctx;
+	struct sec_dfx *dfx = &qp_ctx->ctx->sec->debug.dfx;
 	struct sec_sqe *bd = resp;
 	struct sec_ctx *ctx;
 	struct sec_req *req;
@@ -157,11 +158,16 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 
 	type = bd->type_cipher_auth & SEC_TYPE_MASK;
 	if (unlikely(type != SEC_BD_TYPE2)) {
+		atomic64_inc(&dfx->err_bd_cnt);
 		pr_err("err bd type [%d]\n", type);
 		return;
 	}
 
 	req = qp_ctx->req_list[le16_to_cpu(bd->type2.tag)];
+	if (unlikely(!req)) {
+		atomic64_inc(&dfx->invalid_req_cnt);
+		return;
+	}
 	req->err_type = bd->type2.error_type;
 	ctx = req->ctx;
 	done = le16_to_cpu(bd->type2.done_flag) & SEC_DONE_MASK;
@@ -174,12 +180,13 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 			"err_type[%d],done[%d],flag[%d]\n",
 			req->err_type, done, flag);
 		err = -EIO;
+		atomic64_inc(&dfx->done_flag_cnt);
 	}
 
 	if (ctx->alg_type == SEC_AEAD && !req->c_req.encrypt)
 		err = sec_aead_verify(req);
 
-	atomic64_inc(&ctx->sec->debug.dfx.recv_cnt);
+	atomic64_inc(&dfx->recv_cnt);
 
 	ctx->req_op->buf_unmap(ctx, req);
 
@@ -200,10 +207,12 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
 		return -ENOBUFS;
 
 	if (!ret) {
-		if (req->fake_busy)
+		if (req->fake_busy) {
+			atomic64_inc(&ctx->sec->debug.dfx.send_busy_cnt);
 			ret = -EBUSY;
-		else
+		} else {
 			ret = -EINPROGRESS;
+		}
 	}
 
 	return ret;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index c3381f2..5ea44ad 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -88,6 +88,11 @@ struct sec_hw_error {
 	const char *msg;
 };
 
+struct sec_dfx_item {
+	const char *name;
+	u32 offset;
+};
+
 static const char sec_name[] = "hisi_sec2";
 static struct dentry *sec_debugfs_root;
 static struct hisi_qm_list sec_devices;
@@ -110,6 +115,15 @@ static const char * const sec_dbg_file_name[] = {
 	[SEC_CLEAR_ENABLE] = "clear_enable",
 };
 
+static struct sec_dfx_item sec_dfx_labels[] = {
+	{"send_cnt", offsetof(struct sec_dfx, send_cnt)},
+	{"recv_cnt", offsetof(struct sec_dfx, recv_cnt)},
+	{"send_busy_cnt", offsetof(struct sec_dfx, send_busy_cnt)},
+	{"err_bd_cnt", offsetof(struct sec_dfx, err_bd_cnt)},
+	{"invalid_req_cnt", offsetof(struct sec_dfx, invalid_req_cnt)},
+	{"done_flag_cnt", offsetof(struct sec_dfx, done_flag_cnt)},
+};
+
 static const struct debugfs_reg32 sec_dfx_regs[] = {
 	{"SEC_PF_ABNORMAL_INT_SOURCE    ",  0x301010},
 	{"SEC_SAA_EN                    ",  0x301270},
@@ -543,10 +557,22 @@ static const struct file_operations sec_dbg_fops = {
 static int sec_debugfs_atomic64_get(void *data, u64 *val)
 {
 	*val = atomic64_read((atomic64_t *)data);
+
+	return 0;
+}
+
+static int sec_debugfs_atomic64_set(void *data, u64 val)
+{
+	if (val)
+		return -EINVAL;
+
+	atomic64_set((atomic64_t *)data, 0);
+
 	return 0;
 }
+
 DEFINE_DEBUGFS_ATTRIBUTE(sec_atomic64_ops, sec_debugfs_atomic64_get,
-			 NULL, "%lld\n");
+			 sec_debugfs_atomic64_set, "%lld\n");
 
 static int sec_core_debug_init(struct sec_dev *sec)
 {
@@ -555,6 +581,7 @@ static int sec_core_debug_init(struct sec_dev *sec)
 	struct sec_dfx *dfx = &sec->debug.dfx;
 	struct debugfs_regset32 *regset;
 	struct dentry *tmp_d;
+	int i;
 
 	tmp_d = debugfs_create_dir("sec_dfx", sec->qm.debug.debug_root);
 
@@ -566,13 +593,15 @@ static int sec_core_debug_init(struct sec_dev *sec)
 	regset->nregs = ARRAY_SIZE(sec_dfx_regs);
 	regset->base = qm->io_base;
 
-	debugfs_create_regset32("regs", 0444, tmp_d, regset);
+	if (qm->pdev->device == SEC_PF_PCI_DEVICE_ID)
+		debugfs_create_regset32("regs", 0444, tmp_d, regset);
 
-	debugfs_create_file("send_cnt", 0444, tmp_d,
-			    &dfx->send_cnt, &sec_atomic64_ops);
-
-	debugfs_create_file("recv_cnt", 0444, tmp_d,
-			    &dfx->recv_cnt, &sec_atomic64_ops);
+	for (i = 0; i < ARRAY_SIZE(sec_dfx_labels); i++) {
+		atomic64_t *data = (atomic64_t *)((uintptr_t)dfx +
+					sec_dfx_labels[i].offset);
+		debugfs_create_file(sec_dfx_labels[i].name, 0644,
+				   tmp_d, data, &sec_atomic64_ops);
+	}
 
 	return 0;
 }
-- 
2.7.4

