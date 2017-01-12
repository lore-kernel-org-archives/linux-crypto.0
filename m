From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Thu, 12 Jan 2017 17:19:57 +0100
Message-ID: <5211147.RjDSfvrhhz@tauon.atsec.com>
References: <1486189.x0AQ4O6r2j@positron.chronox.de> <1946014.7KfpB7DN4Q@tauon.atsec.com> <20170112161759.GC19732@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55506 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750780AbdALQUE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:20:04 -0500
In-Reply-To: <20170112161759.GC19732@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 00:17:59 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jan 12, 2017 at 05:10:14PM +0100, Stephan Müller wrote:
> > Each IOCB would transpire into an independent, separate recvmsg invocation
> > without an additional sendmsg/sendpage operation. Thus, in order to
> > support
> > multiple IOCBs, all data the multiple recvmsg invocations will operate on
> > must be injected into the kernel beforehand.
> 
> I don't understand, what's wrong with:
> 
> sendmsg(fd, ...)
> aio_read(iocb1)
> sendmsg(fd, ...)
> aio_read(iocb2)

Sure, that works. But here you limit yourself to one IOCB per aio_read. But 
aio_read supports multiple IOCBs in one invocation. And this is the issue I am 
considering.

Ciao
Stephan
