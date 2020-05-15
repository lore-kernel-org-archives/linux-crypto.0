Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CF8C433E2
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B9622065C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEOJPV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 05:15:21 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58002 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727785AbgEOJPV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 05:15:21 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A62CA196D944FB27EF97;
        Fri, 15 May 2020 17:15:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 15 May 2020 17:15:09 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 5/7] crypto: hisilicon/zip - add debugfs for Hisilicon ZIP
Date:   Fri, 15 May 2020 17:13:58 +0800
Message-ID: <1589534040-50725-6-git-send-email-tanshukun1@huawei.com>
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

From: Longfang Liu <liulongfang@huawei.com>

Hisilicon ZIP engine driver uses debugfs
to provides IO operation debug information

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 Documentation/ABI/testing/debugfs-hisi-zip | 26 ++++++++++++++
 drivers/crypto/hisilicon/zip/zip.h         |  8 +++++
 drivers/crypto/hisilicon/zip/zip_crypto.c  |  9 ++++-
 drivers/crypto/hisilicon/zip/zip_main.c    | 54 ++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/debugfs-hisi-zip b/Documentation/ABI/testing/debugfs-hisi-zip
index 1002a01..4832ba0 100644
--- a/Documentation/ABI/testing/debugfs-hisi-zip
+++ b/Documentation/ABI/testing/debugfs-hisi-zip
@@ -86,3 +86,29 @@ Contact:        linux-crypto@vger.kernel.org
 Description:    Dump the status of the QM.
 		Four states: initiated, started, stopped and closed.
 		Available for both PF and VF, and take no other effect on ZIP.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/zip_dfx/send_cnt
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the total number of sent requests.
+		Available for both PF and VF, and take no other effect on ZIP.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/zip_dfx/recv_cnt
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the total number of received requests.
+		Available for both PF and VF, and take no other effect on ZIP.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/zip_dfx/send_busy_cnt
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the total number of requests received
+		with returning busy.
+		Available for both PF and VF, and take no other effect on ZIP.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/zip_dfx/err_bd_cnt
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the total number of BD type error requests
+		to be received.
+		Available for both PF and VF, and take no other effect on ZIP.
diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index 82dc6f8..f3ed4c0e 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -28,12 +28,20 @@ enum hisi_zip_error_type {
 	HZIP_NC_ERR = 0x0d,
 };
 
+struct hisi_zip_dfx {
+	atomic64_t send_cnt;
+	atomic64_t recv_cnt;
+	atomic64_t send_busy_cnt;
+	atomic64_t err_bd_cnt;
+};
+
 struct hisi_zip_ctrl;
 
 struct hisi_zip {
 	struct hisi_qm qm;
 	struct list_head list;
 	struct hisi_zip_ctrl *ctrl;
+	struct hisi_zip_dfx dfx;
 };
 
 struct hisi_zip_sqe {
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 5fb9d4b..c73707c 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -332,6 +332,7 @@ static void hisi_zip_acomp_cb(struct hisi_qp *qp, void *data)
 {
 	struct hisi_zip_sqe *sqe = data;
 	struct hisi_zip_qp_ctx *qp_ctx = qp->qp_ctx;
+	struct hisi_zip_dfx *dfx = &qp_ctx->zip_dev->dfx;
 	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
 	struct hisi_zip_req *req = req_q->q + sqe->tag;
 	struct acomp_req *acomp_req = req->req;
@@ -339,12 +340,14 @@ static void hisi_zip_acomp_cb(struct hisi_qp *qp, void *data)
 	u32 status, dlen, head_size;
 	int err = 0;
 
+	atomic64_inc(&dfx->recv_cnt);
 	status = sqe->dw3 & HZIP_BD_STATUS_M;
 
 	if (status != 0 && status != HZIP_NC_ERR) {
 		dev_err(dev, "%scompress fail in qp%u: %u, output: %u\n",
 			(qp->alg_type == 0) ? "" : "de", qp->qp_id, status,
 			sqe->produced);
+		atomic64_inc(&dfx->err_bd_cnt);
 		err = -EIO;
 	}
 	dlen = sqe->produced;
@@ -487,6 +490,7 @@ static int hisi_zip_do_work(struct hisi_zip_req *req,
 	struct hisi_qp *qp = qp_ctx->qp;
 	struct device *dev = &qp->qm->pdev->dev;
 	struct hisi_acc_sgl_pool *pool = qp_ctx->sgl_pool;
+	struct hisi_zip_dfx *dfx = &qp_ctx->zip_dev->dfx;
 	struct hisi_zip_sqe zip_sqe;
 	dma_addr_t input;
 	dma_addr_t output;
@@ -516,9 +520,12 @@ static int hisi_zip_do_work(struct hisi_zip_req *req,
 	hisi_zip_config_tag(&zip_sqe, req->req_id);
 
 	/* send command to start a task */
+	atomic64_inc(&dfx->send_cnt);
 	ret = hisi_qp_send(qp, &zip_sqe);
-	if (ret < 0)
+	if (ret < 0) {
+		atomic64_inc(&dfx->send_busy_cnt);
 		goto err_unmap_output;
+	}
 
 	return -EINPROGRESS;
 
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 6161b10..cb3ed6b 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -99,6 +99,18 @@ struct hisi_zip_hw_error {
 	const char *msg;
 };
 
+struct zip_dfx_item {
+	const char *name;
+	u32 offset;
+};
+
+static struct zip_dfx_item zip_dfx_files[] = {
+	{"send_cnt", offsetof(struct hisi_zip_dfx, send_cnt)},
+	{"recv_cnt", offsetof(struct hisi_zip_dfx, recv_cnt)},
+	{"send_busy_cnt", offsetof(struct hisi_zip_dfx, send_busy_cnt)},
+	{"err_bd_cnt", offsetof(struct hisi_zip_dfx, err_bd_cnt)},
+};
+
 static const struct hisi_zip_hw_error zip_hw_error[] = {
 	{ .int_msk = BIT(0), .msg = "zip_ecc_1bitt_err" },
 	{ .int_msk = BIT(1), .msg = "zip_ecc_2bit_err" },
@@ -469,6 +481,27 @@ static const struct file_operations ctrl_debug_fops = {
 	.write = ctrl_debug_write,
 };
 
+
+static int zip_debugfs_atomic64_set(void *data, u64 val)
+{
+	if (val)
+		return -EINVAL;
+
+	atomic64_set((atomic64_t *)data, 0);
+
+	return 0;
+}
+
+static int zip_debugfs_atomic64_get(void *data, u64 *val)
+{
+	*val = atomic64_read((atomic64_t *)data);
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(zip_atomic64_ops, zip_debugfs_atomic64_get,
+			 zip_debugfs_atomic64_set, "%llu\n");
+
 static int hisi_zip_core_debug_init(struct hisi_zip_ctrl *ctrl)
 {
 	struct hisi_zip *hisi_zip = ctrl->hisi_zip;
@@ -500,6 +533,25 @@ static int hisi_zip_core_debug_init(struct hisi_zip_ctrl *ctrl)
 	return 0;
 }
 
+static void hisi_zip_dfx_debug_init(struct hisi_qm *qm)
+{
+	struct hisi_zip *zip = container_of(qm, struct hisi_zip, qm);
+	struct hisi_zip_dfx *dfx = &zip->dfx;
+	struct dentry *tmp_dir;
+	void *data;
+	int i;
+
+	tmp_dir = debugfs_create_dir("zip_dfx", qm->debug.debug_root);
+	for (i = 0; i < ARRAY_SIZE(zip_dfx_files); i++) {
+		data = (atomic64_t *)((uintptr_t)dfx + zip_dfx_files[i].offset);
+		debugfs_create_file(zip_dfx_files[i].name,
+			0644,
+			tmp_dir,
+			data,
+			&zip_atomic64_ops);
+	}
+}
+
 static int hisi_zip_ctrl_debug_init(struct hisi_zip_ctrl *ctrl)
 {
 	int i;
@@ -538,6 +590,8 @@ static int hisi_zip_debugfs_init(struct hisi_zip *hisi_zip)
 			goto failed_to_create;
 	}
 
+	hisi_zip_dfx_debug_init(qm);
+
 	return 0;
 
 failed_to_create:
-- 
2.7.4

