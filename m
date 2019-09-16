Return-Path: <SRS0=68iz=XL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B2DC49ED7
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 06:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 006AB20830
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 06:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbfIPGij (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Sep 2019 02:38:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51866 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729899AbfIPGij (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Sep 2019 02:38:39 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 169298D72D382489D566;
        Mon, 16 Sep 2019 14:38:36 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Mon, 16 Sep 2019
 14:38:25 +0800
To:     <wangzhou1@hisilicon.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Yunfeng Ye <yeyunfeng@huawei.com>
Subject: [PATCH] crypto: hisilicon - Fix return value check in
 hisi_zip_acompress()
Message-ID: <23be2eb5-8256-0c19-aef9-994974d11c9d@huawei.com>
Date:   Mon, 16 Sep 2019 14:38:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.251.225]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The return valude of add_comp_head() is int, but @head_size is size_t,
which is a unsigned type.

	size_t head_size;
	...
	if (head_size < 0)  // it will never work
		return -ENOMEM

Modify the type of @head_size to int, then change the type to size_t
when invoke hisi_zip_create_req() as a parameter.

Fixes: 62c455ca853e ("crypto: hisilicon - add HiSilicon ZIP accelerator support")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 5a3f84d..5902354 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -559,7 +559,7 @@ static int hisi_zip_acompress(struct acomp_req *acomp_req)
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
 	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[QPC_COMP];
 	struct hisi_zip_req *req;
-	size_t head_size;
+	int head_size;
 	int ret;

 	/* let's output compression head now */
@@ -567,7 +567,7 @@ static int hisi_zip_acompress(struct acomp_req *acomp_req)
 	if (head_size < 0)
 		return -ENOMEM;

-	req = hisi_zip_create_req(acomp_req, qp_ctx, head_size, true);
+	req = hisi_zip_create_req(acomp_req, qp_ctx, (size_t)head_size, true);
 	if (IS_ERR(req))
 		return PTR_ERR(req);

-- 
2.7.4.huawei.3

