From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG - remove locking in async callback
Date: Fri, 03 Nov 2017 14:34:44 +0100
Message-ID: <1516308.8nf3SO2l11@tauon.chronox.de>
References: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com> <5260911.ZuXsrgFD2R@positron.chronox.de> <20171103132016.GB8330@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Romain Izard <romain.izard.pro@gmail.com>,
        linux-crypto@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42108 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756215AbdKCNer (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 09:34:47 -0400
In-Reply-To: <20171103132016.GB8330@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 3. November 2017, 14:20:16 CET schrieb Herbert Xu:

Hi Herbert,

> On Sun, Oct 29, 2017 at 09:39:30PM +0100, Stephan Müller wrote:
> > Am Mittwoch, 25. Oktober 2017, 17:26:31 CET schrieb Romain Izard:
> > 
> > Hi Romain,
> > 
> > the patch below should cover the issue you see. Would you mind testing it?
> > 
> > Thanks
> > Stephan
> > 
> > ---8<---
> > 
> > The code paths protected by the socket-lock do not use or modify the
> > socket in a non-atomic fashion. The actions pertaining the socket do not
> > even need to be handled as an atomic operation. Thus, the socket-lock
> > can be safely ignored.
> 
> Are you sure about that? In particular is the callback function still
> sane without the socket lock if a concurrent recvmsg/sendmsg call is
> made?

resultlen receives its data from the async_request -> no socket

af_alg_free_areq_sgls(areq) does not require a socket, but it uses the socket 
to find the data structures -> I do not see that the socket is operated on 
though. The socket will always be alive as the sk_refcnt is not yet 
decremented by __sock_put.

sock_kfree_s uses an atomic operation

__sock_put uses an atomic operation

iocb->ki_complete does not use the socket

Where would you think that the lock is needed?
> 
> Your fixes header is wrong too as the locks weren't introduced in that
> commit, they just got moved around.

Neither the skcipher_async_cb nor aead_async_cb up to and including 4.13 
contain any lock.

Ciao
Stephan
