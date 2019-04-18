Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E40EC282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 647352083D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389387AbfDRNlL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:41:11 -0400
Received: from foss.arm.com ([217.140.101.70]:33644 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388582AbfDRNlK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:41:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC0251688;
        Thu, 18 Apr 2019 06:41:09 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 809E83F5AF;
        Thu, 18 Apr 2019 06:41:08 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/35] crypto: ccree: zero out internal struct before use
Date:   Thu, 18 Apr 2019 16:38:54 +0300
Message-Id: <20190418133913.9122-20-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We did not zero out the internal struct before use causing problem
in some rare error code paths.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index ed306a612c0f..0fa676b5603c 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -2062,6 +2062,8 @@ static int cc_aead_encrypt(struct aead_request *req)
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2091,6 +2093,8 @@ static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 		goto out;
 	}
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2110,6 +2114,8 @@ static int cc_aead_decrypt(struct aead_request *req)
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2137,6 +2143,8 @@ static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 		goto out;
 	}
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2254,6 +2262,8 @@ static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
 		goto out;
 	}
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2277,6 +2287,8 @@ static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	//plaintext is not encryped with rfc4543
 	areq_ctx->plaintext_authenticate_only = true;
 
@@ -2309,6 +2321,8 @@ static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
 		goto out;
 	}
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2332,6 +2346,8 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	//plaintext is not decryped with rfc4543
 	areq_ctx->plaintext_authenticate_only = true;
 
-- 
2.21.0

