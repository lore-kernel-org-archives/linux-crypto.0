Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A45C43461
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 08:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23AB721556
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 08:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgIGIZz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 04:25:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10781 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727943AbgIGIYj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 04:24:39 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D6AE1E99CC644FB78895;
        Mon,  7 Sep 2020 16:24:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Sep 2020 16:24:25 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v2 05/10] crypto: hisilicon/zip - use a enum parameter instead of some macros
Date:   Mon, 7 Sep 2020 16:21:57 +0800
Message-ID: <1599466922-10323-6-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599466922-10323-1-git-send-email-shenyang39@huawei.com>
References: <1599466922-10323-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Macros 'QPC_COMP', 'QPC_DECOMP' and 'HZIP_CTX_Q_NUM' are relative and
incremental. So, use an enum instead.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index aba1600..c2ea849 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -19,7 +19,6 @@
 #define GZIP_HEAD_FEXTRA_XLEN			2
 #define GZIP_HEAD_FHCRC_SIZE			2
 
-#define HZIP_CTX_Q_NUM				2
 #define HZIP_GZIP_HEAD_BUF			256
 #define HZIP_ALG_PRIORITY			300
 #define HZIP_SGL_SGE_NR				10
@@ -32,6 +31,12 @@ enum hisi_zip_alg_type {
 	HZIP_ALG_TYPE_DECOMP = 1,
 };
 
+enum {
+	HZIP_QPC_COMP,
+	HZIP_QPC_DECOMP,
+	HZIP_CTX_Q_NUM
+};
+
 #define COMP_NAME_TO_TYPE(alg_name)					\
 	(!strcmp((alg_name), "zlib-deflate") ? HZIP_ALG_TYPE_ZLIB :	\
 	 !strcmp((alg_name), "gzip") ? HZIP_ALG_TYPE_GZIP : 0)		\
@@ -71,8 +76,6 @@ struct hisi_zip_qp_ctx {
 };
 
 struct hisi_zip_ctx {
-#define QPC_COMP	0
-#define QPC_DECOMP	1
 	struct hisi_zip_qp_ctx qp_ctx[HZIP_CTX_Q_NUM];
 };
 
@@ -264,11 +267,11 @@ static int hisi_zip_create_req_q(struct hisi_zip_ctx *ctx)
 	return 0;
 
 err_free_loop1:
-	kfree(ctx->qp_ctx[QPC_DECOMP].req_q.req_bitmap);
+	kfree(ctx->qp_ctx[HZIP_QPC_DECOMP].req_q.req_bitmap);
 err_free_loop0:
-	kfree(ctx->qp_ctx[QPC_COMP].req_q.q);
+	kfree(ctx->qp_ctx[HZIP_QPC_COMP].req_q.q);
 err_free_bitmap:
-	kfree(ctx->qp_ctx[QPC_COMP].req_q.req_bitmap);
+	kfree(ctx->qp_ctx[HZIP_QPC_COMP].req_q.req_bitmap);
 	return ret;
 }
 
@@ -303,8 +306,8 @@ static int hisi_zip_create_sgl_pool(struct hisi_zip_ctx *ctx)
 	return 0;
 
 err_free_sgl_pool0:
-	hisi_acc_free_sgl_pool(&ctx->qp_ctx[QPC_COMP].qp->qm->pdev->dev,
-			       ctx->qp_ctx[QPC_COMP].sgl_pool);
+	hisi_acc_free_sgl_pool(&ctx->qp_ctx[HZIP_QPC_COMP].qp->qm->pdev->dev,
+			       ctx->qp_ctx[HZIP_QPC_COMP].sgl_pool);
 	return -ENOMEM;
 }
 
@@ -539,7 +542,7 @@ static int hisi_zip_do_work(struct hisi_zip_req *req,
 static int hisi_zip_acompress(struct acomp_req *acomp_req)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
-	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[QPC_COMP];
+	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_COMP];
 	struct hisi_zip_req *req;
 	int head_size;
 	int ret;
@@ -563,7 +566,7 @@ static int hisi_zip_acompress(struct acomp_req *acomp_req)
 static int hisi_zip_adecompress(struct acomp_req *acomp_req)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
-	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[QPC_DECOMP];
+	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_DECOMP];
 	struct hisi_zip_req *req;
 	size_t head_size;
 	int ret;
-- 
2.7.4

