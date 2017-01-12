From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 22:57:28 +0800
Message-ID: <20170112145728.GA15595@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <20170112061936.GA10325@gondor.apana.org.au>
 <31581301.kpbcu3havF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34689 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750933AbdALO5s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 09:57:48 -0500
Content-Disposition: inline
In-Reply-To: <31581301.kpbcu3havF@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 12:22:09PM +0100, Stephan Müller wrote:
> 
> When addressing the issue in the algif_aead code, and expect that over time 
> the AEAD implementations will gain the copy operation, eventually we will copy 
> the AAD twice. Of course, this could be prevented, if the algif_aead code 
> somehow uses the same SGL for the src and dst AAD.

Why would you copy it twice? You copy everything before you start
and then just do in-place crypto.

> > BTW, why are you only doing the copy for encryption?
> 
> I was looking at the only AEAD implementation that does the copy operation: 
> authenc. There, the copy operation is only performed for encryption. I was 
> thinking a bit about why decryption was not covered. I think the answer is the 
> following: for encryption, the AAD is definitely needed in the dst buffer as 
> the dst buffer with the AAD must be sent to the recipient for decryption. The 
> decryption and the associated authentication only works with the AAD. However, 
> after decrypting, all the caller wants is the decrypted plaintext only. There 
> is no further use of the AAD after the decryption step. Hence, copying the AAD 
> to the dst buffer in the decryption step would not serve the caller.

That's just the current implementation.  If we're going to make
this an API then we should do it for both directions.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
