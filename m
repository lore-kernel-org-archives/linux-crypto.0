Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B0FC4741F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 14:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BEE621741
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 14:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgIYOI7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 10:08:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47128 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728960AbgIYOI6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 10:08:58 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4C74C18A179F095326D6;
        Fri, 25 Sep 2020 22:08:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 22:08:50 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH RESEND 3/4] crypto: hisilicon/zip - fix the return value when device is busy
Date:   Fri, 25 Sep 2020 22:06:16 +0800
Message-ID: <1601042777-26150-4-git-send-email-shenyang39@huawei.com>
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

As before, when the ZIP device is too busy to creat a request, it will
return '-EBUSY'. But the crypto process think the '-EBUSY' means a
successful request and wait for its completion.

So replace '-EBUSY' with '-EAGAIN' to show crypto this request is failed.

Fixes: 62c455ca853e("crypto: hisilicon - add HiSilicon ZIP...")
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 48dc2fd..08b4660 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -498,7 +498,7 @@ static struct hisi_zip_req *hisi_zip_create_req(struct acomp_req *req,
 	if (req_id >= req_q->size) {
 		write_unlock(&req_q->req_lock);
 		dev_dbg(&qp_ctx->qp->qm->pdev->dev, "req cache is full!\n");
-		return ERR_PTR(-EBUSY);
+		return ERR_PTR(-EAGAIN);
 	}
 	set_bit(req_id, req_q->req_bitmap);
 
@@ -564,6 +564,7 @@ static int hisi_zip_do_work(struct hisi_zip_req *req,
 	ret = hisi_qp_send(qp, &zip_sqe);
 	if (ret < 0) {
 		atomic64_inc(&dfx->send_busy_cnt);
+		ret = -EAGAIN;
 		dev_dbg_ratelimited(dev, "failed to send request!\n");
 		goto err_unmap_output;
 	}
-- 
2.7.4

