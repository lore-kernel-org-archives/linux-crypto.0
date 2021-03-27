Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7DCC433E1
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 09:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A879661A28
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 09:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhC0J7E (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Mar 2021 05:59:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14500 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhC0J7B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Mar 2021 05:59:01 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F6vQ16wP7zyV56;
        Sat, 27 Mar 2021 17:56:57 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 17:58:50 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon/hpre - Add processing of src_data in 'CURVE25519'
Date:   Sat, 27 Mar 2021 17:56:16 +0800
Message-ID: <1616838976-31936-1-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

HPRE can only deal with src_data smaller than 'p' in 'CURVE25519'
algorithm, but 'rfc7748' says:
'Implementations MUST accept non-canonical values and process them as
if they had been reduced modulo the field prime'
So we get its modulus to p, and then deal it with HPRE.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index d743c54..f363653 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1729,6 +1729,17 @@ static int hpre_curve25519_msg_request_set(struct hpre_ctx *ctx,
 	return 0;
 }
 
+static void hpre_curve25519_src_modulo_p(u8 *ptr)
+{
+	int i;
+
+	for (i = 0; i < CURVE25519_KEY_SIZE - 1; i++)
+		ptr[i] = 0;
+
+	/* The modulus is ptr's last byte minus '0xed'(last byte of p) */
+	ptr[i] -= 0xed;
+}
+
 static int hpre_curve25519_src_init(struct hpre_asym_request *hpre_req,
 				    struct scatterlist *data, unsigned int len)
 {
@@ -1767,10 +1778,13 @@ static int hpre_curve25519_src_init(struct hpre_asym_request *hpre_req,
 	curve = ecc_get_curve25519();
 
 	fill_curve_param(p, curve->p, CURVE25519_KEY_SIZE, curve->g.ndigits);
-	if (memcmp(ptr, p, ctx->key_sz) >= 0) {
-		dev_err(dev, "gx is out of p!\n");
-		goto err;
-	}
+
+	/*
+	 * When src_data equals (2^255 - 19) ~  (2^255 - 1), it is out of p,
+	 * we get its modulus to p, and then use it.
+	 */
+	if (memcmp(ptr, p, ctx->key_sz) >= 0)
+		hpre_curve25519_src_modulo_p(ptr);
 
 	hpre_req->src = ptr;
 	msg->in = cpu_to_le64(dma);
-- 
2.8.1

