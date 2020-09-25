Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A8DC4741F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 14:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE93C208A9
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 14:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgIYOI7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 10:08:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47144 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728958AbgIYOI6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 10:08:58 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 549188A2292E46BAB632;
        Fri, 25 Sep 2020 22:08:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 22:08:49 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH RESEND 2/4] crypto: hisilicon/zip - fix zero length input in GZIP decompress
Date:   Fri, 25 Sep 2020 22:06:15 +0800
Message-ID: <1601042777-26150-3-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601042777-26150-1-git-send-email-shenyang39@huawei.com>
References: <1601042777-26150-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Zhou Wang <wangzhou1@hisilicon.com>

The zero length input will cause a call trace when use GZIP
decompress like this:
    Unable to handle kernel paging request at virtual address
    ...
    lr : get_gzip_head_size+0x7c/0xd0 [hisi_zip]

Judge the input length and return '-EINVAL' when input is invalid.

Fixes: 62c455ca853e("crypto: hisilicon - add HiSilicon ZIP...")
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 38f92d4..48dc2fd 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -454,7 +454,7 @@ static int add_comp_head(struct scatterlist *dst, u8 req_type)
 	return head_size;
 }
 
-static size_t get_gzip_head_size(struct scatterlist *sgl)
+static size_t __maybe_unused get_gzip_head_size(struct scatterlist *sgl)
 {
 	char buf[HZIP_GZIP_HEAD_BUF];
 
@@ -463,13 +463,20 @@ static size_t get_gzip_head_size(struct scatterlist *sgl)
 	return __get_gzip_head_size(buf);
 }
 
-static size_t get_comp_head_size(struct scatterlist *src, u8 req_type)
+static int  get_comp_head_size(struct acomp_req *acomp_req, u8 req_type)
 {
+	if (!acomp_req->src || !acomp_req->slen)
+		return -EINVAL;
+
+	if ((req_type == HZIP_ALG_TYPE_GZIP) &&
+	    (acomp_req->slen < GZIP_HEAD_FEXTRA_SHIFT))
+		return -EINVAL;
+
 	switch (req_type) {
 	case HZIP_ALG_TYPE_ZLIB:
 		return TO_HEAD_SIZE(HZIP_ALG_TYPE_ZLIB);
 	case HZIP_ALG_TYPE_GZIP:
-		return get_gzip_head_size(src);
+		return TO_HEAD_SIZE(HZIP_ALG_TYPE_GZIP);
 	default:
 		pr_err("request type does not support!\n");
 		return -EINVAL;
@@ -606,10 +613,14 @@ static int hisi_zip_adecompress(struct acomp_req *acomp_req)
 	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_DECOMP];
 	struct device *dev = &qp_ctx->qp->qm->pdev->dev;
 	struct hisi_zip_req *req;
-	size_t head_size;
-	int ret;
+	int head_size, ret;
 
-	head_size = get_comp_head_size(acomp_req->src, qp_ctx->qp->req_type);
+	head_size = get_comp_head_size(acomp_req, qp_ctx->qp->req_type);
+	if (head_size < 0) {
+		dev_err_ratelimited(dev, "failed to get comp head size (%d)!\n",
+				    head_size);
+		return head_size;
+	}
 
 	req = hisi_zip_create_req(acomp_req, qp_ctx, head_size, false);
 	if (IS_ERR(req))
-- 
2.7.4

