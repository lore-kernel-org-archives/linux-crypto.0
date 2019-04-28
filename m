Return-Path: <SRS0=IEBh=S6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFB8C43218
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 08:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0C95206BF
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 08:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfD1I3o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Apr 2019 04:29:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59386 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726530AbfD1I3o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Apr 2019 04:29:44 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AAD47B8DB16C0FEDA5A5;
        Sun, 28 Apr 2019 16:29:42 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Sun, 28 Apr 2019
 16:29:36 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <gilad@benyossef.com>, <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 -next] crypto: ccree - remove set but not used variable 'du_size'
Date:   Sun, 28 Apr 2019 16:28:27 +0800
Message-ID: <20190428082827.38184-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20190426151821.36944-1-yuehaibing@huawei.com>
References: <20190426151821.36944-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/ccree/cc_cipher.c: In function cc_setup_key_desc:
drivers/crypto/ccree/cc_cipher.c:645:15: warning: variable du_size set but not used [-Wunused-but-set-variable]

It is never used since introduction in
commit dd8486c75085 ("crypto: ccree - move key load desc. before flow desc.")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/ccree/cc_cipher.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index d9f8cd5..9116626 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -642,16 +642,8 @@ static void cc_setup_key_desc(struct crypto_tfm *tfm,
 	int direction = req_ctx->gen_ctx.op_type;
 	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
 	unsigned int key_len = ctx_p->keylen;
-	unsigned int du_size = nbytes;
 	unsigned int din_size;
 
-	struct cc_crypto_alg *cc_alg =
-		container_of(tfm->__crt_alg, struct cc_crypto_alg,
-			     skcipher_alg.base);
-
-	if (cc_alg->data_unit)
-		du_size = cc_alg->data_unit;
-
 	switch (cipher_mode) {
 	case DRV_CIPHER_CBC:
 	case DRV_CIPHER_CBC_CTS:
-- 
2.7.4


