From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Sat, 7 Oct 2017 10:51:17 +0800
Message-ID: <20171007025117.GA29361@gondor.apana.org.au>
References: <3874163.dZU00zCVt8@positron.chronox.de>
 <1612247.TXa8PiMVpk@positron.chronox.de>
 <20171007024635.GB28489@gondor.apana.org.au>
 <3683903.fccHZfxTmM@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57050 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbdJGCvh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 22:51:37 -0400
Content-Disposition: inline
In-Reply-To: <3683903.fccHZfxTmM@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 07, 2017 at 04:49:10AM +0200, Stephan Müller wrote:
> Am Samstag, 7. Oktober 2017, 04:46:35 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > Hmm this just papers over bugs in the underlying code.  Which
> > algorithm is causing the crash with a zero input? They're supposed
> > to handle this case.
> 
> The bug happens with authenc. It is surely possible to modify authenc. Yet I 
> thought that covering such issue at a central spot at least prevents similar 
> buts to be exploitable from userspace.

No I'm talking about the underlysing skcipher.  authenc is an
aead, and it is legal to make a zero skcipher call.  The underlying
skcipher should make sure that it works.

So which underlying skcipher is barfing over a zero input?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
