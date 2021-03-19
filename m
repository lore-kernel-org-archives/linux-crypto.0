Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB91C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 07:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0392564E28
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 07:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbhCSHdJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Mar 2021 03:33:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13994 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbhCSHcz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Mar 2021 03:32:55 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F1wY96ldHzrYPc;
        Fri, 19 Mar 2021 15:30:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 15:32:39 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 4/4] crypto: hisilicon/zip - support new 'sqe' type in Kunpeng930
Date:   Fri, 19 Mar 2021 15:33:07 +0800
Message-ID: <1616139187-63425-5-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616139187-63425-1-git-send-email-shenyang39@huawei.com>
References: <1616139187-63425-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Kunpeng930 changes some field meanings in 'sqe'. So add a new
'hisi_zip_sqe_ops' to describe the 'sqe' operations.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip.h        |  1 +
 drivers/crypto/hisilicon/zip/zip_crypto.c | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index b4d3e03..517fdbd 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -75,6 +75,7 @@ struct hisi_zip_sqe {
 	u32 dw23;
 	u32 dw24;
 	u32 dw25;
+	/* tag: in sqe type 3 */
 	u32 dw26;
 	u32 dw27;
 	u32 rsvd1[4];
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 85dcf6a..4bd41a4 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -298,6 +298,11 @@ static void hisi_zip_fill_tag_v1(struct hisi_zip_sqe *sqe, struct hisi_zip_req *
 	sqe->dw13 = req->req_id;
 }
 
+static void hisi_zip_fill_tag_v2(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req)
+{
+	sqe->dw26 = req->req_id;
+}
+
 static void hisi_zip_fill_sqe_type(struct hisi_zip_sqe *sqe, u8 sqe_type)
 {
 	u32 val;
@@ -380,6 +385,11 @@ static u32 hisi_zip_get_tag_v1(struct hisi_zip_sqe *sqe)
 	return sqe->dw13;
 }
 
+static u32 hisi_zip_get_tag_v2(struct hisi_zip_sqe *sqe)
+{
+	return sqe->dw26;
+}
+
 static u32 hisi_zip_get_status(struct hisi_zip_sqe *sqe)
 {
 	return sqe->dw3 & HZIP_BD_STATUS_M;
@@ -527,6 +537,19 @@ const struct hisi_zip_sqe_ops hisi_zip_ops_v1 = {
 	.get_dstlen		= hisi_zip_get_dstlen,
 };
 
+const struct hisi_zip_sqe_ops hisi_zip_ops_v2 = {
+	.sqe_type		= 0x3,
+	.fill_addr		= hisi_zip_fill_addr,
+	.fill_buf_size		= hisi_zip_fill_buf_size,
+	.fill_buf_type		= hisi_zip_fill_buf_type,
+	.fill_req_type		= hisi_zip_fill_req_type,
+	.fill_tag		= hisi_zip_fill_tag_v2,
+	.fill_sqe_type		= hisi_zip_fill_sqe_type,
+	.get_tag		= hisi_zip_get_tag_v2,
+	.get_status		= hisi_zip_get_status,
+	.get_dstlen		= hisi_zip_get_dstlen,
+};
+
 static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int node)
 {
 	struct hisi_qp *qps[HZIP_CTX_Q_NUM] = { NULL };
@@ -560,6 +583,8 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 
 	if (hisi_zip->qm.ver < QM_HW_V3)
 		hisi_zip_ctx->ops = &hisi_zip_ops_v1;
+	else
+		hisi_zip_ctx->ops = &hisi_zip_ops_v2;
 
 	return 0;
 }
-- 
2.7.4

