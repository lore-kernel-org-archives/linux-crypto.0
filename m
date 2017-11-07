From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG - remove locking in async callback
Date: Tue, 07 Nov 2017 07:19:32 +0100
Message-ID: <4677171.2qOLUIFS1s@positron.chronox.de>
References: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com> <1977235.9AvJZzduGj@tauon.chronox.de> <20171107052235.GA20803@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Romain Izard <romain.izard.pro@gmail.com>,
        linux-crypto@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42170 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbdKGGTf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 01:19:35 -0500
In-Reply-To: <20171107052235.GA20803@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 7. November 2017, 06:22:35 CET schrieb Herbert Xu:

Hi Herbert,

> On Mon, Nov 06, 2017 at 05:06:09PM +0100, Stephan Mueller wrote:
> > Am Freitag, 3. November 2017, 14:20:16 CET schrieb Herbert Xu:
> > > Are you sure about that? In particular is the callback function still
> > > sane without the socket lock if a concurrent recvmsg/sendmsg call is
> > > made?
> > 
> > I reviewed the code again and I cannot find a reason for keeping the lock.
> > All we need to ensure is that the socket exists. This is ensured with the
> > refcount of the socket released by __sock_put().
> 
> OK, I can't see why we need a lock there either.  However, the call
> to __sock_put looks suspicious.  Why isn't this using sock_put?

I simply ported the existing code from algif_aead over -- but I think you are 
right that sock_put is more appropriate.
> 
> Also the sock_hold on the caller side looks buggy.  Surely it needs
> to be made before we even call the encrypt/decrypt functions rather
> than after it returns EINPROGRESS at which point it may well be too
> late?

I would concur. The sock_hold would need to be moved from the EINPROGRESS 
conditional to before the AIO enc/dec operation is invoked.

Where I am not fully sure is whether af_alg_async_cb is called in any case. 
I.e. when we invoke an AIO operation with a cipher that completes 
synchronously (e.g. AES-NI), is this callback triggered?

Ciao
Stephan
