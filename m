From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Fri, 13 Jan 2017 19:12:59 +0800
Message-ID: <20170113111259.GA23800@gondor.apana.org.au>
References: <1486189.x0AQ4O6r2j@positron.chronox.de>
 <1588177.ehMkkoOMrj@positron.chronox.de>
 <20170113110335.GA23617@gondor.apana.org.au>
 <5603535.pO8F2Xs7xC@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48083 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751356AbdAMLNF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:13:05 -0500
Content-Disposition: inline
In-Reply-To: <5603535.pO8F2Xs7xC@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 12:10:02PM +0100, Stephan Müller wrote:
>
> > Well if ordering is not guaranteed that I don't see how your code
> > can work either.  Or am I missing something?
> 
> The patch simply stores all data it gets from sendmsg in the src SGL. In 
> addition it maintains an offset pointer into that src SGLs.
> 
> When the recvmsg call comes in and the dst SGL is prepared, it simply takes as 
> much data from the src SGL as needed to cover the request defined by the dst 
> SGL. After completing that operation, the offset pointer is moved forward to 
> point to a yet unused part of the src SGL. If another recvmsg comes in without 
> an intermediate sendmsg, it simply starts using the data from the src SGL 
> starting from the offset.
> 
> Therefore, the code should now be able to handle a write / write / read / read 
> scenario. Or it can handle, say, a write(32 bytes) / read (16 bytes) / read 
> (16 bytes). At least my tests covered a successful testing of that scenario 
> which always crashed the kernel before.

Are you making separate read calls or just a single one? If you're
making separate calls, then this is no differnt to just doing
write/read pairs.  You're not saving any overhead.

If you're making a single call, what guarantees the ordering?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
