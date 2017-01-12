From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 23:53:44 +0800
Message-ID: <20170112155344.GB19252@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <2819680.QEYfZCVF62@tauon.atsec.com>
 <20170112153924.GA16347@gondor.apana.org.au>
 <19793111.SdtrLVTG75@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34491 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750730AbdALQaN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:30:13 -0500
Content-Disposition: inline
In-Reply-To: <19793111.SdtrLVTG75@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 04:50:46PM +0100, Stephan Müller wrote:
>
> So you say that we could remove it from authenc() entirely (this is currently 
> the only location where such copy operation is found for the encryption 
> direction)?
> 
> I would concur that the kernel does not need that.

authenc needs it for performance reasons.  The kernel API as it
stands basically says that it may or may not copy the AAD.  If
you choose to have a distinct AAD in the dst SG list then either
you throw away the result or you copy it yourself.

> If we only want to solve that for algif_aead, wouldn't it make more sense if 
> the user space caller takes care of that (such as libkcapi)? By tinkering with 
> the SGLs and copying the data to the dst buffer before the cipher operation 
> takes place, I guess we will add performance degradation and more complexity 
> in the kernel.
> 
> Having such logic in user space would keep the algif_aead cleaner IMHO.

We need to have a sane kernel API that respects POSIX.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
