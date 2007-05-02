From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/6] [CRYPTO] cryptd: Add software async crypto daemon
Date: Wed, 2 May 2007 14:57:21 +1000
Message-ID: <20070502045721.GC29384@gondor.apana.org.au>
References: <<20070416105105.GA10188@gondor.apana.org.au>> <E1HdOom-0002uK-00@gondolin.me.apana.org.au> <20070501142329.GA3490@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4180 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992738AbXEBE5b (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 May 2007 00:57:31 -0400
Content-Disposition: inline
In-Reply-To: <20070501142329.GA3490@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Evgeniy:

On Tue, May 01, 2007 at 06:23:29PM +0400, Evgeniy Polyakov wrote:
>
> As far as I understand, this callback is called each time new tfm is
> going to be created? And it is called for each crypto_template

cryptd_blkcipher_init_tfm/cryptd_blkcipher_exit_tfm are per-tfm while
cryptd_alloc_blkcipher/cryptd_alloc are per-instance.

> registered in the system, so it is task of the template to detect that
> requested cypher tb[crypto_alg-1] is not supported by template.
> Am I correct?

If the requested instance is not supported by this template then we'll
just fail in cryptd_alloc.  Right now only BLKCIPHER cipher is supported
so everything else will simply fail.

> If so, could it be better to have set of flags for template which would
> show which operations are supported?
> For example HIFH adapter can not perform blowfish encryption, but it
> will be requested to do so each time new tfm is being requested, if my
> analysis correct...

Sorry, I think I've misled you there.  For something like the HIFH
adapter you wouldn't do a template at all (well, not until we start
expressing supported key lengths through templates).

You'd simply register an algorithm of type BLKCIPHER | CRYPTO_ALG_ASYNC
for each algorithm that you support.  You'd set the name of each of these
according to their algorithm.  So for example AES would just be registered
as "aes" (of course, you'd set your driver name differently).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
