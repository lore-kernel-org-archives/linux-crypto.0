Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23097C282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF5DC20675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389310AbfDRNkb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:31 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33576 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389319AbfDRNkb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC32480D;
        Thu, 18 Apr 2019 06:40:30 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 506F93F5AF;
        Thu, 18 Apr 2019 06:40:29 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/35] crypto: ccree: use proper callback completion api
Date:   Thu, 18 Apr 2019 16:38:47 +0300
Message-Id: <20190418133913.9122-13-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use proper hash callback completion API instead of open coding it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_hash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index e824ab60b59c..8f15ce3deecd 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -286,7 +286,7 @@ static void cc_update_complete(struct device *dev, void *cc_req, int err)
 		cc_unmap_req(dev, state, ctx);
 	}
 
-	req->base.complete(&req->base, err);
+	ahash_request_complete(req, err);
 }
 
 static void cc_digest_complete(struct device *dev, void *cc_req, int err)
@@ -306,7 +306,7 @@ static void cc_digest_complete(struct device *dev, void *cc_req, int err)
 		cc_unmap_req(dev, state, ctx);
 	}
 
-	req->base.complete(&req->base, err);
+	ahash_request_complete(req, err);
 }
 
 static void cc_hash_complete(struct device *dev, void *cc_req, int err)
@@ -326,7 +326,7 @@ static void cc_hash_complete(struct device *dev, void *cc_req, int err)
 		cc_unmap_req(dev, state, ctx);
 	}
 
-	req->base.complete(&req->base, err);
+	ahash_request_complete(req, err);
 }
 
 static int cc_fin_result(struct cc_hw_desc *desc, struct ahash_request *req,
-- 
2.21.0

