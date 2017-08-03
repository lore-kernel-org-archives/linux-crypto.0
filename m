From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH resend 00/18] crypto: ARM/arm64 roundup for v4.14
Date: Thu, 3 Aug 2017 11:49:19 +0100
Message-ID: <20170803104917.GK6321@e103592.cambridge.arm.com>
References: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
 <20170803062653.GR12039@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:38280 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751916AbdHCKtX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 06:49:23 -0400
Content-Disposition: inline
In-Reply-To: <20170803062653.GR12039@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 03, 2017 at 02:26:53PM +0800, Herbert Xu wrote:
> On Mon, Jul 24, 2017 at 11:28:02AM +0100, Ard Biesheuvel wrote:
> > This is a resend of all the patches I sent out recently that I would
> > like to be considered for v4.14. Their main purpose is to prepare the
> > arm64 crypto code to deal with situations where the SIMD register file
> > is unavailable, which never occurs at present, but this will change in
> > the future when support for SVE is added.
> > 
> > Patches #1 and #2 have been sent out last week as 'crypto/algapi - refactor
> > crypto_xor() to avoid memcpy()s' (v2). This version of #2 fixes an error
> > caught by kbuild. The non-SIMD fallback code added in the remaining patches
> > relies on crypto_xor() extensively, which is why these patches have been
> > included here.
> > 
> > Patches #3 - #13 implement the non-SIMD fallbacks for the various NEON
> > based drivers.
> > 
> > Patch #14 implements AES-GCM natively instead of relying on the generic
> > GCM module to wire accelerated AES-CTR and GHASH together, resulting in
> > a ~37% speedup.
> > 
> > Patches #15 and #16 implement an accelerated GHASH algorithm for ARM cores
> > that lack the 64x64 PMULL instruction.
> > 
> > Patches #17 and #18 update the scalar AES implementations to stop using
> > the expanded lookup tables for the final round. This reduces the Dcache
> > footprint, and thus the key correlated jitter.
> > 
> > This supersedes all other crypto patches I have outstanding, including the
> > AES refactor ones which I will rework later.
> > 
> > Ard Biesheuvel (18):
> >   crypto/algapi - use separate dst and src operands for __crypto_xor()
> >   crypto/algapi - make crypto_xor() take separate dst and src arguments
> >   crypto: arm64/ghash-ce - add non-SIMD scalar fallback
> >   crypto: arm64/crct10dif - add non-SIMD generic fallback
> >   crypto: arm64/crc32 - add non-SIMD scalar fallback
> >   crypto: arm64/sha1-ce - add non-SIMD generic fallback
> >   crypto: arm64/sha2-ce - add non-SIMD scalar fallback
> >   crypto: arm64/aes-ce-cipher - match round key endianness with generic
> >     code
> >   crypto: arm64/aes-ce-cipher: add non-SIMD generic fallback
> >   crypto: arm64/aes-ce-ccm: add non-SIMD generic fallback
> >   crypto: arm64/aes-blk - add a non-SIMD fallback for synchronous CTR
> >   crypto: arm64/chacha20 - take may_use_simd() into account
> >   crypto: arm64/aes-bs - implement non-SIMD fallback for AES-CTR
> >   crypto: arm64/gcm - implement native driver using v8 Crypto Extensions
> >   crypto: arm/ghash - add NEON accelerated fallback for vmull.p64
> >   crypto: arm64/ghash - add NEON accelerated fallback for 64-bit PMULL
> >   crypto: arm/aes - avoid expanded lookup tables in the final round
> >   crypto: arm64/aes - avoid expanded lookup tables in the final round
> 
> All applied.  Thanks.

Awesome, thanks
---Dave
