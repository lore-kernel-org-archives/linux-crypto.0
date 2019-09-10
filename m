Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5980C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 06:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A5612089F
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 06:04:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="dGp+kTd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390412AbfIJGER (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 02:04:17 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:56985 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbfIJGEQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 02:04:16 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 46SDxp5XBpz9twm3;
        Tue, 10 Sep 2019 08:04:14 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=dGp+kTd8; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 0jE7q2QeiFSq; Tue, 10 Sep 2019 08:04:14 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 46SDxp4Qjkz9twm2;
        Tue, 10 Sep 2019 08:04:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1568095454; bh=gaHQgkUONjgM7e5sTpiG9hKW2wcu3sDKClNiLbQr+G0=;
        h=From:Subject:To:Cc:Date:From;
        b=dGp+kTd8MFb+A6ub88VAvyIgBL+gNtMDiPIk6eBeQK7XvuqYXkCQksKXTLZJuRGGv
         edeH6l45cXSt2adFoPN8yzRPDhWXBeWKHwAsRVmfrBQtrh1EEkm/tOESAVTvLRGsJ0
         5ACi3HRB8g0sQUBfz7t4mc4/f2XitC8NRbON+vAk=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 75ACC8B78E;
        Tue, 10 Sep 2019 08:04:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Ztk9dE8IcFel; Tue, 10 Sep 2019 08:04:15 +0200 (CEST)
Received: from pc16032vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 35A448B754;
        Tue, 10 Sep 2019 08:04:15 +0200 (CEST)
Received: by localhost.localdomain (Postfix, from userid 0)
        id C1E3D6B734; Tue, 10 Sep 2019 06:04:14 +0000 (UTC)
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH] crypto: talitos - fix hash result for VMAP_STACK
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Message-Id: <20190910060414.C1E3D6B734@pc16032vm.idsi0.si.c-s.fr>
Date:   Tue, 10 Sep 2019 06:04:14 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When VMAP_STACK is selected, stack cannot be DMA-mapped.
Therefore, the hash result has to be DMA-mapped in the request
context and copied into areq->result at completion.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c9d686a0e805..9bd9ff312e2d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1728,6 +1728,7 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 				       struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_desc *desc = &edesc->desc;
@@ -1738,6 +1739,9 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	if (desc->next_desc &&
 	    desc->ptr[5].ptr != desc2->ptr[5].ptr)
 		unmap_single_talitos_ptr(dev, &desc2->ptr[5], DMA_FROM_DEVICE);
+	if (req_ctx->last)
+		memcpy(areq->result, req_ctx->hw_context,
+		       crypto_ahash_digestsize(tfm));
 
 	if (req_ctx->psrc)
 		talitos_sg_unmap(dev, edesc, req_ctx->psrc, NULL, 0, 0);
@@ -1869,7 +1873,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (req_ctx->last)
 		map_single_talitos_ptr(dev, &desc->ptr[5],
 				       crypto_ahash_digestsize(tfm),
-				       areq->result, DMA_FROM_DEVICE);
+				       req_ctx->hw_context, DMA_FROM_DEVICE);
 	else
 		map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
 					      req_ctx->hw_context_size,
-- 
2.13.3

