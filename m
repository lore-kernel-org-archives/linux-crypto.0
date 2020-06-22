Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D654FC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 06:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2FA92080C
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 06:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731211AbgFVGPU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 02:15:20 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:62533 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731231AbgFVGPS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 02:15:18 -0400
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 21 Jun 2020 23:15:16 -0700
Received: from sivaprak-linux.qualcomm.com ([10.201.3.202])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 21 Jun 2020 23:15:13 -0700
Received: by sivaprak-linux.qualcomm.com (Postfix, from userid 459349)
        id E301E218BE; Mon, 22 Jun 2020 11:45:11 +0530 (IST)
From:   Sivaprakash Murugesan <sivaprak@codeaurora.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        stanimir.varbanov@linaro.org, ardb@kernel.org,
        sivaprak@codeaurora.org, cotequeiroz@gmail.com,
        ebiggers@google.com, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] crypto: qce: re-initialize context on import
Date:   Mon, 22 Jun 2020 11:45:05 +0530
Message-Id: <1592806506-23978-3-git-send-email-sivaprak@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592806506-23978-1-git-send-email-sivaprak@codeaurora.org>
References: <1592806506-23978-1-git-send-email-sivaprak@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto testmgr deliberately corrupts the request context while passing
vectors to the import. This is to make sure that drivers do not rely on
request but they take all the necessary input from io vec passed to it.

qce casts the request context from request parameter, since it is corrupted
the sub squent hash request fails and qce hangs.

To avoid this re-initialize request context on import. The qce import
API alreasy takes care of taking the input vectors from passed io vec.

Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>
---
 drivers/crypto/qce/sha.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index ed82520203f9..9e54a667d72f 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -203,10 +203,18 @@ static int qce_import_common(struct ahash_request *req, u64 in_count,
 
 static int qce_ahash_import(struct ahash_request *req, const void *in)
 {
-	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
-	unsigned long flags = rctx->flags;
-	bool hmac = IS_SHA_HMAC(flags);
-	int ret = -EINVAL;
+	struct qce_sha_reqctx *rctx;
+	unsigned long flags;
+	bool hmac;
+	int ret;
+
+	ret = qce_ahash_init(req);
+	if (ret)
+		return ret;
+
+	rctx = ahash_request_ctx(req);
+	flags = rctx->flags;
+	hmac = IS_SHA_HMAC(flags);
 
 	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
 		const struct sha1_state *state = in;
-- 
2.7.4

