From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - remove locking in async callback
Date: Tue, 7 Nov 2017 13:22:35 +0800
Message-ID: <20171107052235.GA20803@gondor.apana.org.au>
References: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com>
 <5260911.ZuXsrgFD2R@positron.chronox.de>
 <20171103132016.GB8330@gondor.apana.org.au>
 <1977235.9AvJZzduGj@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Romain Izard <romain.izard.pro@gmail.com>,
        linux-crypto@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:54256 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752080AbdKGFXK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 00:23:10 -0500
Content-Disposition: inline
In-Reply-To: <1977235.9AvJZzduGj@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 06, 2017 at 05:06:09PM +0100, Stephan Mueller wrote:
> Am Freitag, 3. November 2017, 14:20:16 CET schrieb Herbert Xu:
>
> > Are you sure about that? In particular is the callback function still
> > sane without the socket lock if a concurrent recvmsg/sendmsg call is
> > made?
> 
> I reviewed the code again and I cannot find a reason for keeping the lock. All 
> we need to ensure is that the socket exists. This is ensured with the refcount 
> of the socket released by __sock_put().

OK, I can't see why we need a lock there either.  However, the call
to __sock_put looks suspicious.  Why isn't this using sock_put?

Also the sock_hold on the caller side looks buggy.  Surely it needs
to be made before we even call the encrypt/decrypt functions rather
than after it returns EINPROGRESS at which point it may well be too
late?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
