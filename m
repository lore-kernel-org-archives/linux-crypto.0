From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/11] crypto: seqiv - Fix IV size in context size calculation
Date: Wed, 27 May 2015 14:37:39 +0800
Message-ID: <E1YxUyB-0006nP-Ei@gondolin.me.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53055 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbbE0Ghm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:37:42 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YxUyC-0005e0-6z
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 16:37:40 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes a bug in the context size calculation where we
were still referring to the old cra_aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 9c4490b..c0dba8f 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -812,7 +812,7 @@ static int seqniv_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
 	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
-	inst->alg.base.cra_ctxsize += inst->alg.base.cra_aead.ivsize;
+	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
 
 done:
 	err = aead_register_instance(tmpl, inst);
