From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered architecture
Date: Mon, 26 May 2008 21:05:08 +1000
Message-ID: <20080526110508.GB14743@gondor.apana.org.au>
References: <20080517.020122.229980431.davem@davemloft.net> <20080517091451.GE19540@Chamillionaire.breakpoint.cc> <20080517095625.GA17878@gondor.apana.org.au> <20080520.194723.268247612.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@ml.breakpoint.cc, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from goliath.apana.org.au ([203.14.152.44]:52753 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756144AbYE0QYP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 May 2008 12:24:15 -0400
Content-Disposition: inline
In-Reply-To: <20080520.194723.268247612.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 20, 2008 at 07:47:23PM -0700, David Miller wrote:

> -------------------- before patch --------------------
> 
> [452862.338505] testing speed of rmd128
> [452862.354441] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   6064 cycles/operation,  379 cycles/byte

> -------------------- after patch --------------------
> 
> [453226.216294] testing speed of rmd128
> [453226.216322] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   2784 cycles/operation,  174 cycles/byte

Looks good Dave! I've done the same thing for the other rmd* files
and for the store on the result.  Let me know if this looks OK and
I'll commit.

Sebastian, if you're still seeing worse results on powerpc could you
post the actual numbers with/without this patch?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 89a535a..1a481df 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -44,7 +44,7 @@ struct rmd128_ctx {
 #define F4(x, y, z) (y ^ (z & (x ^ y)))	/* z ? x : y */
 
 #define ROUND(a, b, c, d, f, k, x, s)  { \
-	(a) += f((b), (c), (d)) + le32_to_cpu(x) + (k); \
+	(a) += f((b), (c), (d)) + le32_to_cpup(&(x)) + (k);	\
 	(a) = rol32((a), (s)); \
 }
 
@@ -285,7 +285,7 @@ static void rmd128_final(struct crypto_tfm *tfm, u8 *out)
 
 	/* Store state in digest */
 	for (i = 0; i < 4; i++)
-		dst[i] = cpu_to_le32(rctx->state[i]);
+		dst[i] = cpu_to_le32p(&rctx->state[i]);
 
 	/* Wipe context */
 	memset(rctx, 0, sizeof(*rctx));
diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index 136e31f..e9fd5f6 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -47,7 +47,7 @@ struct rmd160_ctx {
 #define F5(x, y, z) (x ^ (y | ~z))
 
 #define ROUND(a, b, c, d, e, f, k, x, s)  { \
-	(a) += f((b), (c), (d)) + le32_to_cpu(x) + (k); \
+	(a) += f((b), (c), (d)) + le32_to_cpup(&(x)) + (k); \
 	(a) = rol32((a), (s)) + (e); \
 	(c) = rol32((c), 10); \
 }
@@ -329,7 +329,7 @@ static void rmd160_final(struct crypto_tfm *tfm, u8 *out)
 
 	/* Store state in digest */
 	for (i = 0; i < 5; i++)
-		dst[i] = cpu_to_le32(rctx->state[i]);
+		dst[i] = cpu_to_le32p(&rctx->state[i]);
 
 	/* Wipe context */
 	memset(rctx, 0, sizeof(*rctx));
diff --git a/crypto/rmd256.c b/crypto/rmd256.c
index 88f2203..b088526 100644
--- a/crypto/rmd256.c
+++ b/crypto/rmd256.c
@@ -44,7 +44,7 @@ struct rmd256_ctx {
 #define F4(x, y, z) (y ^ (z & (x ^ y)))	/* z ? x : y */
 
 #define ROUND(a, b, c, d, f, k, x, s)  { \
-	(a) += f((b), (c), (d)) + le32_to_cpu(x) + (k); \
+	(a) += f((b), (c), (d)) + le32_to_cpup(&(x)) + (k); \
 	(a) = rol32((a), (s)); \
 }
 
@@ -304,7 +304,7 @@ static void rmd256_final(struct crypto_tfm *tfm, u8 *out)
 
 	/* Store state in digest */
 	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_le32(rctx->state[i]);
+		dst[i] = cpu_to_le32p(&rctx->state[i]);
 
 	/* Wipe context */
 	memset(rctx, 0, sizeof(*rctx));
diff --git a/crypto/rmd320.c b/crypto/rmd320.c
index 5b172f8..dba03ec 100644
--- a/crypto/rmd320.c
+++ b/crypto/rmd320.c
@@ -47,7 +47,7 @@ struct rmd320_ctx {
 #define F5(x, y, z) (x ^ (y | ~z))
 
 #define ROUND(a, b, c, d, e, f, k, x, s)  { \
-	(a) += f((b), (c), (d)) + le32_to_cpu(x) + (k); \
+	(a) += f((b), (c), (d)) + le32_to_cpup(&(x)) + (k); \
 	(a) = rol32((a), (s)) + (e); \
 	(c) = rol32((c), 10); \
 }
@@ -353,7 +353,7 @@ static void rmd320_final(struct crypto_tfm *tfm, u8 *out)
 
 	/* Store state in digest */
 	for (i = 0; i < 10; i++)
-		dst[i] = cpu_to_le32(rctx->state[i]);
+		dst[i] = cpu_to_le32p(&rctx->state[i]);
 
 	/* Wipe context */
 	memset(rctx, 0, sizeof(*rctx));
