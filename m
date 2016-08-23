From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: XTS - remove test that will fail in FIPS mode
Date: Tue, 23 Aug 2016 17:47:50 +0800
Message-ID: <20160823094750.GA26545@gondor.apana.org.au>
References: <D3CF7065.28F3%tsarangi@trustwave.com>
 <D3CFBBE7.2B1D%tsarangi@trustwave.com>
 <3590892.3HIz2aNZPY@positron.chronox.de>
 <16370043.OYgDIDmMpM@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tapas Sarangi <TSarangi@trustwave.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59468 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757368AbcHWJs0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Aug 2016 05:48:26 -0400
Content-Disposition: inline
In-Reply-To: <16370043.OYgDIDmMpM@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 16, 2016 at 11:38:00AM +0200, Stephan Mueller wrote:
> Hi Tapas,
> 
> I was able to reproduce the issue now.
> 
> I tested the patch below and it works for me now. Yet, I see that dracut-fips seems to need some fixes too as it cannot find cmac when compiled as module and has some issues with the authenc() ciphers too.
> 
> 
> ---8<---
>  
> In FIPS mode, setting XTS keys where the AES key is identical to the
> tweak key is forbidden. Thus, the self test with such property will fail
> in FIPS mode.
> 
> As we have other tests available for XTS, this patch simply removes the
> offending test vectors.
> 
> Reported-by: Tapas Sarangi <TSarangi@trustwave.com>
> Signed-off-by: Stephan Mueller <stephan.mueller@atsec.com>

We should fix this without removing tests.  Perhaps add a field
in the vector to indicate that it should be skipped when in FIPS
mode, just like we do for expected weak keys.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
