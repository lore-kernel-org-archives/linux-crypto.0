Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28738C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 19 May 2022 01:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiESBU7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 May 2022 21:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiESBU6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 May 2022 21:20:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A141532058;
        Wed, 18 May 2022 18:20:54 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L3X6F67D7zQkGC;
        Thu, 19 May 2022 09:17:57 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 09:20:52 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <keyrings@vger.kernel.org>
CC:     <linux-crypto@vger.kernel.org>, <davem@davemloft.net>,
        <dhowells@redhat.com>, <herbert@gondor.apana.org.au>,
        <gustavoars@kernel.org>, <keescook@chromium.org>,
        <linux-hardening@vger.kernel.org>
Subject: [PATCH v4] crypto: Use struct_size() helper with kmalloc()
Date:   Thu, 19 May 2022 09:19:18 +0800
Message-ID: <20220519011918.173538-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Make use of struct_size() helper for structures containing flexible array
member instead of sizeof() which prevents potential issues, as well as
increase readability.

Reference: https://lore.kernel.org/all/CAHk-=wiGWjxs7EVUpccZEi6esvjpHJdgHQ=vtUeJ5crL62hx9A@mail.gmail.com/

Signed-off-by: GUO Zihua <guozihua@huawei.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>

---

v4:
    Change subject from "in kmalloc" to "with kmalloc" following David's
suggestion. Added Kees' review-by.
v3:
    Update commit message according to Gustavo's review.
v2:
    Use size_add() helper following Kees Cook's suggestion.
---
 crypto/asymmetric_keys/asymmetric_type.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 41a2f0eb4ce4..e020222b1fe5 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -152,7 +152,7 @@ struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
 {
 	struct asymmetric_key_id *kid;
 
-	kid = kmalloc(sizeof(struct asymmetric_key_id) + len_1 + len_2,
+	kid = kmalloc(struct_size(kid, data, size_add(len_1, len_2)),
 		      GFP_KERNEL);
 	if (!kid)
 		return ERR_PTR(-ENOMEM);
@@ -244,7 +244,7 @@ struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id)
 	if (asciihexlen & 1)
 		return ERR_PTR(-EINVAL);
 
-	match_id = kmalloc(sizeof(struct asymmetric_key_id) + asciihexlen / 2,
+	match_id = kmalloc(struct_size(match_id, data, asciihexlen / 2),
 			   GFP_KERNEL);
 	if (!match_id)
 		return ERR_PTR(-ENOMEM);
-- 
2.36.0

