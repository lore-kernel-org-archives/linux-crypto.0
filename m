Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608E4C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC8E217D9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="OE9LtBbv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbfEUNeO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 09:34:14 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:60749 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbfEUNeL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 09:34:11 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 457cDc5tfsz9v2XZ;
        Tue, 21 May 2019 15:34:08 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=OE9LtBbv; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id llxTgzOPOP6u; Tue, 21 May 2019 15:34:08 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 457cDc4s3pz9v2XY;
        Tue, 21 May 2019 15:34:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558445648; bh=pa7vl8a//DSmJcXNbFqorY8WvZK4+qW8qWntTf4Yza4=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=OE9LtBbvaUzvcxrv7hQbRZaoo/POV51uzrKh1cxT9rza+02xMSPe/PrjvDkXVaDvm
         VXwcgfHuF2Njjjowfws5ROeg03A6V7qAhU9g4xGZO57pQsHQUz/0k/cqE0ccJ/LFEk
         35GdTzT2edQtJkWkVBLozUpeiVJnw826zT6Mq+p0=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 252AE8B80C;
        Tue, 21 May 2019 15:34:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 9yYx09vm-5o2; Tue, 21 May 2019 15:34:10 +0200 (CEST)
Received: from po16846vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 031EE8B803;
        Tue, 21 May 2019 15:34:10 +0200 (CEST)
Received: by po16846vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id CD25468458; Tue, 21 May 2019 13:34:09 +0000 (UTC)
Message-Id: <310b67004e02da826322e7cc96b85f46c9ef35b2.1558445259.git.christophe.leroy@c-s.fr>
In-Reply-To: <cover.1558445259.git.christophe.leroy@c-s.fr>
References: <cover.1558445259.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v1 03/15] crypto: talitos - reduce max key size for SEC1
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Tue, 21 May 2019 13:34:09 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SEC1 doesn't support SHA384/512, so it doesn't require
longer keys.

This patch reduces the max key size when the driver
is built for SEC1 only.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 03d2c5114c95 ("crypto: talitos - Extend max key length for SHA384/512-HMAC and AEAD")
---
 drivers/crypto/talitos.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6f8bc6467706..6312f8d501b1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -837,7 +837,11 @@ static void talitos_unregister_rng(struct device *dev)
  * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
+#ifdef CONFIG_CRYPTO_DEV_TALITOS_SEC2
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
+#else
+#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
+#endif
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
 struct talitos_ctx {
-- 
2.13.3

