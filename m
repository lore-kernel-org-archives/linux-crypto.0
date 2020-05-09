Return-Path: <SRS0=jzkg=6X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A66C28CBC
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 09:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63A61218AC
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 09:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEIJpY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 May 2020 05:45:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58018 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728172AbgEIJpW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 May 2020 05:45:22 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 403CB63452CDB3DB2E73;
        Sat,  9 May 2020 17:45:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 17:45:12 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v2 12/12] crypto: hisilicon/zip - Use temporary sqe when doing work
Date:   Sat, 9 May 2020 17:44:05 +0800
Message-ID: <1589017445-15514-13-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589017445-15514-1-git-send-email-tanshukun1@huawei.com>
References: <1589017445-15514-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Zhou Wang <wangzhou1@hisilicon.com>

Currently zip sqe is stored in hisi_zip_qp_ctx, which will bring corruption
with multiple parallel users of the crypto tfm.

This patch removes the zip_sqe in hisi_zip_qp_ctx and uses a temporary sqe
instead.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 369ec32..5fb9d4b 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -64,7 +64,6 @@ struct hisi_zip_req_q {
 
 struct hisi_zip_qp_ctx {
 	struct hisi_qp *qp;
-	struct hisi_zip_sqe zip_sqe;
 	struct hisi_zip_req_q req_q;
 	struct hisi_acc_sgl_pool *sgl_pool;
 	struct hisi_zip *zip_dev;
@@ -484,11 +483,11 @@ static struct hisi_zip_req *hisi_zip_create_req(struct acomp_req *req,
 static int hisi_zip_do_work(struct hisi_zip_req *req,
 			    struct hisi_zip_qp_ctx *qp_ctx)
 {
-	struct hisi_zip_sqe *zip_sqe = &qp_ctx->zip_sqe;
 	struct acomp_req *a_req = req->req;
 	struct hisi_qp *qp = qp_ctx->qp;
 	struct device *dev = &qp->qm->pdev->dev;
 	struct hisi_acc_sgl_pool *pool = qp_ctx->sgl_pool;
+	struct hisi_zip_sqe zip_sqe;
 	dma_addr_t input;
 	dma_addr_t output;
 	int ret;
@@ -511,13 +510,13 @@ static int hisi_zip_do_work(struct hisi_zip_req *req,
 	}
 	req->dma_dst = output;
 
-	hisi_zip_fill_sqe(zip_sqe, qp->req_type, input, output, a_req->slen,
+	hisi_zip_fill_sqe(&zip_sqe, qp->req_type, input, output, a_req->slen,
 			  a_req->dlen, req->sskip, req->dskip);
-	hisi_zip_config_buf_type(zip_sqe, HZIP_SGL);
-	hisi_zip_config_tag(zip_sqe, req->req_id);
+	hisi_zip_config_buf_type(&zip_sqe, HZIP_SGL);
+	hisi_zip_config_tag(&zip_sqe, req->req_id);
 
 	/* send command to start a task */
-	ret = hisi_qp_send(qp, zip_sqe);
+	ret = hisi_qp_send(qp, &zip_sqe);
 	if (ret < 0)
 		goto err_unmap_output;
 
-- 
2.7.4

