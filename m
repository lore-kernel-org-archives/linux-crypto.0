Return-Path: <SRS0=xDoY=XY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCB9C4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DACB821835
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569778366;
	bh=VHqFPei1l3XYQuzGwjYB6MtsKq7T/Rtc2e+h2ot99yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tzEoWtSuFEdHVNFYff/SJpR7CwZFaQjABgHYBuL++gOr3VgcXEVEBY+0dbF63OS/A
	 X6Goe3ZxpPaS4jT0jgaeGzDY0bUrkP9AltIQn2edpPyQLcHqsMbXntISdpa6+3FtvY
	 4y+kYTp6RPEhatgEZSThBq0btOwKqgSFjMZRNk1A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbfI2RcQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729690AbfI2RcN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Sep 2019 13:32:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D2A021906;
        Sun, 29 Sep 2019 17:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778332;
        bh=VHqFPei1l3XYQuzGwjYB6MtsKq7T/Rtc2e+h2ot99yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZ99K9rDMiD6+svrKZVZJl3eu0E/4zV20KF0IXwVXHnVdsj5uSwzsNOno3frUmcsS
         upNM5mCkqcCkwqO7np+HG2qVAI90Xjjodc5Ac7fllJCp4ymqjM1JeZu1PZaIb8+11E
         SKT3oZ0yP1emhMHb+rUThz4gVTzbgtNaTjb7J170=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunfeng Ye <yeyunfeng@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 41/49] crypto: hisilicon - Fix double free in sec_free_hw_sgl()
Date:   Sun, 29 Sep 2019 13:30:41 -0400
Message-Id: <20190929173053.8400-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit 24fbf7bad888767bed952f540ac963bc57e47e15 ]

There are two problems in sec_free_hw_sgl():

First, when sgl_current->next is valid, @hw_sgl will be freed in the
first loop, but it free again after the loop.

Second, sgl_current and sgl_current->next_sgl is not match when
dma_pool_free() is invoked, the third parameter should be the dma
address of sgl_current, but sgl_current->next_sgl is the dma address
of next chain, so use sgl_current->next_sgl is wrong.

Fix this by deleting the last dma_pool_free() in sec_free_hw_sgl(),
modifying the condition for while loop, and matching the address for
dma_pool_free().

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 02768af0dccdd..8c789b8671fc4 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -215,17 +215,18 @@ static void sec_free_hw_sgl(struct sec_hw_sgl *hw_sgl,
 			    dma_addr_t psec_sgl, struct sec_dev_info *info)
 {
 	struct sec_hw_sgl *sgl_current, *sgl_next;
+	dma_addr_t sgl_next_dma;
 
-	if (!hw_sgl)
-		return;
 	sgl_current = hw_sgl;
-	while (sgl_current->next) {
+	while (sgl_current) {
 		sgl_next = sgl_current->next;
-		dma_pool_free(info->hw_sgl_pool, sgl_current,
-			      sgl_current->next_sgl);
+		sgl_next_dma = sgl_current->next_sgl;
+
+		dma_pool_free(info->hw_sgl_pool, sgl_current, psec_sgl);
+
 		sgl_current = sgl_next;
+		psec_sgl = sgl_next_dma;
 	}
-	dma_pool_free(info->hw_sgl_pool, hw_sgl, psec_sgl);
 }
 
 static int sec_alg_skcipher_setkey(struct crypto_skcipher *tfm,
-- 
2.20.1

