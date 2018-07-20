From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] crypto: Remove mcryptd
Date: Fri, 20 Jul 2018 11:53:25 +0800
Message-ID: <20180720035325.m5tzeuqsfej3y6wd@gondor.apana.org.au>
References: <1526089453-6542-1-git-send-email-megha.dey@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        megha.dey@intel.com
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526089453-6542-1-git-send-email-megha.dey@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 11, 2018 at 06:44:13PM -0700, Megha Dey wrote:
>
> +static struct ahash_alg *simd_ahash_create_compat(const char *algname,
> +						       const char *drvname,
> +						       const char *basename)
> +{
> +	struct ahash_alg *alg;
> +	struct ahash_alg *ialg;
> +	int err;

I think there has been a misunderstsanding.  You're not actually
using the simd wrapper here.  All you're doing is creating a function
with the word simd in its name.  In all other respects this is just
exposing the underlying algorithm to users directly, which cannot
work because the underlying algorithm requires SIMD.

What you need to do is create an actual simd wrapper with cryptd
and all the functions that may do SIMD work needs to invoke cryptd
if may_use_simd() (and other conditions) is false.

This wrapper should live in crypto/simd.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
