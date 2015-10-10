From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Sat, 10 Oct 2015 18:46:07 +0200
Message-ID: <20151010184607.353cb5f3@bbrezillon>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
	<E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:47808 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752107AbbJJQqW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Oct 2015 12:46:22 -0400
In-Reply-To: <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 09 Oct 2015 20:43:33 +0100
Russell King <rmk+kernel@arm.linux.org.uk> wrote:

> If the algorithm passed a zero statesize, do not pass a valid pointer
> into the export/import functions.  Passing a valid pointer covers up
> bugs in driver code which then go on to smash the kernel stack.
> Instead, pass NULL, which will cause any attempt to write to the
> pointer to fail.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  crypto/ahash.c | 3 ++-
>  crypto/shash.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index 8acb886032ae..9c1dc8d6106a 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -544,7 +544,8 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
>  	struct crypto_alg *base = &alg->halg.base;
>  
>  	if (alg->halg.digestsize > PAGE_SIZE / 8 ||
> -	    alg->halg.statesize > PAGE_SIZE / 8)
> +	    alg->halg.statesize > PAGE_SIZE / 8 ||
> +	    alg->halg.statesize == 0)

Just read Russel's answer to the cover letter, and I wonder if the
following test wouldn't fix the problem:

	    (alg->halg.statesize == 0 && (alg->import || alg->export))

I mean, the only valid case where statesize can be zero is when you
don't have any state associated to the crypto algorithm, and if that's
the case, ->import() and ->export() functions are useless, isn't ?

Best Regards,

Boris

>  		return -EINVAL;
>  
>  	base->cra_type = &crypto_ahash_type;
> diff --git a/crypto/shash.c b/crypto/shash.c
> index ecb1e3d39bf0..ab3384b38542 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -585,7 +585,8 @@ static int shash_prepare_alg(struct shash_alg *alg)
>  
>  	if (alg->digestsize > PAGE_SIZE / 8 ||
>  	    alg->descsize > PAGE_SIZE / 8 ||
> -	    alg->statesize > PAGE_SIZE / 8)
> +	    alg->statesize > PAGE_SIZE / 8 ||
> +	    alg->statesize == 0)
>  		return -EINVAL;
>  
>  	base->cra_type = &crypto_shash_type;



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
