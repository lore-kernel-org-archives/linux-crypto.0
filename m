Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161B9C433E7
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 14:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE7F420829
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 14:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgIBOHf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 10:07:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10756 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727950AbgIBOHe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 10:07:34 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EE4697565B4170929968;
        Wed,  2 Sep 2020 22:07:29 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Wed, 2 Sep 2020
 22:07:20 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <dhowells@redhat.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <yuehaibing@huawei.com>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] crypto: pkcs7: Use match_string() helper to simplify the code
Date:   Wed, 2 Sep 2020 22:07:17 +0800
Message-ID: <20200902140717.30700-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

match_string() returns the array index of a matching string.
Use it instead of the open-coded implementation.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index ce49820caa97..0b4d07aa8811 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -141,11 +141,10 @@ int pkcs7_get_digest(struct pkcs7_message *pkcs7, const u8 **buf, u32 *len,
 	*buf = sinfo->sig->digest;
 	*len = sinfo->sig->digest_size;
 
-	for (i = 0; i < HASH_ALGO__LAST; i++)
-		if (!strcmp(hash_algo_name[i], sinfo->sig->hash_algo)) {
-			*hash_algo = i;
-			break;
-		}
+	i = match_string(hash_algo_name, HASH_ALGO__LAST,
+			 sinfo->sig->hash_algo);
+	if (i >= 0)
+		*hash_algo = i;
 
 	return 0;
 }
-- 
2.17.1


