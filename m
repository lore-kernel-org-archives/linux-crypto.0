Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9ECFC46CA1
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Sep 2023 08:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbjIRIjM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Sep 2023 04:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240816AbjIRIjF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Sep 2023 04:39:05 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F36AA;
        Mon, 18 Sep 2023 01:38:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VsJFDGY_1695026333;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VsJFDGY_1695026333)
          by smtp.aliyun-inc.com;
          Mon, 18 Sep 2023 16:38:55 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] crypto: sm2 - Fix crash caused by uninitialized context
Date:   Mon, 18 Sep 2023 16:38:50 +0800
Message-Id: <20230918083850.84562-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In sm2_compute_z_digest() function, the newly allocated structure
mpi_ec_ctx is used, but forget to initialize it, which will cause
a crash when performing subsequent operations.

Fixes: e5221fa6a355 ("KEYS: asymmetric: Move sm2 code into x509_public_key")
Cc: stable@vger.kernel.org # v6.5
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/sm2.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/sm2.c b/crypto/sm2.c
index 285b3cb7c0bc..5ab120d74c59 100644
--- a/crypto/sm2.c
+++ b/crypto/sm2.c
@@ -278,10 +278,14 @@ int sm2_compute_z_digest(struct shash_desc *desc,
 	if (!ec)
 		return -ENOMEM;
 
-	err = __sm2_set_pub_key(ec, key, keylen);
+	err = sm2_ec_ctx_init(ec);
 	if (err)
 		goto out_free_ec;
 
+	err = __sm2_set_pub_key(ec, key, keylen);
+	if (err)
+		goto out_deinit_ec;
+
 	bits_len = SM2_DEFAULT_USERID_LEN * 8;
 	entl[0] = bits_len >> 8;
 	entl[1] = bits_len & 0xff;
-- 
2.24.3 (Apple Git-128)

