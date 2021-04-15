Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C22C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Apr 2021 10:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DBDF61029
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Apr 2021 10:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhDOKHA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:07:00 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:11327 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhDOKHA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Apr 2021 06:07:00 -0400
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 13FA6QAR023909;
        Thu, 15 Apr 2021 03:06:27 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        davem@davemloft.net
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH] chelsio/chcr: Remove useless MODULE_VERSION
Date:   Thu, 15 Apr 2021 15:36:07 +0530
Message-Id: <20210415100607.422838-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

kernel version describes module state more accurately.
hence remove chcr versioning.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c | 3 +--
 drivers/crypto/chelsio/chcr_core.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index f91f9d762a45..12fdae41a967 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -184,7 +184,7 @@ static void *chcr_uld_add(const struct cxgb4_lld_info *lld)
 	struct uld_ctx *u_ctx;
 
 	/* Create the device and add it in the device list */
-	pr_info_once("%s - version %s\n", DRV_DESC, DRV_VERSION);
+	pr_info_once("%s\n", DRV_DESC);
 	if (!(lld->ulp_crypto & ULP_CRYPTO_LOOKASIDE))
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -309,4 +309,3 @@ module_exit(chcr_crypto_exit);
 MODULE_DESCRIPTION("Crypto Co-processor for Chelsio Terminator cards.");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Chelsio Communications");
-MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index b02f981e7c32..f7c8bb95a71b 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -44,7 +44,6 @@
 #include "cxgb4_uld.h"
 
 #define DRV_MODULE_NAME "chcr"
-#define DRV_VERSION "1.0.0.0-ko"
 #define DRV_DESC "Chelsio T6 Crypto Co-processor Driver"
 
 #define MAX_PENDING_REQ_TO_HW 20
-- 
2.30.2

