From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: crypto_remove_spawns: BUG: unable to handle kernel NULL
 pointer dereference at 0000000000000018
Date: Tue, 16 Feb 2010 21:31:39 +0200
Message-ID: <20100216193139.GA5512@x200>
References: <20100214174507.GA8688@x200>
 <20100215052729.GA17156@gondor.apana.org.au>
 <b6fcc0a1002142347n1aff4326p3275e70b0ecea0e3@mail.gmail.com>
 <20100215081155.GA18566@gondor.apana.org.au>
 <b6fcc0a1002150014j43415772mea21790c0667a32b@mail.gmail.com>
 <20100216120203.GA32264@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:36436 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab0BPTbq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 14:31:46 -0500
Received: by fxm7 with SMTP id 7so7619249fxm.28
        for <linux-crypto@vger.kernel.org>; Tue, 16 Feb 2010 11:31:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20100216120203.GA32264@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 16, 2010 at 08:02:03PM +0800, Herbert Xu wrote:
> On Mon, Feb 15, 2010 at 10:14:08AM +0200, Alexey Dobriyan wrote:
> > 
> > Yes, ipcomp bug triggers almost immediately.
> > Anyway, this is just description of what I do.
> 
> Can you see if this patch makes it go away?
> 
> This can happen when you're unloading aes just as an algorithm
> that uses aes (such as cbc(aes)) is being created.

Which codepath exactly?
I'd say try_module_get() should fail somewhere.

BTW, CBC or AES aren't used, just loaded.

Here is setkey script:

	#!/usr/sbin/setkey -f
	flush;
	spdflush;
	
	add A B ipcomp 44 -m tunnel -C deflate;
	add B A ipcomp 45 -m tunnel -C deflate;
	
	spdadd A B any -P in ipsec
	        ipcomp/tunnel/192.168.1.2-192.168.1.3/use;
	
	spdadd B A any -P out ipsec
	        ipcomp/tunnel/192.168.1.3-192.168.1.2/use;
 
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -165,6 +165,8 @@ static void crypto_remove_spawns(struct crypto_alg *alg,
>  
>  			spawn->alg = NULL;
>  			spawns = &inst->alg.cra_users;
> +			if (!spawns->next)
> +				break;
>  		}
>  	} while ((spawns = crypto_more_spawns(alg, &stack, &top,
>  					      &secondary_spawns)));
