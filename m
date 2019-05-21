Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186E2C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1DF02173C
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:34:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="Kt4XQouE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfEUNev (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 09:34:51 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:58231 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbfEUNeT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 09:34:19 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 457cDl1yBFz9v2XZ;
        Tue, 21 May 2019 15:34:15 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=Kt4XQouE; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id iwtYlESuu9Kd; Tue, 21 May 2019 15:34:15 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 457cDl0tlvz9v2XY;
        Tue, 21 May 2019 15:34:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558445655; bh=cLZS8AdXalh4PzV0bR7pQ1Sxvy0G/j9ji4WXIDqtpwI=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=Kt4XQouEVoV3bK3qT7gYJ1mH9Q75z7SCEHD0wJ6s6FFnxrETevOavUQSVATniakNS
         u1ya1D5vjE11GTBieauBXEgSkxPvrcz1A+7H2r/2rkHyCM4+FHx0qbl7S1hNA5A8OD
         OIunSixYf3pQIzjgpC111YUavjG4t3PUQJUFLfvw=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5289C8B80C;
        Tue, 21 May 2019 15:34:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id DqbakKfmM1fP; Tue, 21 May 2019 15:34:16 +0200 (CEST)
Received: from po16846vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 256F68B803;
        Tue, 21 May 2019 15:34:16 +0200 (CEST)
Received: by po16846vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id F3C7E68479; Tue, 21 May 2019 13:34:15 +0000 (UTC)
Message-Id: <38dd4f4ddf05091a43965aebea89543ca4bdbcb8.1558445259.git.christophe.leroy@c-s.fr>
In-Reply-To: <cover.1558445259.git.christophe.leroy@c-s.fr>
References: <cover.1558445259.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v1 09/15] crypto: talitos - HMAC SNOOP NO AFEU mode requires
 SW icv checking.
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Tue, 21 May 2019 13:34:15 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In that mode, hardware ICV verification is not supported.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 7405c8d7ff97 ("crypto: talitos - templates for AEAD using HMAC_SNOOP_NO_AFEU")
---
 drivers/crypto/talitos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a15aa6d6ec33..e35581d67315 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1545,7 +1545,8 @@ static int aead_decrypt(struct aead_request *req)
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	if ((priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
+	if ((edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP) &&
+	    (priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
 	    ((!edesc->src_nents && !edesc->dst_nents) ||
 	     priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT)) {
 
-- 
2.13.3

