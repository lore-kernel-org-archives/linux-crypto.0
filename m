From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Fri, 13 Jan 2017 11:49:05 +0100
Message-ID: <1588177.ehMkkoOMrj@positron.chronox.de>
References: <1486189.x0AQ4O6r2j@positron.chronox.de> <5211147.RjDSfvrhhz@tauon.atsec.com> <20170113102145.GA23349@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55518 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751948AbdAMKtT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 05:49:19 -0500
In-Reply-To: <20170113102145.GA23349@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 18:21:45 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jan 12, 2017 at 05:19:57PM +0100, Stephan Müller wrote:
> > > I don't understand, what's wrong with:
> > > 
> > > sendmsg(fd, ...)
> > > aio_read(iocb1)
> > > sendmsg(fd, ...)
> > > aio_read(iocb2)
> > 
> > Sure, that works. But here you limit yourself to one IOCB per aio_read.
> > But
> > aio_read supports multiple IOCBs in one invocation. And this is the issue
> > I am considering.
> 
> Not really.  You just lay it out in the same way with lio_listio.
> That is, a write followed by read, etc.

According to the man page of lio_listio(3) the provided AIO operations are 
executed in an unspecified order. I would infer from that statement that even 
if an order of write / read / write / read is defined by the caller, this 
order may not be followed by the kernel. Thus we would need to consider the 
case that in the end, algif has to process the order of write / write / read / 
read or any other order.

Besides, the crashes I reported for the current AIO implementation in 
algif_aead and algif_skcipher are always triggered when invoking an aio_read 
with two or more IOCBs. The most important aspect I want to cover with the 
patch set is to stop crashing the kernel.

Ciao
Stephan
