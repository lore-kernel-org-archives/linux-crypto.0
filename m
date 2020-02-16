Return-Path: <SRS0=RXXs=4E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E12C76199
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Feb 2020 09:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7E46206E2
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Feb 2020 09:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgBPJAM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Feb 2020 04:00:12 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:33926 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726269AbgBPJAL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Feb 2020 04:00:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Tq4U7hv_1581843593;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Tq4U7hv_1581843593)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 16 Feb 2020 16:59:54 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@kernel.org, pvanleeuwen@rambus.com, zohar@linux.ibm.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] crypto: testmgr - support test with different ciphertext per encryption
Date:   Sun, 16 Feb 2020 16:59:25 +0800
Message-Id: <20200216085928.108838-5-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216085928.108838-1-tianjia.zhang@linux.alibaba.com>
References: <20200216085928.108838-1-tianjia.zhang@linux.alibaba.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some asymmetric algorithms will get different ciphertext after
each encryption, such as SM2, and let testmgr support the testing
of such algorithms.

In struct akcipher_testvec, set c and c_size to be empty, skip
the comparison of the ciphertext, and compare the decrypted
plaintext with m to achieve the test purpose.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/testmgr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 82513b6b0abd..db9b5ac878e7 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3741,7 +3741,7 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 		pr_err("alg: akcipher: %s test failed. err %d\n", op, err);
 		goto free_all;
 	}
-	if (!vecs->siggen_sigver_test) {
+	if (!vecs->siggen_sigver_test && c) {
 		if (req->dst_len != c_size) {
 			pr_err("alg: akcipher: %s test failed. Invalid output len\n",
 			       op);
@@ -3772,6 +3772,11 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 		goto free_all;
 	}
 
+	if (!vecs->siggen_sigver_test && !c) {
+		c = outbuf_enc;
+		c_size = req->dst_len;
+	}
+
 	op = vecs->siggen_sigver_test ? "sign" : "decrypt";
 	if (WARN_ON(c_size > PAGE_SIZE))
 		goto free_all;
-- 
2.17.1

