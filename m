From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v10 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Sun, 25 Jun 2017 17:01:48 +0200
Message-ID: <9607219.d0C7pRlxys@positron.chronox.de>
References: <16464524.Q9cOxD7cVH@positron.chronox.de> <20170623061048.GA28869@gondor.apana.org.au> <13379757.uGWUeJijgc@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60366 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751008AbdFYPCA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Jun 2017 11:02:00 -0400
In-Reply-To: <13379757.uGWUeJijgc@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 23. Juni 2017, 11:06:30 CEST schrieb Stephan Müller:

Hi Herbert,

> Am Freitag, 23. Juni 2017, 08:10:48 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Wed, Jun 21, 2017 at 10:03:02PM +0200, Stephan Müller wrote:
> > > +	/* convert iovecs of output buffers into RX SGL */
> > > +	while (len < ctx->used && msg_data_left(msg)) {
> > 
> > How are we supposed to reach the wait path when ctx->used == 0?
> 
> Right.
> 
> May I ask whether that wait is correct to begin with? The recvmsg is
> protected by a lock_sock. Thus, if the code is waiting, the lock is still
> held. So, how can data be inserted into the socket by sendmsg/sendpage
> while recvmsg is waiting? Don't we have a deadlock here?

Please ignore that comment. I have implemented a new test set where the 
multithreaded operation of symmetric ciphers are tested. See [1]. Without the 
len < ctx->used, the multithreaded behavior works as intended.

I will send an update shortly.

Thanks

Ciao
Stephan

[1] https://github.com/smuellerDD/libkcapi/commit/
18fe09d7a39ecab8669f599c06a7964c18bb1a1f
