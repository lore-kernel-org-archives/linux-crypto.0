Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38944 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731793AbeLWEBZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:01:25 -0500
Date: Sun, 23 Dec 2018 12:01:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dave Watson <davejwatson@fb.com>
Cc: Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 00/12] x86/crypto: gcmaes AVX scatter/gather support
Message-ID: <20181223040100.lemyilorwoc36kq5@gondor.apana.org.au>
References: <cover.1544471415.git.davejwatson@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 10, 2018 at 07:56:28PM +0000, Dave Watson wrote:
> This patch set refactors the x86 aes/gcm AVX crypto routines to
> support true scatter/gather by adding gcm_enc/dec_update methods.
> 
> It is similar to the previous SSE patchset starting at e1fd316f.  
> Unlike the SSE routines, the AVX routines did not support
> keysize 192 & 256, this patchset also adds support for those
> keysizes.
> 
> The final patch updates the C glue code, passing everything through
> the crypt_by_sg() function instead of the previous memcpy based
> routines.
> 
> Dave Watson (12):
>   x86/crypto: aesni: Merge GCM_ENC_DEC
>   x86/crypto: aesni: Introduce gcm_context_data
>   x86/crypto: aesni: Macro-ify func save/restore
>   x86/crypto: aesni: support 256 byte keys in avx asm
>   x86/crypto: aesni: Add GCM_COMPLETE macro
>   x86/crypto: aesni: Split AAD hash calculation to separate macro
>   x86/crypto: aesni: Merge avx precompute functions
>   x86/crypto: aesni: Fill in new context data structures
>   x86/crypto: aesni: Move ghash_mul to GCM_COMPLETE
>   x86/crypto: aesni: Introduce READ_PARTIAL_BLOCK macro
>   x86/crypto: aesni: Introduce partial block macro
>   x86/crypto: aesni: Add scatter/gather avx stubs, and use them in C
> 
>  arch/x86/crypto/aesni-intel_avx-x86_64.S | 2125 ++++++++++------------
>  arch/x86/crypto/aesni-intel_glue.c       |  353 ++--
>  2 files changed, 1117 insertions(+), 1361 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
