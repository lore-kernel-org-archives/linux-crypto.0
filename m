Return-Path: <SRS0=71ZY=QE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F4AC282CF
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 17:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5C002147A
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696780;
	bh=U0yYD2++o2KSoLg1EAb0XjmFBMknCsYSZ/X114Occ6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eZxAl0iZWJbb4sdv3i4JoHqJLGvHoXnHAfSUf6yeTjl6GCfZUK5u5i4siCKtK+JpD
	 hOLGFbKoa+I5w6np6VPAA9pxOAtQdvWTvuzK8HS6XTVufUyHjeIGbUl3qn0xH3zSlC
	 wC7cn26lhq0RCWayHOzSf5KO0RiN/E29rq7y3zxc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfA1P5L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:57:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728174AbfA1P5I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 10:57:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8518321848;
        Mon, 28 Jan 2019 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691027;
        bh=U0yYD2++o2KSoLg1EAb0XjmFBMknCsYSZ/X114Occ6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iz3s2M9ddGwZXTG9ep8Nn0t63y3upVRdxKj1t9TOWjGUzhXPurIwDJS0iu1iXQ91B
         5f6JbjLpH1RtEtR5Dmn4yokieoF3ivHfxLabmoLPmEJiy+l332XoP/z/59fdTA8ORn
         94BsdxQrQ7ZDG7b9GAYOViFERNWksPN2FwHYh5hY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 266/304] crypto: ux500 - Use proper enum in cryp_set_dma_transfer
Date:   Mon, 28 Jan 2019 10:43:03 -0500
Message-Id: <20190128154341.47195-266-sashal@kernel.org>
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
index d2663a4e1f5e..a92a66b1ff46 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -556,7 +556,7 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 		desc = dmaengine_prep_slave_sg(channel,
 				ctx->device->dma.sg_src,
 				ctx->device->dma.sg_src_len,
-				direction, DMA_CTRL_ACK);
+				DMA_MEM_TO_DEV, DMA_CTRL_ACK);
 		break;
 
 	case DMA_FROM_DEVICE:
@@ -580,7 +580,7 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 		desc = dmaengine_prep_slave_sg(channel,
 				ctx->device->dma.sg_dst,
 				ctx->device->dma.sg_dst_len,
-				direction,
+				DMA_DEV_TO_MEM,
 				DMA_CTRL_ACK |
 				DMA_PREP_INTERRUPT);
 
-- 
2.19.1

