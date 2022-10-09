Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0C0C433FE
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Oct 2022 09:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiJIJxP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Oct 2022 05:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiJIJxO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2022 05:53:14 -0400
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [221.176.66.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C211825C5E
        for <linux-crypto@vger.kernel.org>; Sun,  9 Oct 2022 02:53:10 -0700 (PDT)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.83])
        by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee563429a0447c-a7b4d;
        Sun, 09 Oct 2022 17:53:08 +0800 (CST)
X-RM-TRANSID: 2ee563429a0447c-a7b4d
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.103])
        by rmsmtp-syy-appsvrnew02-12027 (RichMail) with SMTP id 2efb634299f518f-345f5;
        Sun, 09 Oct 2022 17:53:07 +0800 (CST)
X-RM-TRANSID: 2efb634299f518f-345f5
From:   jianchunfu <jianchunfu@cmss.chinamobile.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org,
        jianchunfu <jianchunfu@cmss.chinamobile.com>
Subject: [PATCH] crypto: talitos - Use the defined variable to clean code
Date:   Sun,  9 Oct 2022 17:52:54 +0800
Message-Id: <20221009095254.2406-1-jianchunfu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the defined variable "dev" to make the code cleaner.

Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
---
 drivers/crypto/talitos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c9ad6c213..71db6450b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1999,7 +1999,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 		/* Buffer up to one whole block */
 		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
-			dev_err(ctx->dev, "Invalid number of src SG.\n");
+			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
 		sg_copy_to_buffer(areq->src, nents,
@@ -2040,7 +2040,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 			offset = nbytes_to_hash - req_ctx->nbuf;
 		nents = sg_nents_for_len(areq->src, offset);
 		if (nents < 0) {
-			dev_err(ctx->dev, "Invalid number of src SG.\n");
+			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
 		sg_copy_to_buffer(areq->src, nents,
@@ -2054,7 +2054,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	if (to_hash_later) {
 		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
-			dev_err(ctx->dev, "Invalid number of src SG.\n");
+			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
 		sg_pcopy_to_buffer(areq->src, nents,
-- 
2.18.4



