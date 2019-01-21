Return-Path: <SRS0=ru6j=P5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3087C282DB
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 07:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA2B82084A
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 07:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbfAUHvT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:51:19 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:2281 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfAUHvT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Jan 2019 02:51:19 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2A6C61E3DAC6B4FCC9DA;
        Mon, 21 Jan 2019 15:51:17 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.408.0; Mon, 21 Jan 2019 15:51:09 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] crypto: seqiv - Use kmemdup in seqiv_aead_encrypt()
Date:   Mon, 21 Jan 2019 07:57:00 +0000
Message-ID: <1548057420-140382-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use kmemdup rather than duplicating its implementation

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 crypto/seqiv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 64a412b..ed1b0e9 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -89,13 +89,12 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 
 	if (unlikely(!IS_ALIGNED((unsigned long)info,
 				 crypto_aead_alignmask(geniv) + 1))) {
-		info = kmalloc(ivsize, req->base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
-								  GFP_ATOMIC);
+		info = kmemdup(req->iv, ivsize, req->base.flags &
+			       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+			       GFP_ATOMIC);
 		if (!info)
 			return -ENOMEM;
 
-		memcpy(info, req->iv, ivsize);
 		compl = seqiv_aead_encrypt_complete;
 		data = req;
 	}



