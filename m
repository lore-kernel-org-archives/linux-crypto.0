Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6F9C31E48
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 05:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB4FA20896
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 05:49:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="sCtawWjO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbfFLFtw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 01:49:52 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:33315 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfFLFtw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 01:49:52 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45Nwtk1vbMz9v0lK;
        Wed, 12 Jun 2019 07:49:50 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=sCtawWjO; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 8EzPB5zbqOaI; Wed, 12 Jun 2019 07:49:50 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45Nwtk0tC3z9v0lC;
        Wed, 12 Jun 2019 07:49:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560318590; bh=FoG4OGBISVsTMvo03dXxhD2VAgBOQFvqwYTzQQA5uVU=;
        h=From:Subject:To:Cc:Date:From;
        b=sCtawWjONNvVmtRrbJFdIFd9NbKAAlUw0yNYQNK0k7w/Vtnw7/xvtY0tCeuyxtZy2
         TGyPejEdiAUD4bWEC0NO78z369ilwh41F36OrwQMHbNKH2IZSHO+n1Y02DLS0FrK+r
         e1Ar7mqF8jiljRNsghhGAD+TQeHBR36ufla9uhgk=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EEB698B803;
        Wed, 12 Jun 2019 07:49:50 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id mqkQui9XO-on; Wed, 12 Jun 2019 07:49:50 +0200 (CEST)
Received: from po16838vm.idsi0.si.c-s.fr (po15451.idsi0.si.c-s.fr [172.25.230.107])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id CC88F8B75A;
        Wed, 12 Jun 2019 07:49:50 +0200 (CEST)
Received: by po16838vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id A20C968D07; Wed, 12 Jun 2019 05:49:50 +0000 (UTC)
Message-Id: <5f1004d33b2347dcfbc677551bafc9d469bb079e.1560318544.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH] crypto: talitos - fix max key size for sha384 and sha512
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Wed, 12 Jun 2019 05:49:50 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Below commit came with a typo in the CONFIG_ symbol, leading
to a permanently reduced max key size regarless of the driver
capabilities.

Reported-by: Horia Geantă <horia.geanta@nxp.com>
Fixes: b8fbdc2bc4e7 ("crypto: talitos - reduce max key size for SEC1")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 03b7a5d28fb0..b4c8a013f302 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -832,7 +832,7 @@ static void talitos_unregister_rng(struct device *dev)
  * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
-#ifdef CONFIG_CRYPTO_DEV_TALITOS_SEC2
+#ifdef CONFIG_CRYPTO_DEV_TALITOS2
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
 #else
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
-- 
2.13.3

