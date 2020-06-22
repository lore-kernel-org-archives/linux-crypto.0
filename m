Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E52C433E3
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 06:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEAAE2076E
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 06:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbgFVGPR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 02:15:17 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:62533 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731211AbgFVGPR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 02:15:17 -0400
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 21 Jun 2020 23:15:16 -0700
Received: from sivaprak-linux.qualcomm.com ([10.201.3.202])
  by ironmsg03-sd.qualcomm.com with ESMTP; 21 Jun 2020 23:15:13 -0700
Received: by sivaprak-linux.qualcomm.com (Postfix, from userid 459349)
        id 0D624218C5; Mon, 22 Jun 2020 11:45:11 +0530 (IST)
From:   Sivaprakash Murugesan <sivaprak@codeaurora.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        stanimir.varbanov@linaro.org, ardb@kernel.org,
        sivaprak@codeaurora.org, cotequeiroz@gmail.com,
        ebiggers@google.com, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] crypto: qce: sha: Do not modify scatterlist passed along with request
Date:   Mon, 22 Jun 2020 11:45:06 +0530
Message-Id: <1592806506-23978-4-git-send-email-sivaprak@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592806506-23978-1-git-send-email-sivaprak@codeaurora.org>
References: <1592806506-23978-1-git-send-email-sivaprak@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Crypto test driver's test_ahash_speed calls crypto_ahash_update and
crypto_ahash_final APIs repeatedly for all the available test vector
buffer lengths.

if we mark the end for scatterlist based on the current vector size then
the subsequent vectors might fail if the later buffer lengths are higher.

To avoid this, in qce do not mark the end of scatterlist in update API,
the qce_ahash_async_req_handle API already takes care of this copying
right amount of buffer from the request scatter list.

Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>
---
 drivers/crypto/qce/sha.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 9e54a667d72f..c230843e2ffb 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -292,8 +292,6 @@ static int qce_ahash_update(struct ahash_request *req)
 	if (!sg_last)
 		return -EINVAL;
 
-	sg_mark_end(sg_last);
-
 	if (rctx->buflen) {
 		sg_init_table(rctx->sg, 2);
 		sg_set_buf(rctx->sg, rctx->tmpbuf, rctx->buflen);
-- 
2.7.4

