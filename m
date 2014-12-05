From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] staging: crypto: fixed style error in ahash.c
Date: Fri, 5 Dec 2014 08:54:40 -0500
Message-ID: <20141205135440.GD22670@titan.lakedaemon.net>
References: <1417758294-22850-1-git-send-email-Joshua@cybercrimetech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Joshua I. James" <joshua@cybercrimetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25033 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaLENyn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2014 08:54:43 -0500
Content-Disposition: inline
In-Reply-To: <1417758294-22850-1-git-send-email-Joshua@cybercrimetech.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 05, 2014 at 02:44:54PM +0900, Joshua I. James wrote:
> From: "Joshua I. James" <joshua@cybercrimetech.com>
> 
> Fixed style error identified by checkpatch.
> 
> WARNING: Missing a blank line after declarations
> +               unsigned int unaligned = alignmask + 1 - (offset & alignmask);
> +               if (nbytes > unaligned)
> 
> Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
> ---
>  crypto/ahash.c | 1 +
>  1 file changed, 1 insertion(+)

Same comment as the third patch.

thx,

Jason.

> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index f6a36a5..dd28906 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -55,6 +55,7 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
>  
>  	if (offset & alignmask) {
>  		unsigned int unaligned = alignmask + 1 - (offset & alignmask);
> +
>  		if (nbytes > unaligned)
>  			nbytes = unaligned;
>  	}
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
