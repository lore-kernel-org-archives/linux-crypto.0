Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5E838F97;
	Sun,  1 Sep 2024 08:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725177960; cv=none; b=rCey6oRa5AHCazj30tAbsWeKGgEDsUZYyEcaTRqqY7LXZ1HgSiT9JiYeAfuIHGjlQxVYaeUKk68vPKmE9RCtxskY9cfTdpX0cC9X9gNveQx33kgJ4WrYE00fRRhm6aGBTdzBNEF8HQN+UtitySq0Lh3/VUdbBu2lX7Cuop7tWSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725177960; c=relaxed/simple;
	bh=S9hbHthucJpN28Os4zB8wkhuRUyEcaQaVhH2kdHX3QY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5r+9T9m2kt7WGLlyRlD92OUA7cdQudpgvTbRKbmrBU2ge2kv1+3yxMsxlYcLl+mzoD+kvrq/ooGGLdNruUTeOSJ9UBEIXr+gGxWna/H9W6X4woxp9E+tsmaFbabrpaVp6PCiQdkbHXGt7awsl+hh1jupSD1cebCAPIN+5A7BY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1skfSB-008rgH-2v;
	Sun, 01 Sep 2024 16:05:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 01 Sep 2024 16:05:40 +0800
Date: Sun, 1 Sep 2024 16:05:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org, ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: api - Fix generic algorithm self-test races
Message-ID: <ZtQgVOnK6WzdIDlU@gondor.apana.org.au>
References: <ZrbTUk6DyktnO7qk@gondor.apana.org.au>
 <202408161634.598311fd-oliver.sang@intel.com>
 <ZsBJs_C6GdO_qgV7@gondor.apana.org.au>
 <ZsBJ5H4JExArHGVw@gondor.apana.org.au>
 <ZsBKG0la0m69Dyq3@gondor.apana.org.au>
 <20240827184839.GD2049@sol.localdomain>
 <Zs6SiBOdasO9Thd1@gondor.apana.org.au>
 <20240830175154.GA48019@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830175154.GA48019@sol.localdomain>

On Fri, Aug 30, 2024 at 10:51:54AM -0700, Eric Biggers wrote:
>
> Given below in defconfig form, use 'make olddefconfig' to apply.  The failures
> are nondeterministic and sometimes there are different ones, for example:
> 
> [    0.358017] alg: skcipher: failed to allocate transform for cbc(twofish-generic): -2
> [    0.358365] alg: self-tests for cbc(twofish) using cbc(twofish-generic) failed (rc=-2)
> [    0.358535] alg: skcipher: failed to allocate transform for cbc(camellia-generic): -2
> [    0.358918] alg: self-tests for cbc(camellia) using cbc(camellia-generic) failed (rc=-2)
> [    0.371533] alg: skcipher: failed to allocate transform for xts(ecb(aes-generic)): -2
> [    0.371922] alg: self-tests for xts(aes) using xts(ecb(aes-generic)) failed (rc=-2)
> 
> Modules are not enabled, maybe that matters (I haven't checked yet).

Yes I think that was the key.  This triggers a massive self-test
run which executes in parallel and reveals a few race conditions
in the system.  I think it boils down to the following scenario:

Base algorithm X-generic, X-optimised
Template Y
Optimised algorithm Y-X-optimised

Everything gets registered, and then the self-tests are started.
When Y-X-optimised gets tested, it requests the creation of the
generic Y(X-generic).  Which then itself undergoes testing.

The race is that after Y(X-generic) gets registered, but just
before it gets tested, X-optimised finally finishes self-testing
which then causes all spawns of X-generic to be destroyed.  So
by the time the self-test for Y(X-generic) comes along, it can
no longer find the algorithm.  This error then bubbles up all
the way up to the self-test of Y-X-optimised which then fails.

Note that there is some complexity that I've omitted here because
when the generic self-test fails to find Y(X-generic) it actually
triggers the construction of it again which then fails for various
other reasons (these are not important because the construction
should *not* be triggered at this point).

So in a way the error is expected, and we should probably remove
the pr_err for the case where ENOENT is returned for the algorithm
that we're currently testing.

The solution is two-fold.  First when an algorithm undergoes
self-testing it should not trigger its construction.  Secondly
if an instance larval fails to materialise due to it being destroyed
by a more optimised algorithm coming along, it should obviously
retry the construction.

Remove the check in __crypto_alg_lookup that stops a larval from
matching new requests based on differences in the mask.  It is better
to block new requests even if it is wrong and then simply retry the
lookup.  If this ends up being the wrong larval it will sort iself
out during the retry.

Reduce the CRYPTO_ALG_TYPE_MASK bits in type during larval creation
as otherwise LSKCIPHER algorithms may not match SKCIPHER larvals.

Also block the instance creation during self-testing in the function
crypto_larval_lookup by checking for CRYPTO_ALG_TESTED in the mask
field.

Finally change the return value when crypto_alg_lookup fails in
crypto_larval_wait to EAGAIN to redo the lookup.

Fixes: 37da5d0ffa7b ("crypto: api - Do not wait for tests during registration")
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/api.c b/crypto/api.c
index bbe29d438815..bfd177a4313a 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -70,11 +70,6 @@ static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 		if ((q->cra_flags ^ type) & mask)
 			continue;
 
-		if (crypto_is_larval(q) &&
-		    !crypto_is_test_larval((struct crypto_larval *)q) &&
-		    ((struct crypto_larval *)q)->mask != mask)
-			continue;
-
 		exact = !strcmp(q->cra_driver_name, name);
 		fuzzy = !strcmp(q->cra_name, name);
 		if (!exact && !(fuzzy && q->cra_priority > best))
@@ -113,6 +108,8 @@ struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
 	if (!larval)
 		return ERR_PTR(-ENOMEM);
 
+	type &= ~CRYPTO_ALG_TYPE_MASK | (mask ?: CRYPTO_ALG_TYPE_MASK);
+
 	larval->mask = mask;
 	larval->alg.cra_flags = CRYPTO_ALG_LARVAL | type;
 	larval->alg.cra_priority = -1;
@@ -229,7 +226,7 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 		type = alg->cra_flags & ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
 		mask = larval->mask;
 		alg = crypto_alg_lookup(alg->cra_name, type, mask) ?:
-		      ERR_PTR(-ENOENT);
+		      ERR_PTR(-EAGAIN);
 	} else if (IS_ERR(alg))
 		;
 	else if (crypto_is_test_larval(larval) &&
@@ -308,8 +305,12 @@ static struct crypto_alg *crypto_larval_lookup(const char *name, u32 type,
 
 	if (!IS_ERR_OR_NULL(alg) && crypto_is_larval(alg))
 		alg = crypto_larval_wait(alg);
-	else if (!alg)
+	else if (alg)
+		;
+	else if (!(mask & CRYPTO_ALG_TESTED))
 		alg = crypto_larval_add(name, type, mask);
+	else
+		alg = ERR_PTR(-ENOENT);
 
 	return alg;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
