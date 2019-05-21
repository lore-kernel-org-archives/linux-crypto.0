Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63081C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39839217D7
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="QZvVTsrv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfEUNeg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 09:34:36 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:58231 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbfEUNeW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 09:34:22 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 457cDr1vX4z9v2XZ;
        Tue, 21 May 2019 15:34:20 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=QZvVTsrv; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id I2YW1po2_m4H; Tue, 21 May 2019 15:34:20 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 457cDr0sNQz9v2XX;
        Tue, 21 May 2019 15:34:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558445660; bh=97UiAiw0Z+TKwMmqYH+9V/rApIAY8c8v8ygR23KprmY=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=QZvVTsrvjWYNiQaLmESkKBeruJVaLm+YCLpEm64j6w2Onhbmb92mU1Y64n71eNNsr
         Zo11tMxCTjtX+6SwKFqxSRvnyZHL2QNNuI12rZFZl1nP+CTGFgmnzwN/8ONu/xdUFy
         RvS4zHBP3pKrmaOmLmnB8nHA9YKPNVIqbe8+eoEQ=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 8BC868B80C;
        Tue, 21 May 2019 15:34:21 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id LVhWi5UGWrbx; Tue, 21 May 2019 15:34:21 +0200 (CEST)
Received: from po16846vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5B01B8B803;
        Tue, 21 May 2019 15:34:21 +0200 (CEST)
Received: by po16846vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 1EB2F68458; Tue, 21 May 2019 13:34:21 +0000 (UTC)
Message-Id: <4d3dec78e9ac8716fa4c9b1f36d2f975c6cc6b7c.1558445259.git.christophe.leroy@c-s.fr>
In-Reply-To: <cover.1558445259.git.christophe.leroy@c-s.fr>
References: <cover.1558445259.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v1 14/15] crypto: talitos - use IS_ENABLED() in has_ftr_sec1()
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Tue, 21 May 2019 13:34:21 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch rewrites has_ftr_sec1() using IS_ENABLED()
instead of #ifdefs

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 95e97951b924..5699d46401e6 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -164,13 +164,11 @@ struct talitos_private {
  */
 static inline bool has_ftr_sec1(struct talitos_private *priv)
 {
-#if defined(CONFIG_CRYPTO_DEV_TALITOS1) && defined(CONFIG_CRYPTO_DEV_TALITOS2)
-	return priv->features & TALITOS_FTR_SEC1 ? true : false;
-#elif defined(CONFIG_CRYPTO_DEV_TALITOS1)
-	return true;
-#else
-	return false;
-#endif
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS1) &&
+	    IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS2))
+		return priv->features & TALITOS_FTR_SEC1;
+
+	return IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS1);
 }
 
 /*
-- 
2.13.3

