From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: algapi - make crypto_xor() and crypto_inc()
 alignment agnostic
Date: Sat, 11 Feb 2017 18:55:10 +0800
Message-ID: <20170211105510.GH855@gondor.apana.org.au>
References: <1486289172-18604-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ebiggers3@gmail.com, Jason@zx2c4.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36097 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751577AbdBKS7m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 13:59:42 -0500
Content-Disposition: inline
In-Reply-To: <1486289172-18604-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 05, 2017 at 10:06:12AM +0000, Ard Biesheuvel wrote:
> Instead of unconditionally forcing 4 byte alignment for all generic
> chaining modes that rely on crypto_xor() or crypto_inc() (which may
> result in unnecessary copying of data when the underlying hardware
> can perform unaligned accesses efficiently), make those functions
> deal with unaligned input explicitly, but only if the Kconfig symbol
> HAVE_EFFICIENT_UNALIGNED_ACCESS is set. This will allow us to drop
> the alignmasks from the CBC, CMAC, CTR, CTS, PCBC and SEQIV drivers.
> 
> For crypto_inc(), this simply involves making the 4-byte stride
> conditional on HAVE_EFFICIENT_UNALIGNED_ACCESS being set, given that
> it typically operates on 16 byte buffers.
> 
> For crypto_xor(), an algorithm is implemented that simply runs through
> the input using the largest strides possible if unaligned accesses are
> allowed. If they are not, an optimal sequence of memory accesses is
> emitted that takes the relative alignment of the input buffers into
> account, e.g., if the relative misalignment of dst and src is 4 bytes,
> the entire xor operation will be completed using 4 byte loads and stores
> (modulo unaligned bits at the start and end). Note that all expressions
> involving misalign are simply eliminated by the compiler when
> HAVE_EFFICIENT_UNALIGNED_ACCESS is defined.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
