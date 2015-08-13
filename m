From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/13] crypto: echainiv - Remove AEAD compatibility code
Date: Thu, 13 Aug 2015 17:28:56 +0800
Message-ID: <E1ZPooi-0005pu-KC@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39993 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbbHMJ3A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:29:00 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZPooj-00036P-DG
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2015 19:28:57 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that we no longer have any legacy AEAD implementations the
compatibility code path can no longer be triggered.  This patch
removes it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/echainiv.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index d3896c7..806ebe7 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -247,9 +247,6 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	spawn = aead_instance_ctx(inst);
 	alg = crypto_spawn_aead_alg(spawn);
 
-	if (alg->base.cra_aead.encrypt)
-		goto done;
-
 	err = -EINVAL;
 	if (inst->alg.ivsize & (sizeof(u32) - 1) ||
 	    inst->alg.ivsize > MAX_IV_SIZE)
@@ -267,7 +264,6 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 
 	inst->free = aead_geniv_free;
 
-done:
 	err = aead_register_instance(tmpl, inst);
 	if (err)
 		goto free_inst;
