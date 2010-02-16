From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_remove_spawns: BUG: unable to handle kernel NULL
	pointer dereference at 0000000000000018
Date: Tue, 16 Feb 2010 20:02:03 +0800
Message-ID: <20100216120203.GA32264@gondor.apana.org.au>
References: <20100214174507.GA8688@x200> <20100215052729.GA17156@gondor.apana.org.au> <b6fcc0a1002142347n1aff4326p3275e70b0ecea0e3@mail.gmail.com> <20100215081155.GA18566@gondor.apana.org.au> <b6fcc0a1002150014j43415772mea21790c0667a32b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46934 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754345Ab0BPMCI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 07:02:08 -0500
Content-Disposition: inline
In-Reply-To: <b6fcc0a1002150014j43415772mea21790c0667a32b@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 15, 2010 at 10:14:08AM +0200, Alexey Dobriyan wrote:
> 
> Yes, ipcomp bug triggers almost immediately.
> Anyway, this is just description of what I do.

Can you see if this patch makes it go away?

This can happen when you're unloading aes just as an algorithm
that uses aes (such as cbc(aes)) is being created.

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f149b1c..88c5f6c 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -165,6 +165,8 @@ static void crypto_remove_spawns(struct crypto_alg *alg,
 
 			spawn->alg = NULL;
 			spawns = &inst->alg.cra_users;
+			if (!spawns->next)
+				break;
 		}
 	} while ((spawns = crypto_more_spawns(alg, &stack, &top,
 					      &secondary_spawns)));

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
