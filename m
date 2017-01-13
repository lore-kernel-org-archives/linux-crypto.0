From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 19:33:24 +0800
Message-ID: <20170113113324.GA24021@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <2328881.s8hPz576Kn@positron.chronox.de>
 <20170113112623.GB23928@gondor.apana.org.au>
 <1704568.lHqrOxcchT@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48615 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751365AbdAMLeb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:34:31 -0500
Content-Disposition: inline
In-Reply-To: <1704568.lHqrOxcchT@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 12:30:15PM +0100, Stephan Müller wrote:
>
> So, the patch set you want to see is:
> 
> - remove the AAD copy operation from authenc and not add it to any AEAD 
> implementations

Why would you remove it from authenc?

> - add the AAD copy operation to algif_aead

No just copy everything and then do in-place crypto.

> Shall the null cipher context we need for that be anchored in the crypto_aead 
> data structure as done in patch 01 of this series (this would allow an easy 
> addition to the copy call to every AEAD implementation if deemed needed) or 
> shall it be anchored within algif_aead?

It should be in algif_aead.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
