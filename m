Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46457C432C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 09:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 253562230C
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 09:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfKSJlk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 04:41:40 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37036 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbfKSJlk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 04:41:40 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iX00t-0001uJ-Jx; Tue, 19 Nov 2019 17:41:35 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iX00p-0004qI-Od; Tue, 19 Nov 2019 17:41:31 +0800
Date:   Tue, 19 Nov 2019 17:41:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: pcrypt - Fix user-after-free on module unload
Message-ID: <20191119094131.x7gkxdi5clyxk3zd@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On module unload of pcrypt we must unregister the crypto algorithms
first and then tear down the padata structure.  As otherwise the
crypto algorithms are still alive and can be used while the padata
structure is being freed.

Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 543792e0ebf0..3e026e7a7e75 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -362,11 +392,12 @@ static int __init pcrypt_init(void)
 
 static void __exit pcrypt_exit(void)
 {
+	crypto_unregister_template(&pcrypt_tmpl);
+
 	pcrypt_fini_padata(pencrypt);
 	pcrypt_fini_padata(pdecrypt);
 
 	kset_unregister(pcrypt_kset);
-	crypto_unregister_template(&pcrypt_tmpl);
 }
 
 subsys_initcall(pcrypt_init);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
