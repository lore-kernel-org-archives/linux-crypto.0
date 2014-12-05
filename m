From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] staging: crypto: fixed style error in aead.c
Date: Fri, 5 Dec 2014 08:47:52 -0500
Message-ID: <20141205134752.GB22670@titan.lakedaemon.net>
References: <1417757084-32155-1-git-send-email-Joshua@cybercrimetech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Joshua I. James" <joshua@cybercrimetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16504 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaLENr5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2014 08:47:57 -0500
Content-Disposition: inline
In-Reply-To: <1417757084-32155-1-git-send-email-Joshua@cybercrimetech.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Joshua,

On Fri, Dec 05, 2014 at 02:24:44PM +0900, Joshua I. James wrote:
> From: "Joshua I. James" <joshua@cybercrimetech.com>
> 
> Fixed style error identified by checkpatch.
> 
> ERROR: do not use assignment in if condition
> +       if ((err = crypto_register_instance(tmpl, inst))) {

Short comment needed here like I mentioned with the first patch.  Also,
subject line needs corrected as with the first.

> 
> Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
> ---
>  crypto/aead.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/aead.c b/crypto/aead.c
> index 547491e..2222710 100644
> --- a/crypto/aead.c
> +++ b/crypto/aead.c
> @@ -448,7 +448,8 @@ static int crypto_nivaead_default(struct crypto_alg *alg, u32 type, u32 mask)
>  	if (IS_ERR(inst))
>  		goto put_tmpl;
>  
> -	if ((err = crypto_register_instance(tmpl, inst))) {
> +	err = crypto_register_instance(tmpl, inst);
> +	if (err) {
>  		tmpl->free(inst);
>  		goto put_tmpl;
>  	}

I haven't looked at the rest of the series yet, but if they are just
like this one, Herbert may prefer just to put these all in one patch.
I'll add him to the To: and you should wait for his response.

thx,

Jason.
