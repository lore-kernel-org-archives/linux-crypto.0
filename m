Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B049C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50E0F217D7
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="wDmkV30Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfEUNeU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 09:34:20 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:12175 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbfEUNeT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 09:34:19 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 457cDm01ylz9v2Xb;
        Tue, 21 May 2019 15:34:16 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=wDmkV30Z; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id K3dGGqH2eHck; Tue, 21 May 2019 15:34:15 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 457cDl65YDz9v2XY;
        Tue, 21 May 2019 15:34:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558445655; bh=zYNSnTdBI2zlv+nNU1YJCYKZt0d8+sVXOHJ4QyhBzhk=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=wDmkV30Z25a7KCNIbqmuyroCCzdpnZqFNkvTW/i3AeXvb+NsDzUq8rXvfPNtj9jzE
         6Rk9nqBL9MU2u3aKtT6fTX2ydZApXMH5EjAh5DWifgCnqnGnUHFuI/Eos07/ktc1ct
         noZH3G9x2fjWRzJjbM2ddga97ma8EuYAxSmtrtGs=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 47A368B80E;
        Tue, 21 May 2019 15:34:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id X8v_1FalQceD; Tue, 21 May 2019 15:34:17 +0200 (CEST)
Received: from po16846vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 210998B803;
        Tue, 21 May 2019 15:34:17 +0200 (CEST)
Received: by po16846vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id DF3A868458; Tue, 21 May 2019 13:34:12 +0000 (UTC)
Message-Id: <a276c80d100ab95f14878c052d93a232a527b86d.1558445259.git.christophe.leroy@c-s.fr>
In-Reply-To: <cover.1558445259.git.christophe.leroy@c-s.fr>
References: <cover.1558445259.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v1 06/15] crypto: talitos - check data blocksize in
 ablkcipher.
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Tue, 21 May 2019 13:34:12 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When data size is not a multiple of the alg's block size,
the SEC generates an error interrupt and dumps the registers.
And for NULL size, the SEC does just nothing and the interrupt
is awaited forever.

This patch ensures the data size is correct before submitting
the request to the SEC engine.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 4de9d0b547b9 ("crypto: talitos - Add ablkcipher algorithms")
---
 drivers/crypto/talitos.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8b9a529f1b66..1e5410f92166 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1756,6 +1756,14 @@ static int ablkcipher_encrypt(struct ablkcipher_request *areq)
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 	struct talitos_edesc *edesc;
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ablkcipher_tfm(cipher));
+
+	if (!areq->nbytes)
+		return 0;
+
+	if (areq->nbytes % blocksize)
+		return -EINVAL;
 
 	/* allocate extended descriptor */
 	edesc = ablkcipher_edesc_alloc(areq, true);
@@ -1773,6 +1781,14 @@ static int ablkcipher_decrypt(struct ablkcipher_request *areq)
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 	struct talitos_edesc *edesc;
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ablkcipher_tfm(cipher));
+
+	if (!areq->nbytes)
+		return 0;
+
+	if (areq->nbytes % blocksize)
+		return -EINVAL;
 
 	/* allocate extended descriptor */
 	edesc = ablkcipher_edesc_alloc(areq, false);
-- 
2.13.3

