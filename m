Return-Path: <SRS0=ZwPv=5N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DATE_IN_PAST_96_XX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24D8C2D0F2
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Mar 2020 16:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B97B620748
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Mar 2020 16:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgC1QnX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Mar 2020 12:43:23 -0400
Received: from mx.sdf.org ([205.166.94.20]:50174 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbgC1QnV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Mar 2020 12:43:21 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02SGhGwk005450
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 28 Mar 2020 16:43:16 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02SGhGKO009144;
        Sat, 28 Mar 2020 16:43:16 GMT
Message-Id: <202003281643.02SGhGKO009144@sdf.org>
From:   George Spelvin <lkml@sdf.org>
Date:   Wed, 27 Mar 2019 07:56:49 -0400
Subject: [RFC PATCH v1 24/50] crypto4xx_core: Use more appropriate seed for
 PRNG
To:     linux-kernel@vger.kernel.org, lkml@sdf.org
Cc:     James Hsiao <jhsiao@amcc.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A PRNG doesn't need the full security guarantees of
get_random_bytes() (and a 64-bit seed can be brute-forced
anyway); get_random_u32() is quite sufficient.

Signed-off-by: George Spelvin <lkml@sdf.org>
Cc: James Hsiao <jhsiao@amcc.com>
Cc: Christian Lamparter <chunkeey@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
---
 drivers/crypto/amcc/crypto4xx_core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 7d6b695c4ab3f..0fc41ffe3ff9a 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -53,7 +53,6 @@ static void crypto4xx_hw_init(struct crypto4xx_device *dev)
 	union ce_ring_control ring_ctrl;
 	union ce_part_ring_size part_ring_size;
 	union ce_io_threshold io_threshold;
-	u32 rand_num;
 	union ce_pe_dma_cfg pe_dma_cfg;
 	u32 device_ctrl;
 
@@ -79,10 +78,8 @@ static void crypto4xx_hw_init(struct crypto4xx_device *dev)
 	writel(dev->pdr_pa, dev->ce_base + CRYPTO4XX_PDR_BASE);
 	writel(dev->pdr_pa, dev->ce_base + CRYPTO4XX_RDR_BASE);
 	writel(PPC4XX_PRNG_CTRL_AUTO_EN, dev->ce_base + CRYPTO4XX_PRNG_CTRL);
-	get_random_bytes(&rand_num, sizeof(rand_num));
-	writel(rand_num, dev->ce_base + CRYPTO4XX_PRNG_SEED_L);
-	get_random_bytes(&rand_num, sizeof(rand_num));
-	writel(rand_num, dev->ce_base + CRYPTO4XX_PRNG_SEED_H);
+	writel(get_random_u32(), dev->ce_base + CRYPTO4XX_PRNG_SEED_L);
+	writel(get_random_u32(), dev->ce_base + CRYPTO4XX_PRNG_SEED_H);
 	ring_size.w = 0;
 	ring_size.bf.ring_offset = PPC4XX_PD_SIZE;
 	ring_size.bf.ring_size   = PPC4XX_NUM_PD;
-- 
2.26.0

