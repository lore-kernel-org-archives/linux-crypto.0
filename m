Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7833CC282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 12:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DA0D20870
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 12:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfAWMAA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 07:00:00 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:40666 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbfAWMAA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 07:00:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 60E571848F;
        Wed, 23 Jan 2019 12:59:58 +0100 (CET)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id fKpqEWqeDFhx; Wed, 23 Jan 2019 12:59:51 +0100 (CET)
Received: from boulder03.se.axis.com (boulder03.se.axis.com [10.0.8.17])
        by bastet.se.axis.com (Postfix) with ESMTPS id D25CF18534;
        Wed, 23 Jan 2019 12:59:51 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB8D91E06A;
        Wed, 23 Jan 2019 12:59:51 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A05D01E064;
        Wed, 23 Jan 2019 12:59:51 +0100 (CET)
Received: from seth.se.axis.com (unknown [10.0.2.172])
        by boulder03.se.axis.com (Postfix) with ESMTP;
        Wed, 23 Jan 2019 12:59:51 +0100 (CET)
Received: from pc32929-1845.se.axis.com (pc32929-1845.se.axis.com [10.88.129.17])
        by seth.se.axis.com (Postfix) with ESMTP id 93BAC1CA2;
        Wed, 23 Jan 2019 12:59:51 +0100 (CET)
Received: by pc32929-1845.se.axis.com (Postfix, from userid 20456)
        id 9152D409B9; Wed, 23 Jan 2019 12:59:51 +0100 (CET)
From:   Lars Persson <lars.persson@axis.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Lars Persson <larper@axis.com>
Subject: [PATCH 4/7] crypto: axis - give DMA the start of the status buffer
Date:   Wed, 23 Jan 2019 12:59:43 +0100
Message-Id: <073bc24152ae5f27d7d27d8bec7f80dd9dce8b6f.1548243646.git.larper@axis.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
X-TM-AS-GCONF: 00
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver was optimized to only do cache maintenance for the last
word of the dma descriptor status array. Unfortunately an omission
also passed the last word as the address of the array start to the DMA
engine. In most cases this goes unnoticed since the hardware aligns
the address to a 64 byte boundary.

Signed-off-by: Lars Persson <larper@axis.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 675741067166..4936f8fb253a 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -665,8 +665,8 @@ artpec6_crypto_dma_map_descs(struct artpec6_crypto_req_common *common)
 	 * to be written.
 	 */
 	return artpec6_crypto_dma_map_single(common,
-				dma->stat + dma->in_cnt - 1,
-				sizeof(dma->stat[0]),
+				dma->stat,
+				sizeof(dma->stat[0]) * dma->in_cnt,
 				DMA_BIDIRECTIONAL,
 				&dma->stat_dma_addr);
 }
@@ -2087,9 +2087,12 @@ static void artpec6_crypto_task(unsigned long data)
 	list_for_each_entry_safe(req, n, &ac->pending, list) {
 		struct artpec6_crypto_dma_descriptors *dma = req->dma;
 		u32 stat;
+		dma_addr_t stataddr;
 
-		dma_sync_single_for_cpu(artpec6_crypto_dev, dma->stat_dma_addr,
-					sizeof(dma->stat[0]),
+		stataddr = dma->stat_dma_addr + 4 * (req->dma->in_cnt - 1);
+		dma_sync_single_for_cpu(artpec6_crypto_dev,
+					stataddr,
+					4,
 					DMA_BIDIRECTIONAL);
 
 		stat = req->dma->stat[req->dma->in_cnt-1];
-- 
2.11.0

