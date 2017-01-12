From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Fri, 13 Jan 2017 00:17:59 +0800
Message-ID: <20170112161759.GC19732@gondor.apana.org.au>
References: <1486189.x0AQ4O6r2j@positron.chronox.de>
 <2701907.5SyJthQSdc@tauon.atsec.com>
 <20170112160739.GB19577@gondor.apana.org.au>
 <1946014.7KfpB7DN4Q@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47047 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750832AbdALQSR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:18:17 -0500
Content-Disposition: inline
In-Reply-To: <1946014.7KfpB7DN4Q@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 05:10:14PM +0100, Stephan Müller wrote:
>
> Each IOCB would transpire into an independent, separate recvmsg invocation 
> without an additional sendmsg/sendpage operation. Thus, in order to support 
> multiple IOCBs, all data the multiple recvmsg invocations will operate on must 
> be injected into the kernel beforehand.

I don't understand, what's wrong with:

sendmsg(fd, ...)
aio_read(iocb1)
sendmsg(fd, ...)
aio_read(iocb2)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
