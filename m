Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FE6C433B4
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 20:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 968DA6108F
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 20:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbhDAUDY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Apr 2021 16:03:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45358 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235416AbhDAUDU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Apr 2021 16:03:20 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lRzFP-0000Nl-Ob; Thu, 01 Apr 2021 15:28:39 +0000
From:   Colin King <colin.king@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] crypto: sa2ul: Fix memory leak of rxd
Date:   Thu,  1 Apr 2021 16:28:39 +0100
Message-Id: <20210401152839.2016363-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two error return paths that are not freeing rxd and causing
memory leaks.  Fix these.

Addresses-Coverity: ("Resource leak")
Fixes: 00c9211f60db ("crypto: sa2ul - Fix DMA mapping API usage")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Fix typo in $SUBJECT

---
 drivers/crypto/sa2ul.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index f300b0a5958a..ca7484aac727 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1146,8 +1146,10 @@ static int sa_run(struct sa_req *req)
 		mapped_sg->sgt.sgl = src;
 		mapped_sg->sgt.orig_nents = src_nents;
 		ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
-		if (ret)
+		if (ret) {
+			kfree(rxd);
 			return ret;
+		}
 
 		mapped_sg->dir = dir_src;
 		mapped_sg->mapped = true;
@@ -1155,8 +1157,10 @@ static int sa_run(struct sa_req *req)
 		mapped_sg->sgt.sgl = req->src;
 		mapped_sg->sgt.orig_nents = sg_nents;
 		ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
-		if (ret)
+		if (ret) {
+			kfree(rxd);
 			return ret;
+		}
 
 		mapped_sg->dir = dir_src;
 		mapped_sg->mapped = true;
-- 
2.30.2

