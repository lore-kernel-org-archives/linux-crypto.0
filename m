From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Fri, 13 Jan 2017 12:10:02 +0100
Message-ID: <5603535.pO8F2Xs7xC@positron.chronox.de>
References: <1486189.x0AQ4O6r2j@positron.chronox.de> <1588177.ehMkkoOMrj@positron.chronox.de> <20170113110335.GA23617@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55526 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751350AbdAMLKL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:10:11 -0500
In-Reply-To: <20170113110335.GA23617@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 19:03:35 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 13, 2017 at 11:49:05AM +0100, Stephan Müller wrote:
> > According to the man page of lio_listio(3) the provided AIO operations are
> > executed in an unspecified order. I would infer from that statement that
> > even if an order of write / read / write / read is defined by the caller,
> > this order may not be followed by the kernel. Thus we would need to
> > consider the case that in the end, algif has to process the order of
> > write / write / read / read or any other order.
> 
> Well if ordering is not guaranteed that I don't see how your code
> can work either.  Or am I missing something?

The patch simply stores all data it gets from sendmsg in the src SGL. In 
addition it maintains an offset pointer into that src SGLs.

When the recvmsg call comes in and the dst SGL is prepared, it simply takes as 
much data from the src SGL as needed to cover the request defined by the dst 
SGL. After completing that operation, the offset pointer is moved forward to 
point to a yet unused part of the src SGL. If another recvmsg comes in without 
an intermediate sendmsg, it simply starts using the data from the src SGL 
starting from the offset.

Therefore, the code should now be able to handle a write / write / read / read 
scenario. Or it can handle, say, a write(32 bytes) / read (16 bytes) / read 
(16 bytes). At least my tests covered a successful testing of that scenario 
which always crashed the kernel before.

Ciao
Stephan
