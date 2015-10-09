From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 3/5] crypto: marvell: initialise struct
 mv_cesa_ahash_req
Date: Fri, 9 Oct 2015 21:50:18 +0200
Message-ID: <20151009215018.344b4f70@bbrezillon>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
	<E1ZkdZv-0005If-QE@rmk-PC.arm.linux.org.uk>
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
Received: from down.free-electrons.com ([37.187.137.238]:38025 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987AbbJITuX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 15:50:23 -0400
In-Reply-To: <E1ZkdZv-0005If-QE@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Russel,

On Fri, 09 Oct 2015 20:43:43 +0100
Russell King <rmk+kernel@arm.linux.org.uk> wrote:

> When a AF_ALG fd is accepted a second time (hence hash_accept() is
> used), hash_accept_parent() allocates a new private context using
> sock_kmalloc().  This context is uninitialised.  After use of the new
> fd, we eventually end up with the kernel complaining:
> 
> marvell-cesa f1090000.crypto: dma_pool_free cesa_padding, c0627770/0 (bad dma)
> 
> where c0627770 is a random address.  Poisoning the memory allocated by
> the above sock_kmalloc() produces kernel oopses within the marvell hash
> code, particularly the interrupt handling.
> 
> The following simplfied call sequence occurs:
> 
> hash_accept()
>   crypto_ahash_export()
>     marvell hash export function
>   af_alg_accept()
>     hash_accept_parent()	<== allocates uninitialised struct hash_ctx
>   crypto_ahash_import()
>     marvell hash import function
> 
> hash_ctx contains the struct mv_cesa_ahash_req in its req.__ctx member,
> and, as the marvell hash import function only partially initialises
> this structure, we end up with a lot of members which are left with
> whatever data was in memory prior to sock_kmalloc().
> 
> Add zero-initialisation of this structure.

Maybe you should also change your commit message since this patch no
longer initializes the req struct to zero, otherwise

Acked-by: Boris Brezillon <boris.brezillon@free-electronc.com>

> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/crypto/marvell/hash.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index a259aced3b42..458867ce9515 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -831,6 +831,10 @@ static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
>  	unsigned int cache_ptr;
>  	int ret;
>  
> +	ret = crypto_ahash_init(req);
> +	if (ret)
> +		return ret;
> +
>  	creq->len = in_state->byte_count;
>  	memcpy(creq->state, in_state->hash, digsize);
>  	creq->cache_ptr = 0;
> @@ -921,6 +925,10 @@ static int mv_cesa_sha1_import(struct ahash_request *req, const void *in)
>  	unsigned int cache_ptr;
>  	int ret;
>  
> +	ret = crypto_ahash_init(req);
> +	if (ret)
> +		return ret;
> +
>  	creq->len = in_state->count;
>  	memcpy(creq->state, in_state->state, digsize);
>  	creq->cache_ptr = 0;
> @@ -1022,6 +1030,10 @@ static int mv_cesa_sha256_import(struct ahash_request *req, const void *in)
>  	unsigned int cache_ptr;
>  	int ret;
>  
> +	ret = crypto_ahash_init(req);
> +	if (ret)
> +		return ret;
> +
>  	creq->len = in_state->count;
>  	memcpy(creq->state, in_state->state, digsize);
>  	creq->cache_ptr = 0;



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
