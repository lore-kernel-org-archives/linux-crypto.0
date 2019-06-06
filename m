Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC83C28D1E
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 11:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6401C20868
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 11:31:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="s8SV6TPa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbfFFLbm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 07:31:42 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:53996 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727585AbfFFLbm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 07:31:42 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45KNlv59S7zB09ZT;
        Thu,  6 Jun 2019 13:31:39 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=s8SV6TPa; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id LDyzcTRL0Pw3; Thu,  6 Jun 2019 13:31:39 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45KNlv47SgzB09ZF;
        Thu,  6 Jun 2019 13:31:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1559820699; bh=qIFQKb1N1ogct12r5N11IyeBAwzBADP2oCf+gxBp0T4=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=s8SV6TPaEgaJ3fs8aE/PfEZpUKWX6GQFed9TV6rdiwpF0svv46OQH5qWTYysAW93f
         wamkF8kCxBmx36XB/AzzzJNSFYF1S3tEe4Fh6Sc4td/YpwPOrUQMGcuihl25rhDlc2
         nxVqzriH6THsN3uiJ2ckbD48alHYmymrXXe42l5g=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D183C8B894;
        Thu,  6 Jun 2019 13:31:40 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id C7IcPtaUiVJW; Thu,  6 Jun 2019 13:31:40 +0200 (CEST)
Received: from po16838vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9F5838B891;
        Thu,  6 Jun 2019 13:31:40 +0200 (CEST)
Received: by po16838vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 7B3C568CFD; Thu,  6 Jun 2019 11:31:40 +0000 (UTC)
Message-Id: <a8d43c4414fc4fc3442f185b304ca9f659e6bfbb.1559819372.git.christophe.leroy@c-s.fr>
In-Reply-To: <cover.1559819372.git.christophe.leroy@c-s.fr>
References: <cover.1559819372.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v1 5/5] crypto: talitos - drop icv_ool
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Thu,  6 Jun 2019 11:31:40 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

icv_ool is not used anymore, drop it.

Fixes: 9cc87bc3613b ("crypto: talitos - fix AEAD processing")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 3 ---
 drivers/crypto/talitos.h | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b2de931de623..03b7a5d28fb0 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1278,9 +1278,6 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 				 is_ipsec_esp && !encrypt);
 	tbl_off += ret;
 
-	/* ICV data */
-	edesc->icv_ool = !encrypt;
-
 	if (!encrypt && is_ipsec_esp) {
 		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
 
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 95f78c6d9206..1469b956948a 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -46,7 +46,6 @@ struct talitos_desc {
  * talitos_edesc - s/w-extended descriptor
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
- * @icv_ool: whether ICV is out-of-line
  * @iv_dma: dma address of iv for checking continuity and link table
  * @dma_len: length of dma mapped link_tbl space
  * @dma_link_tbl: bus physical address of link_tbl/buf
@@ -61,7 +60,6 @@ struct talitos_desc {
 struct talitos_edesc {
 	int src_nents;
 	int dst_nents;
-	bool icv_ool;
 	dma_addr_t iv_dma;
 	int dma_len;
 	dma_addr_t dma_link_tbl;
-- 
2.13.3

