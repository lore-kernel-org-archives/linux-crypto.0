From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: shash - no kmap of zero SG
Date: Sat, 7 Oct 2017 10:44:25 +0800
Message-ID: <20171007024425.GA28489@gondor.apana.org.au>
References: <3874163.dZU00zCVt8@positron.chronox.de>
 <25135634.rNEetDmbAf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57026 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdJGCot (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 22:44:49 -0400
Content-Disposition: inline
In-Reply-To: <25135634.rNEetDmbAf@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 24, 2017 at 08:25:17AM +0200, Stephan Müller wrote:
> In case the caller provides an SG with zero data, prevent a kmap of the
> page pointed to by the SG. In this case, it is possible that the page
> does not exist.
> 
> This fixes a crash in authenc() when the plaintext is zero and thus the
> encryption operation is a noop. In this case, no input data exists that
> can be hashed. The crash is triggerable via AF_ALG from unprivileged
> user space.
> 
> Fixes: 3b2f6df08258e ("crypto: hash - Export shash through ahash")
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: <stable@vger.kernel.org>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/shash.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/shash.c b/crypto/shash.c
> index 5e31c8d776df..32d0e1806bf4 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -278,9 +278,11 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
>  	struct scatterlist *sg = req->src;
>  	unsigned int offset = sg->offset;
>  	unsigned int nbytes = req->nbytes;
> +	unsigned int process = min(sg->length,
> +				   ((unsigned int)(PAGE_SIZE)) - offset);
>  	int err;
>  
> -	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
> +	if (process && nbytes < process) {

Sorry but your patch makes no sense.  The only difference between
your patch and the status quo is when process == zero.  However,
if process is zero then the if condition cannot hold since it's
an unsigned comparison.  So how can this patch make any difference
at all?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
