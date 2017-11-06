From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG - remove locking in async callback
Date: Mon, 06 Nov 2017 17:06:09 +0100
Message-ID: <1977235.9AvJZzduGj@tauon.chronox.de>
References: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com> <5260911.ZuXsrgFD2R@positron.chronox.de> <20171103132016.GB8330@gondor.apana.org.au>
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
Received: from mail.eperm.de ([89.247.134.16]:42152 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753822AbdKFQGN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 11:06:13 -0500
In-Reply-To: <20171103132016.GB8330@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 3. November 2017, 14:20:16 CET schrieb Herbert Xu:

Hi Herbert,

> > 
> > The code paths protected by the socket-lock do not use or modify the
> > socket in a non-atomic fashion. The actions pertaining the socket do not
> > even need to be handled as an atomic operation. Thus, the socket-lock
> > can be safely ignored.
> 
> Are you sure about that? In particular is the callback function still
> sane without the socket lock if a concurrent recvmsg/sendmsg call is
> made?

I reviewed the code again and I cannot find a reason for keeping the lock. All 
we need to ensure is that the socket exists. This is ensured with the refcount 
of the socket released by __sock_put().

Would you mind helping me where you think the lock is needed.
> 
> Your fixes header is wrong too as the locks weren't introduced in that
> commit, they just got moved around.

Correct, the initial introduction was in 
e870456d8e7c8d57c059ea479b5aadbb55ff4c3a (algif_skcipher) and 
d887c52d6ae43aeebd249b5f2f1333e60236aa60 (algif_aead)

Thanks a lot.

Ciao
Stephan
