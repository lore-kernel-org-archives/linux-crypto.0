Return-Path: <SRS0=nOCY=3X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF72DC3524D
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 15:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966D021741
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 15:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgBCPpG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Feb 2020 10:45:06 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9683 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727230AbgBCPpG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Feb 2020 10:45:06 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8C5C6A26405F764AD096;
        Mon,  3 Feb 2020 23:44:57 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Mon, 3 Feb 2020 23:44:49 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sumit Semwal <sumit.semwal@linaro.org>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>,
        <kernel-janitors@vger.kernel.org>, "Hulk Robot" <hulkci@huawei.com>
Subject: [PATCH -next] crypto: ccree - remove set but not used variable 'du_size'
Date:   Mon, 3 Feb 2020 15:39:21 +0000
Message-ID: <20200203153921.45273-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/ccree/cc_cipher.c: In function 'cc_setup_state_desc':
drivers/crypto/ccree/cc_cipher.c:536:15: warning:
 variable 'du_size' set but not used [-Wunused-but-set-variable]

commit 5c83e8ec4d51 ("crypto: ccree - fix FDE descriptor sequence")
involved this unused variable, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/ccree/cc_cipher.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 7d6252d892d7..b5133f57bc87 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -533,14 +533,6 @@ static void cc_setup_state_desc(struct crypto_tfm *tfm,
 	int flow_mode = ctx_p->flow_mode;
 	int direction = req_ctx->gen_ctx.op_type;
 	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
-	unsigned int du_size = nbytes;
-
-	struct cc_crypto_alg *cc_alg =
-		container_of(tfm->__crt_alg, struct cc_crypto_alg,
-			     skcipher_alg.base);
-
-	if (cc_alg->data_unit)
-		du_size = cc_alg->data_unit;
 
 	switch (cipher_mode) {
 	case DRV_CIPHER_ECB:



