Return-Path: <SRS0=71ZY=QE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F84CC282CD
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 16:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 719D120663
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548692974;
	bh=LFwNDrZEkokgoLqrh8DTwGbk/gf1pEyJbOhvsdBgL+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AUfsMjd1dce3v27d/l6sv/cLX8WKzxGnQrC97gI0NIR9LvGKgms0mwytgg3zO4b2N
	 zAttdcVcneLI2Evd2DDjDXXnA23ja4bGlstamYaBHn4mnEcTE0isky6ozokzlhxbRs
	 5HJcsajQunQUL7m88YIJfbt/tMdd2jqVhNsdFOcM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390487AbfA1Q1v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:27:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390483AbfA1Q1v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 11:27:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5FB420879;
        Mon, 28 Jan 2019 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548692870;
        bh=LFwNDrZEkokgoLqrh8DTwGbk/gf1pEyJbOhvsdBgL+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJQG0X7A6hc9i3K2JthGgyye6vq8vR+jPO2iPE6EB7/+FqB2Gs7CvQoWuhkXh96ju
         YfGAA6T4ysa8L23U0he+fs3FA8zqS0IqBvD7ntxc6XL/nNKx2oKKJ/RJaB1wsgZjWp
         37vTxOYkJZnAZo/Dq8fuPPZX+BD2e2+ElprQ4jcI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 3.18 49/61] crypto: ux500 - Use proper enum in cryp_set_dma_transfer
Date:   Mon, 28 Jan 2019 11:26:11 -0500
Message-Id: <20190128162623.59854-49-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128162623.59854-1-sashal@kernel.org>
References: <20190128162623.59854-1-sashal@kernel.org>
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
index e4cea7c45142..3897bfe41c8b 100644
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

