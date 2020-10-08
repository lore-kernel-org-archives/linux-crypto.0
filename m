Return-Path: <SRS0=kcel=DP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9033DC43467
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 09:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD752177B
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 09:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgJHJe6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Oct 2020 05:34:58 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:29999 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgJHJe6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Oct 2020 05:34:58 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4C6Qz2486Pz9v0Jd;
        Thu,  8 Oct 2020 11:34:54 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id TMI4UqB_f0Ts; Thu,  8 Oct 2020 11:34:54 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4C6Qz23Nxfz9v0Jb;
        Thu,  8 Oct 2020 11:34:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A3D308B831;
        Thu,  8 Oct 2020 11:34:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id FS9mLCWGIccp; Thu,  8 Oct 2020 11:34:55 +0200 (CEST)
Received: from po17688vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 70CC98B82F;
        Thu,  8 Oct 2020 11:34:55 +0200 (CEST)
Received: by po17688vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 2E4F865DCA; Thu,  8 Oct 2020 09:34:55 +0000 (UTC)
Message-Id: <facca5935decb8ddefa4c4898b2aeedc7ec4f860.1602149660.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH] crypto: talitos - Endianess in current_desc_hdr()
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Thu,  8 Oct 2020 09:34:55 +0000 (UTC)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

current_desc_hdr() compares the value of the current descriptor
with the next_desc member of the talitos_desc struct.

While the current descriptor is obtained from in_be32() which
return CPU ordered bytes, next_desc member is in big endian order.

Convert the current descriptor into big endian before comparing it
with next_desc.

This fixes a sparse warning.

Fixes: 37b5e8897eb5 ("crypto: talitos - chain in buffered data for ahash on SEC1")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 drivers/crypto/talitos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index f9f0d34d49f3..992d58a4dbf1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -478,7 +478,7 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 
 	iter = tail;
 	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc &&
-	       priv->chan[ch].fifo[iter].desc->next_desc != cur_desc) {
+	       priv->chan[ch].fifo[iter].desc->next_desc != cpu_to_be32(cur_desc)) {
 		iter = (iter + 1) & (priv->fifo_len - 1);
 		if (iter == tail) {
 			dev_err(dev, "couldn't locate current descriptor\n");
@@ -486,7 +486,7 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 		}
 	}
 
-	if (priv->chan[ch].fifo[iter].desc->next_desc == cur_desc) {
+	if (priv->chan[ch].fifo[iter].desc->next_desc == cpu_to_be32(cur_desc)) {
 		struct talitos_edesc *edesc;
 
 		edesc = container_of(priv->chan[ch].fifo[iter].desc,
-- 
2.25.0

