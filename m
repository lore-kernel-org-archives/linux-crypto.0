Return-Path: <SRS0=71ZY=QE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA70C282CD
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 17:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 216AC2148E
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696780;
	bh=74ShYMUvNa6XztpuXX1dwopiHNcWA5LMFoH+zlnCFH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=un8ohGOsRn8Tu3iejGhAnA7bNpZkCRcJWaivz1WDy6H/vmBMlmy0262EY4C5Dvh/d
	 dXJKf0vR+ac8pgz2pgwgy5xqL9WBo45tcZesu5SfHxqv6PMmOJm95kq4owdTHm0KcN
	 NtjBqbpEONqSQ0w3RbFtBeZ/BEn/6JiNKcBcayBc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfA1Rcx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 12:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728751AbfA1P5L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 10:57:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 793EE20881;
        Mon, 28 Jan 2019 15:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691030;
        bh=74ShYMUvNa6XztpuXX1dwopiHNcWA5LMFoH+zlnCFH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JI34s1Cn9Es3yRwW4AvTb7BkH1wrO4IZ5/tzS7Fl08R7ZeLiVZnjUX1mY4Ax+SzrY
         I+qWUImGcM0P3eVKaoMmdkQmTFPHUn9+lzsSFimJ+tuiHQfL/UEXApZpAalbl5p/n2
         4MeiNZJQSG+mfTyVfoX39LwGd0HYvRy0NiM0DMWE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 267/304] crypto: ux500 - Use proper enum in hash_set_dma_transfer
Date:   Mon, 28 Jan 2019 10:43:04 -0500
Message-Id: <20190128154341.47195-267-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 5ac93f808338f4dd465402e91869702eb87db241 ]

Clang warns when one enumerated type is implicitly converted to another:

drivers/crypto/ux500/hash/hash_core.c:169:4: warning: implicit
conversion from enumeration type 'enum dma_data_direction' to different
enumeration type 'enum dma_transfer_direction' [-Wenum-conversion]
                        direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
                        ^~~~~~~~~
1 warning generated.

dmaengine_prep_slave_sg expects an enum from dma_transfer_direction.
We know that the only direction supported by this function is
DMA_TO_DEVICE because of the check at the top of this function so we can
just use the equivalent value from dma_transfer_direction.

DMA_TO_DEVICE = DMA_MEM_TO_DEV = 1

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ux500/hash/hash_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 633321a8dd03..a0bb8a6eec3f 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -166,7 +166,7 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
 		__func__);
 	desc = dmaengine_prep_slave_sg(channel,
 			ctx->device->dma.sg, ctx->device->dma.sg_len,
-			direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
+			DMA_MEM_TO_DEV, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
 	if (!desc) {
 		dev_err(ctx->device->dev,
 			"%s: dmaengine_prep_slave_sg() failed!\n", __func__);
-- 
2.19.1

