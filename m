Return-Path: <SRS0=tM/H=BE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA0BC433EB
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 06:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E15F2070E
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 06:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgGYGJe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Jul 2020 02:09:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33160 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726777AbgGYGJd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Jul 2020 02:09:33 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 82BC68468E2EBB040554;
        Sat, 25 Jul 2020 14:09:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 25 Jul 2020 14:09:21 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 2/4] crypto: hisilicon/zip - fix zero length input in GZIP decompress
Date:   Sat, 25 Jul 2020 14:06:48 +0800
Message-ID: <1595657210-3964-3-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595657210-3964-1-git-send-email-shenyang39@huawei.com>
References: <1595657210-3964-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Zhou Wang <wangzhou1@hisilicon.com>

The zero length input will cause a call trace when use GZIP decompress
like this:
	Unable to handle kernel paging request at virtual address
	...
	lr : get_gzip_head_size+0x7c/0xd0 [hisi_zip]

Judge the input length and return '-EINVAL' when input is invalid.

Fixes: 62c455ca853e("crypto: hisilicon - add HiSilicon ZIP...")
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 10b7adb..a1703eb 100644
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
+static int get_comp_head_size(struct acomp_req *acomp_req, u8 req_type)
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
 		pr_err("Request type does not support!\n");
 		return -EINVAL;
@@ -609,10 +616,15 @@ static int hisi_zip_adecompress(struct acomp_req *acomp_req)
 	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_DECOMP];
 	struct device *dev = &qp_ctx->qp->qm->pdev->dev;
 	struct hisi_zip_req *req;
-	size_t head_size;
+	int head_size;
 	int ret;

-	head_size = get_comp_head_size(acomp_req->src, qp_ctx->qp->req_type);
+	head_size = get_comp_head_size(acomp_req, qp_ctx->qp->req_type);
+	if (head_size < 0) {
+		dev_err_ratelimited(dev, "Get comp head size failed (%d)!\n",
+				    head_size);
+		return head_size;
+	}

 	req = hisi_zip_create_req(acomp_req, qp_ctx, head_size, false);
 	if (IS_ERR(req)) {
--
2.7.4

