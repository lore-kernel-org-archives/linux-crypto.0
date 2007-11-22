From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/11] [CRYPTO] blkcipher: Merge ablkcipher and blkcipher into one option/module
Date: Thu, 22 Nov 2007 19:28:15 +0800
Message-ID: <20071122112815.GC8781@gondor.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au> <E1Iv7jl-00020C-00@gondolin.me.apana.org.au> <20071122111807.GD2444@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4181 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752060AbXKVL2S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 06:28:18 -0500
Content-Disposition: inline
In-Reply-To: <20071122111807.GD2444@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 02:18:07PM +0300, Evgeniy Polyakov wrote:
> 
> On Thu, Nov 22, 2007 at 04:48:41PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > [CRYPTO] blkcipher: Merge ablkcipher and blkcipher into one option/module
> > 
> > Now that we have the givcipher type, both blkcipher and ablkcipher algorithms
> > will use it to create givcipher objects.  As such it no longer makes sense
> > to split the system between ablkcipher and blkcipher.  In particular, both
> > ablkcipher.c and blkcipher.c would need to use the givcipher type which has
> > to reside in ablkcipher.c since it shares much code with it.
> > 
> > This patch merges the two Kconfig options as well as the modules into one.
> 
> This breaks cryptodev tree, since some devices other than cryptd selects
> CRYPTO_ABLKCIPHER.

Are you sure? The bottom hunk of that patch fixes this, no?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
