From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 3/5] eseqiv: Add support for aead algorithms
Date: Thu, 25 Jun 2009 18:46:02 +0800
Message-ID: <20090625104602.GA1528@gondor.apana.org.au>
References: <20090608070749.GR20366@secunet.com> <20090608071046.GU20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50926 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752723AbZFYKqE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2009 06:46:04 -0400
Content-Disposition: inline
In-Reply-To: <20090608071046.GU20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2009 at 09:10:46AM +0200, Steffen Klassert wrote:
> This adds eseqiv support for aead algorithms, this is usefull
> for aead algorithms that need eseqiv as it's default IV generator.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

I'm going to change the default sync geniv to eseqiv for SMP.
That should render this patch unnecessary, right?

Here's the change.

commit 0b67fb65d1b2ba1396de69112b8b9bc95d8d5feb
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Jun 25 18:43:48 2009 +0800

    crypto: skcipher - Change default sync geniv on SMP to eseqiv
    
    As it stands we use chainiv for sync algorithms and eseqiv for
    async algorithms.  However, when there is more than one CPU
    chainiv forces all processing to be serialised which is usually
    not what you want.  Also, the added overhead of eseqiv isn't that
    great.
    
    Therefore this patch changes the default sync geniv on SMP machines
    to eseqiv.  For the odd situation where the overhead is unacceptable
    then chainiv is still available as an option.
    
    Note that on UP machines chainiv is still preferred over eseqiv
    for sync algorithms.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 43fc8fb..03fb5fa 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -14,6 +14,7 @@
  */
 
 #include <crypto/internal/skcipher.h>
+#include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -25,6 +26,8 @@
 
 #include "internal.h"
 
+static const char *skcipher_default_geniv __read_mostly;
+
 static int setkey_unaligned(struct crypto_ablkcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
@@ -180,7 +183,8 @@ EXPORT_SYMBOL_GPL(crypto_givcipher_type);
 
 const char *crypto_default_geniv(const struct crypto_alg *alg)
 {
-	return alg->cra_flags & CRYPTO_ALG_ASYNC ? "eseqiv" : "chainiv";
+	return alg->cra_flags & CRYPTO_ALG_ASYNC ?
+	       "eseqiv" : skcipher_default_geniv;
 }
 
 static int crypto_givcipher_default(struct crypto_alg *alg, u32 type, u32 mask)
@@ -361,3 +365,17 @@ err:
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_ablkcipher);
+
+static int __init skcipher_module_init(void)
+{
+	skcipher_default_geniv = num_possible_cpus() > 1 ?
+				 "eseqiv" : "chainiv";
+	return 0;
+}
+
+static void skcipher_module_exit(void)
+{
+}
+
+module_init(skcipher_module_init);
+module_exit(skcipher_module_exit);

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
