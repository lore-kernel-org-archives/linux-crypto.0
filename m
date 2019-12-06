Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CB6C43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 05:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B144324676
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 05:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfLFFzU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 00:55:20 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51788 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfLFFzT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 00:55:19 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1id6aE-0004xc-Lu; Fri, 06 Dec 2019 13:55:18 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1id6aD-0000Ko-H2; Fri, 06 Dec 2019 13:55:17 +0800
Date:   Fri, 6 Dec 2019 13:55:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: api - Check spawn->alg under lock in
 crypto_drop_spawn
Message-ID: <20191206055517.53o7xtpxdo2bx6qe@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We need to check whether spawn->alg is NULL under lock as otherwise
the algorithm could be removed from under us after we have checked
it and found it to be non-NULL.  This could cause us to remove the
spawn from a non-existent list.

Fixes: 6bfd48096ff8 ("[CRYPTO] api: Added spawns")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 783006f4d339..6869feb31c99 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -668,11 +668,9 @@ EXPORT_SYMBOL_GPL(crypto_grab_spawn);
 
 void crypto_drop_spawn(struct crypto_spawn *spawn)
 {
-	if (!spawn->alg)
-		return;
-
 	down_write(&crypto_alg_sem);
-	list_del(&spawn->list);
+	if (spawn->alg)
+		list_del(&spawn->list);
 	up_write(&crypto_alg_sem);
 }
 EXPORT_SYMBOL_GPL(crypto_drop_spawn);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
