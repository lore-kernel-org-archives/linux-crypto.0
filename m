From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 5/6] [CRYPTO] cryptd: Add software async crypto daemon
Date: Wed, 2 May 2007 13:14:33 +0400
Message-ID: <20070502091433.GA31022@2ka.mipt.ru>
References: <<20070416105105.GA10188@gondor.apana.org.au>> <E1HdOom-0002uK-00@gondolin.me.apana.org.au> <20070501142329.GA3490@2ka.mipt.ru> <20070502045721.GC29384@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:60321 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161000AbXEBJOt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 May 2007 05:14:49 -0400
Content-Disposition: inline
In-Reply-To: <20070502045721.GC29384@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 02, 2007 at 02:57:21PM +1000, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > For example HIFH adapter can not perform blowfish encryption, but it
> > will be requested to do so each time new tfm is being requested, if my
> > analysis correct...
> 
> Sorry, I think I've misled you there.  For something like the HIFH
> adapter you wouldn't do a template at all (well, not until we start
> expressing supported key lengths through templates).
> 
> You'd simply register an algorithm of type BLKCIPHER | CRYPTO_ALG_ASYNC
> for each algorithm that you support.  You'd set the name of each of these
> according to their algorithm.  So for example AES would just be registered
> as "aes" (of course, you'd set your driver name differently).

I.e. do not use uncommented^Wencrypted cryptd source, but just write a
driver with couple of algorithms with magic CRYPTO_ALG_ASYNC bit set in
its flags? That would be much simpler.
I will start from that point, thans Herbert.

> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
	Evgeniy Polyakov
