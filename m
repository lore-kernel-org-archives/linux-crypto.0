Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76E2C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 03:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6232664E32
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 03:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhBWDpC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:45:02 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13368 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbhBWDpB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Feb 2021 22:45:01 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Dl4cy2wR8z7nmH;
        Tue, 23 Feb 2021 11:42:42 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Tue, 23 Feb 2021
 11:44:16 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: testmgr - delete some redundant code
Date:   Tue, 23 Feb 2021 11:42:04 +0800
Message-ID: <1614051724-31694-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Delete sg_data function, because sg_data function definition same as
sg_virt(), so need to delete it and use sg_virt() replace to sg_data().

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 crypto/testmgr.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9335999..e13e73c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1168,11 +1168,6 @@ static inline int check_shash_op(const char *op, int err,
 	return err;
 }
 
-static inline const void *sg_data(struct scatterlist *sg)
-{
-	return page_address(sg_page(sg)) + sg->offset;
-}
-
 /* Test one hash test vector in one configuration, using the shash API */
 static int test_shash_vec_cfg(const struct hash_testvec *vec,
 			      const char *vec_name,
@@ -1230,7 +1225,7 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
 			return 0;
 		if (cfg->nosimd)
 			crypto_disable_simd_for_test();
-		err = crypto_shash_digest(desc, sg_data(&tsgl->sgl[0]),
+		err = crypto_shash_digest(desc, sg_virt(&tsgl->sgl[0]),
 					  tsgl->sgl[0].length, result);
 		if (cfg->nosimd)
 			crypto_reenable_simd_for_test();
@@ -1266,7 +1261,7 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
 		    cfg->finalization_type == FINALIZATION_TYPE_FINUP) {
 			if (divs[i]->nosimd)
 				crypto_disable_simd_for_test();
-			err = crypto_shash_finup(desc, sg_data(&tsgl->sgl[i]),
+			err = crypto_shash_finup(desc, sg_virt(&tsgl->sgl[i]),
 						 tsgl->sgl[i].length, result);
 			if (divs[i]->nosimd)
 				crypto_reenable_simd_for_test();
@@ -1278,7 +1273,7 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
 		}
 		if (divs[i]->nosimd)
 			crypto_disable_simd_for_test();
-		err = crypto_shash_update(desc, sg_data(&tsgl->sgl[i]),
+		err = crypto_shash_update(desc, sg_virt(&tsgl->sgl[i]),
 					  tsgl->sgl[i].length);
 		if (divs[i]->nosimd)
 			crypto_reenable_simd_for_test();
-- 
2.8.1

