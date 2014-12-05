From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] staging: crypto: fixed style errors in ablkcipher.c
Date: Fri, 5 Dec 2014 08:43:45 -0500
Message-ID: <20141205134345.GA22670@titan.lakedaemon.net>
References: <1417755976-19514-1-git-send-email-Joshua@cybercrimetech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Joshua I. James" <joshua@cybercrimetech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33345 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751252AbaLENns (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2014 08:43:48 -0500
Content-Disposition: inline
In-Reply-To: <1417755976-19514-1-git-send-email-Joshua@cybercrimetech.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Joshua,

Your subject, "[PATCH] staging: crypto: fixed style errors in
ablkcipher.c" is misleading.  'staging' is a location in the tree,
drivers/staging/, not a separate git tree.  So your subject for this
series should have been "[PATCH] crypto: ablkcipher: Cleanup minor
checkpatch error."  More below.

On Fri, Dec 05, 2014 at 02:06:16PM +0900, Joshua I. James wrote:
> From: "Joshua I. James" <joshua@cybercrimetech.com>
> 
> Fixed style errors reported by checkpatch.
> 
> WARNING: Missing a blank line after declarations
> +       u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
> +       return max(start, end_page);
> 
> WARNING: line over 80 characters
> +               scatterwalk_start(&walk->out, scatterwalk_sg_next(walk->out.sg));
> 
> WARNING: Missing a blank line after declarations
> +               int err = ablkcipher_copy_iv(walk, tfm, alignmask);
> +               if (err)

While checkpatch is correct with the above, alone they don't justify a
patch.

> ERROR: do not use assignment in if condition
> +       if ((err = crypto_register_instance(tmpl, inst))) {

imho, this one is a good cleanup.  Especially in crypto code.  I would
like to see a comment in this commit message explaining that the code
was reviewed to make sure it wasn't an actual bug, and this is indeed
just a style cleanup.

I would also explain that since it's worth doing a patch for the
checkpatch error, we may as well hit a few warnings while we are here.

> 
> Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
> ---
>  crypto/ablkcipher.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
> index 40886c4..7bbc8b4 100644
> --- a/crypto/ablkcipher.c
> +++ b/crypto/ablkcipher.c
> @@ -69,6 +69,7 @@ static inline void ablkcipher_queue_write(struct ablkcipher_walk *walk,
>  static inline u8 *ablkcipher_get_spot(u8 *start, unsigned int len)
>  {
>  	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
> +
>  	return max(start, end_page);
>  }

This one is fine.

>  
> @@ -86,7 +87,8 @@ static inline unsigned int ablkcipher_done_slow(struct ablkcipher_walk *walk,
>  		if (n == len_this_page)
>  			break;
>  		n -= len_this_page;
> -		scatterwalk_start(&walk->out, scatterwalk_sg_next(walk->out.sg));
> +		scatterwalk_start(&walk->out, scatterwalk_sg_next(
> +			walk->out.sg));

nit: I would just ignore this warning.  checkpatch just points you in a
direction, it isn't an enforcer of policy.

Especially here in crypto code, I don't like to see any changes that
make me start counting braces or otherwise looking for tricks.  Because
that means I'm questioning the submitters motivation.  The goal with
checkpatch is to make the code *more* obvious and readable.  The above
change does the opposite.

>  	}
>  
>  	return bsize;
> @@ -284,6 +286,7 @@ static int ablkcipher_walk_first(struct ablkcipher_request *req,
>  	walk->iv = req->info;
>  	if (unlikely(((unsigned long)walk->iv & alignmask))) {
>  		int err = ablkcipher_copy_iv(walk, tfm, alignmask);
> +
>  		if (err)
>  			return err;
>  	}

No problem here.

> @@ -589,7 +592,8 @@ static int crypto_givcipher_default(struct crypto_alg *alg, u32 type, u32 mask)
>  	if (IS_ERR(inst))
>  		goto put_tmpl;
>  
> -	if ((err = crypto_register_instance(tmpl, inst))) {
> +	err = crypto_register_instance(tmpl, inst);
> +	if (err) {
>  		tmpl->free(inst);
>  		goto put_tmpl;
>  	}

This is a nice cleanup that justifies doing the patch.  Just mention in
the commit message why this looks like it wasn't a bug (was it supposed
to be '==' ?) and the change makes that clear.  I'm really looking to
see that you are thinking about if the change is appropriate, not just
blindly making checkpatch shut up.

thx,

Jason.
