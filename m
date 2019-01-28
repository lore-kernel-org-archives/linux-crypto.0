Return-Path: <SRS0=71ZY=QE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926D7C282CF
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 16:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 632C02084A
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 16:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548693828;
	bh=hdrYnzqp5HeJOjIcoKP6mksNrf1ltGg3hT2/WBSGiB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bLa0gU8vAT6O0q1s5SX76n3HQWHkMcnRdP+RkvDZKVVwYMobZjbSSFJf9I+rnyXhJ
	 rn7xQyzftk0H9T6/hlVRjRg3lKXmTjl688B3K29IDlyDlDGbw4qJTfA1Gx0G4UXEJ+
	 Nmi5wBD8KlCwrEDRbyjZ4hnmxBnDTOzK5zOekuRs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388725AbfA1Qnm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731941AbfA1QXU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 11:23:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23F442147A;
        Mon, 28 Jan 2019 16:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548692599;
        bh=hdrYnzqp5HeJOjIcoKP6mksNrf1ltGg3hT2/WBSGiB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdsT398zOo/S9G7tCJOa1ZYHfcnI/VrBWjKkNEtT94CfzERqhhnyfJ4FAZikMDZTR
         Hy0gwO2k/OnBdnKlGWBWuaIMhVKIS65AwLN7QnVqMO3GpRf/5IuD1BgE4NhO2UKlfR
         hvarQeqwgm4XWgqwR/xlIYVOB4LREa0RKo3bWxIA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 087/107] crypto: ux500 - Use proper enum in cryp_set_dma_transfer
Date:   Mon, 28 Jan 2019 11:19:27 -0500
Message-Id: <20190128161947.57405-87-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128161947.57405-1-sashal@kernel.org>
References: <20190128161947.57405-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 9d880c5945c748d8edcac30965f3349a602158c4 ]

Clang warns when one enumerated type is implicitly converted to another:

drivers/crypto/ux500/cryp/cryp_core.c:559:5: warning: implicit
conversion from enumeration type 'enum dma_data_direction' to different
enumeration type 'enum dma_transfer_direction' [-Wenum-conversion]
                                direction, DMA_CTRL_ACK);
                                ^~~~~~~~~
drivers/crypto/ux500/cryp/cryp_core.c:583:5: warning: implicit
conversion from enumeration type 'enum dma_data_direction' to different
enumeration type 'enum dma_transfer_direction' [-Wenum-conversion]
                                direction,
                                ^~~~~~~~~
2 warnings generated.

dmaengine_prep_slave_sg expects an enum from dma_transfer_direction.
Because we know the value of the dma_data_direction enum from the
switch statement, we can just use the proper value from
dma_transfer_direction so there is no more conversion.

DMA_TO_DEVICE = DMA_MEM_TO_DEV = 1
DMA_FROM_DEVICE = DMA_DEV_TO_MEM = 2

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 790f7cadc1ed..efebc484e371 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -555,7 +555,7 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 		desc = dmaengine_prep_slave_sg(channel,
 				ctx->device->dma.sg_src,
 				ctx->device->dma.sg_src_len,
-				direction, DMA_CTRL_ACK);
+				DMA_MEM_TO_DEV, DMA_CTRL_ACK);
 		break;
 
 	case DMA_FROM_DEVICE:
@@ -579,7 +579,7 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 		desc = dmaengine_prep_slave_sg(channel,
 				ctx->device->dma.sg_dst,
 				ctx->device->dma.sg_dst_len,
-				direction,
+				DMA_DEV_TO_MEM,
 				DMA_CTRL_ACK |
 				DMA_PREP_INTERRUPT);
 
-- 
2.19.1

