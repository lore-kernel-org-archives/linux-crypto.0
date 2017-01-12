From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 23:27:10 +0800
Message-ID: <20170112152710.GA16222@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <31581301.kpbcu3havF@positron.chronox.de>
 <20170112145728.GA15595@gondor.apana.org.au>
 <6428553.skGSKSKcYl@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60937 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750945AbdALP1Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 10:27:24 -0500
Content-Disposition: inline
In-Reply-To: <6428553.skGSKSKcYl@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 04:23:50PM +0100, Stephan Müller wrote:
>
> As far as I understand, we have the following AAD copy operations that we 
> discuss:
> 
> - algif_aead: you suggested to add the AAD copy operation here
> 
> - AEAD implementations: over time, the AEAD implementations shall receive the 
> AAD copy operation. The AAD copy operation shall only take place if the src 
> SGL != dst SGL

If and when that happens we'd simply need to remove the copy from
algif_aead code.  But even if we didn't you wouldn't have two copies
because algif_aead should invoke the in-place code-path after doing
a full copy of src to dst.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
