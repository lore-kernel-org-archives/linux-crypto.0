Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2587C4360C
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 08:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81709218DE
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 08:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbfI3IwB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 04:52:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34362 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfI3IwB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 04:52:01 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A30C252865CFBFC00D0F;
        Mon, 30 Sep 2019 16:51:59 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Mon, 30 Sep 2019 16:51:50 +0800
From:   Tian Tao <tiantao6@huawei.com>
To:     <gilad@benyossef.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC:     <linuxarm@huawei.com>
Subject: [PATCH] crypto: fix comparison of unsigned expression warnings
Date:   Mon, 30 Sep 2019 16:49:21 +0800
Message-ID: <1569833361-47224-1-git-send-email-tiantao6@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes the following warnings:
drivers/crypto/ccree/cc_aead.c:630:5-12: WARNING: Unsigned expression
compared with zero: seq_len > 0

Signed-off-by: Tian Tao <tiantao6@huawei.com>
---
 drivers/crypto/ccree/cc_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index d3e8faa..b19291d 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -546,7 +546,7 @@ static int cc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct cc_crypto_req cc_req = {};
 	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
-	unsigned int seq_len = 0;
+	int seq_len = 0;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	const u8 *enckey, *authkey;
 	int rc;
-- 
2.7.4

