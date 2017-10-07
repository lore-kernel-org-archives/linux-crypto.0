From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Sat, 7 Oct 2017 11:07:52 +0800
Message-ID: <20171007030752.GA29495@gondor.apana.org.au>
References: <3874163.dZU00zCVt8@positron.chronox.de>
 <3683903.fccHZfxTmM@positron.chronox.de>
 <20171007025117.GA29361@gondor.apana.org.au>
 <2010633.8rTN3NahbQ@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57150 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753147AbdJGDIM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 23:08:12 -0400
Content-Disposition: inline
In-Reply-To: <2010633.8rTN3NahbQ@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 07, 2017 at 04:53:46AM +0200, Stephan Müller wrote:
>
> I use authenc(hmac(sha256),cbc(aes)) which in turn uses cbc-aes-aesni on my 
> system.

So where exactly is it crashing in cbc-aes-aesni? AFAICS it should
handle the zero case just fine.  Or is it hmac that's crashing as
your other patch suggested?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
