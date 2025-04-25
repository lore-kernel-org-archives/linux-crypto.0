Received: from abb.hmeau.com (unknown [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429EF15E96;
	Fri, 25 Apr 2025 03:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745552030; cv=none; b=jG0rEH0gkl/NowNZtt+PhyPnVwJJr5Pg+dQ6h43i8jq8RFn/BPfOpdXPGLE2YtJwPGvK+pwcKXXfn/e2nNdZIjJ2nqM/lhebp/uDOjboY/kcjc33OW2mysAp71DNmdfnDYJO3Nrs818QY/6g5oLGGrmYG7fvvCAKfiHBKefiI9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745552030; c=relaxed/simple;
	bh=ILDSNG4BN8ua/52/v6nO5dC/RbrN54agJN769FpTzq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oM+u7SDlZVAbTJ9QC9aTHUzbhlkIQYbvhgcvEZTi84DGYgbSAN+LBa1AcwbsqJO9Sy82WjZMru7lbtwQU8Gm+4OIhilytMyN7LOMKteuIBVHxGYVgE80rcLRMA3/fwC9u2fhaaDQxgbtXhN0E2SIstWKhRik/AcqEFMOc8k9aww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IFOEqFW+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IFOEqFW+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9+Echb/h9/wd7jtQ2NLKCLnG8Ibee6Bmh6epZ6KbK9Y=; b=IFOEqFW+37ViTyv1v69K/h9/OE
	DiYHDdJTeyLfxoOz6ZrZnj5KpbtnXG9iSMFlmF7TM9bJ27pA9OzfXbejWtFv3ZziAvUz7ZshPSJUz
	miMCL8oe400BXHK7cy+EXavI4mL5UbxG+aiQdiGNFwKy2jiPebtYI7Uu/LaXkVtVvBF2DnL/hUX9Y
	bvF1he9YUx/k6zxN0e0l5j77EYMBQ2bA8Fm2ipGRGMIvqPaZ0I7gXOKC/t6p9CYaL/jHGQv/2PuCA
	mzCCEEm5G5zMg2gDl8ClLVJwjaQB5Dcsa9hS2knMnAvI4/l6GZt4SVNCBmLOCkO8SMI/MSlZbf7rz
	0FTdqamg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u89op-000ruh-1W;
	Fri, 25 Apr 2025 11:33:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 11:33:39 +0800
Date: Fri, 25 Apr 2025 11:33:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: arm/blake2b - Set FINAL_NONZERO
Message-ID: <aAsCk3jtbAE7dPpJ@gondor.apana.org.au>
References: <aAop_uMhxVh2l5Fy@Red>
 <aApN64n7i15ArnX4@gondor.apana.org.au>
 <aAqhbdiLmkHV350S@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAqhbdiLmkHV350S@Red>

On Thu, Apr 24, 2025 at 10:39:09PM +0200, Corentin Labbe wrote:
>
> Thanks it fixes my crypto hw devices.
> So Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>

What about the sha1-ce failure on arm64? Did that go away too?

That didn't seem related to crypto_engine.

> But I still got some crash with blake2b:
> +[   54.348477] alg: shash: blake2b-256-neon test failed (wrong result) on test vector 1, cfg="init+update+final aligned buffer"
> +[   54.348525] alg: self-tests for blake2b-256 using blake2b-256-neon failed (rc=-22)
> +[   54.348536] ------------[ cut here ]------------

OK this is easy, I left out the FINAL_NONZERO bit in the arm patch:

---8<---
Set FINAL_NONZERO as blake2b expects to have at least one byte for
finalisation.

Reported-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Fixes: cc28260ab4fb ("crypto: arm/blake2b - Use API partial block handling")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm/crypto/blake2b-neon-glue.c b/arch/arm/crypto/blake2b-neon-glue.c
index 7ae4ba0afe06..2ff443a91724 100644
--- a/arch/arm/crypto/blake2b-neon-glue.c
+++ b/arch/arm/crypto/blake2b-neon-glue.c
@@ -52,7 +52,8 @@ static int crypto_blake2b_finup_neon(struct shash_desc *desc, const u8 *in,
 		.base.cra_driver_name	= driver_name,			\
 		.base.cra_priority	= 200,				\
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY |	\
-					  CRYPTO_AHASH_ALG_BLOCK_ONLY,	\
+					  CRYPTO_AHASH_ALG_BLOCK_ONLY |	\
+					  CRYPTO_AHASH_ALG_FINAL_NONZERO, \
 		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,		\
 		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx), \
 		.base.cra_module	= THIS_MODULE,			\
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
