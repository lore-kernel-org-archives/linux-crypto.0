From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: hang in crypto_larval_lookup
Date: Sun, 26 Feb 2017 12:22:35 +0800
Message-ID: <20170226042235.GA29266@gondor.apana.org.au>
References: <02b80c39-0fd5-b7bd-39da-07e5d71abbad@linux.vnet.ibm.com>
 <20170223111957.GA14000@gondor.apana.org.au>
 <20170223113909.GA14090@gondor.apana.org.au>
 <20170224234400.GA2758@gallifrey>
 <20170225151707.GA28667@gondor.apana.org.au>
 <20170225192022.GA18004@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, schwidefsky@de.ibm.com
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49347 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750987AbdBZE6V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Feb 2017 23:58:21 -0500
Content-Disposition: inline
In-Reply-To: <20170225192022.GA18004@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 25, 2017 at 04:20:22PM -0300, Marcelo Cerri wrote:
> 
> Yeah, I agree. This should work as long as the module aliases are
> correct, which is enough.
> 
> Other templates will not trigger the same error since they don't have to
> try more than one underlying algorithm. But I think this is still
> desirable for the remaining templates to avoid a long chain of unused
> fallbacks as in the example I gave in my previous email.
> 
> Probably a helper function to return the correct mask might be useful
> for readability and to avoid duplicate code.

You're right.  Here is a patch to add a helper for this.
Thanks!

---8<---
Subject: crypto: api - Add crypto_requires_off helper

This patch adds crypto_requires_off which is an extension of
crypto_requires_sync for similar bits such as NEED_FALLBACK.

Suggested-by: Marcelo Cerri <marcelo.cerri@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index ebe4ded..436c4c2 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -360,13 +360,18 @@ static inline struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb,
 	return crypto_attr_alg(tb[1], type, mask);
 }
 
+static inline int crypto_requires_off(u32 type, u32 mask, u32 off)
+{
+	return (type ^ off) & mask & off;
+}
+
 /*
  * Returns CRYPTO_ALG_ASYNC if type/mask requires the use of sync algorithms.
  * Otherwise returns zero.
  */
 static inline int crypto_requires_sync(u32 type, u32 mask)
 {
-	return (type ^ CRYPTO_ALG_ASYNC) & mask & CRYPTO_ALG_ASYNC;
+	return crypto_requires_off(type, mask, CRYPTO_ALG_ASYNC);
 }
 
 noinline unsigned long __crypto_memneq(const void *a, const void *b, size_t size);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
