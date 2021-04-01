Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1341CC433B4
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 07:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B23610CA
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 07:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhDAHUz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:20:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14661 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbhDAHUk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Apr 2021 03:20:40 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9vfG2VVNznWyN;
        Thu,  1 Apr 2021 15:17:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Thu, 1 Apr 2021 15:20:29 +0800
From:   Zhiqi Song <songzhiqi1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <fanghao11@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: [PATCH] crypto: api - fix coding style
Date:   Thu, 1 Apr 2021 15:20:49 +0800
Message-ID: <1617261649-35947-1-git-send-email-songzhiqi1@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixed following checkpatch error:
- do not use assignment in if condition
Fixed following checkpatch warning:
- prefer strscpy over strlcpy
- delete repeated word

Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
---
 crypto/api.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index c4eda56..624e653 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -115,7 +115,7 @@ struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
 	larval->alg.cra_priority = -1;
 	larval->alg.cra_destroy = crypto_larval_destroy;

-	strlcpy(larval->alg.cra_name, name, CRYPTO_MAX_ALG_NAME);
+	strscpy(larval->alg.cra_name, name, CRYPTO_MAX_ALG_NAME);
 	init_completion(&larval->completion);

 	return larval;
@@ -266,7 +266,7 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)

 	/*
 	 * If the internal flag is set for a cipher, require a caller to
-	 * to invoke the cipher with the internal flag to use that cipher.
+	 * invoke the cipher with the internal flag to use that cipher.
 	 * Also, if a caller wants to allocate a cipher that may or may
 	 * not be an internal cipher, use type | CRYPTO_ALG_INTERNAL and
 	 * !(mask & CRYPTO_ALG_INTERNAL).
@@ -359,9 +359,11 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 	if (err)
 		goto out_free_tfm;

-	if (!tfm->exit && alg->cra_init && (err = alg->cra_init(tfm)))
-		goto cra_init_failed;
-
+	if (!tfm->exit && alg->cra_init) {
+		err = alg->cra_init(tfm);
+		if (err)
+			goto cra_init_failed;
+	}
 	goto out;

 cra_init_failed:
@@ -458,9 +460,11 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 	if (err)
 		goto out_free_tfm;

-	if (!tfm->exit && alg->cra_init && (err = alg->cra_init(tfm)))
-		goto cra_init_failed;
-
+	if (!tfm->exit && alg->cra_init) {
+		err = alg->cra_init(tfm);
+		if (err)
+			goto cra_init_failed;
+	}
 	goto out;

 cra_init_failed:
--
2.7.4

