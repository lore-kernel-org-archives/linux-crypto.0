From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: hang in crypto_larval_lookup
Date: Sat, 25 Feb 2017 23:17:07 +0800
Message-ID: <20170225151707.GA28667@gondor.apana.org.au>
References: <02b80c39-0fd5-b7bd-39da-07e5d71abbad@linux.vnet.ibm.com>
 <20170223111957.GA14000@gondor.apana.org.au>
 <20170223113909.GA14090@gondor.apana.org.au>
 <20170224234400.GA2758@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, schwidefsky@de.ibm.com
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42939 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751324AbdBYPRU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Feb 2017 10:17:20 -0500
Content-Disposition: inline
In-Reply-To: <20170224234400.GA2758@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 24, 2017 at 08:44:00PM -0300, Marcelo Cerri wrote:
>
> This is probably caused by the way that the xts template is handling the
> underline algorithm selection.

Good catch.  I think the bigger issue here is that when requesting
for an XTS that doesn't need a fallback we shouldn't be using an
underlying ECB that needs one.  So this patch should fix the hang.

Thanks,

---8<---
Subject: crypto: xts - Propagate NEED_FALLBACK bit

When we're used as a fallback algorithm, we should propagate
the NEED_FALLBACK bit when searching for the underlying ECB mode.

This just happens to fix a hang too because otherwise the search
may end up loading the same module that triggered this XTS creation.

Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
Reported-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/xts.c b/crypto/xts.c
index 410a2e2..2066161 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -463,6 +463,7 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct xts_instance_ctx *ctx;
 	struct skcipher_alg *alg;
 	const char *cipher_name;
+	u32 mask;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -483,18 +484,19 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	ctx = skcipher_instance_ctx(inst);
 
 	crypto_set_skcipher_spawn(&ctx->spawn, skcipher_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ctx->spawn, cipher_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       ((algt->type ^ CRYPTO_ALG_NEED_FALLBACK) & algt->mask &
+	        CRYPTO_ALG_NEED_FALLBACK);
+
+	err = crypto_grab_skcipher(&ctx->spawn, cipher_name, 0, mask);
 	if (err == -ENOENT) {
 		err = -ENAMETOOLONG;
 		if (snprintf(ctx->name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
 			goto err_free_inst;
 
-		err = crypto_grab_skcipher(&ctx->spawn, ctx->name, 0,
-					   crypto_requires_sync(algt->type,
-								algt->mask));
+		err = crypto_grab_skcipher(&ctx->spawn, ctx->name, 0, mask);
 	}
 
 	if (err)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
