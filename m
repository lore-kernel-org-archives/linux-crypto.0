From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Fri, 13 Jan 2017 18:21:45 +0800
Message-ID: <20170113102145.GA23349@gondor.apana.org.au>
References: <1486189.x0AQ4O6r2j@positron.chronox.de>
 <1946014.7KfpB7DN4Q@tauon.atsec.com>
 <20170112161759.GC19732@gondor.apana.org.au>
 <5211147.RjDSfvrhhz@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47381 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751351AbdAMKVx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 05:21:53 -0500
Content-Disposition: inline
In-Reply-To: <5211147.RjDSfvrhhz@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 05:19:57PM +0100, Stephan Müller wrote:
>
> > I don't understand, what's wrong with:
> > 
> > sendmsg(fd, ...)
> > aio_read(iocb1)
> > sendmsg(fd, ...)
> > aio_read(iocb2)
> 
> Sure, that works. But here you limit yourself to one IOCB per aio_read. But 
> aio_read supports multiple IOCBs in one invocation. And this is the issue I am 
> considering.

Not really.  You just lay it out in the same way with lio_listio.
That is, a write followed by read, etc.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
