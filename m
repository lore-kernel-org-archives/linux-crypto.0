From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/10] crypto: api - Include alignment in crypto_alg_extsize
Date: Thu, 28 May 2015 22:07:56 +0800
Message-ID: <E1YxyTU-0002Jm-GL@gondolin.me.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49522 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbbE1OH7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 10:07:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch ensures that the tfm context always has enough extra
memory to ensure that it is aligned according to cra_alignment.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index abf100c..3c079b7 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -980,7 +980,8 @@ EXPORT_SYMBOL_GPL(crypto_xor);
 
 unsigned int crypto_alg_extsize(struct crypto_alg *alg)
 {
-	return alg->cra_ctxsize;
+	return alg->cra_ctxsize +
+	       (alg->cra_alignmask & ~(crypto_tfm_ctx_alignment() - 1));
 }
 EXPORT_SYMBOL_GPL(crypto_alg_extsize);
 
