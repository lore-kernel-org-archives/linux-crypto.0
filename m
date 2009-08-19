From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: xcbc - Fix alignment calculation of xcbc_tfm_ctx
Date: Wed, 19 Aug 2009 09:09:02 +0200
Message-ID: <20090819070902.GA14755@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:56798 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZHSHGP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2009 03:06:15 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The alignment calculation of xcbc_tfm_ctx uses alg->cra_alignmask
and not alg->cra_alignmask + 1 as it should. This led to frequent
crashes during the selftest of xcbc(aes-asm) on x86_64
machines. This patch fixes this. Also we use the alignmask
of xcbc and not the alignmask of the underlying algorithm
for the alignmnent calculation in xcbc_create now.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/xcbc.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 1e30b31..bb7b67f 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -199,6 +199,7 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct shash_instance *inst;
 	struct crypto_alg *alg;
+	unsigned long alignmask;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
@@ -228,19 +229,20 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto out_free_inst;
 
+	alignmask = alg->cra_alignmask | 3;
+	inst->alg.base.cra_alignmask = alignmask;
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
-	inst->alg.base.cra_alignmask = alg->cra_alignmask | 3;
 
 	inst->alg.digestsize = alg->cra_blocksize;
 	inst->alg.descsize = ALIGN(sizeof(struct xcbc_desc_ctx),
 				   crypto_tfm_ctx_alignment()) +
-			     (alg->cra_alignmask &
+			     (alignmask &
 			      ~(crypto_tfm_ctx_alignment() - 1)) +
 			     alg->cra_blocksize * 2;
 
 	inst->alg.base.cra_ctxsize = ALIGN(sizeof(struct xcbc_tfm_ctx),
-					   alg->cra_alignmask) +
+					   alignmask + 1) +
 				     alg->cra_blocksize * 2;
 	inst->alg.base.cra_init = xcbc_init_tfm;
 	inst->alg.base.cra_exit = xcbc_exit_tfm;
-- 
1.5.4.2

