From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 16:06:27 +0800
Message-ID: <20170112080627.GB14355@gondor.apana.org.au>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <CAKv+Gu8xVrfR=J5b2pGK7R5Tv-M3xZhL_dnTvvM7nTZLLtC-EQ@mail.gmail.com>
 <20170112061211.GA10247@gondor.apana.org.au>
 <CAKv+Gu8=zhpZF_Y39L+DtxHysnAEATGP1ZzY1tSMdd+pG=k+jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:32919 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750731AbdALIGd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 03:06:33 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8=zhpZF_Y39L+DtxHysnAEATGP1ZzY1tSMdd+pG=k+jA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 08:01:51AM +0000, Ard Biesheuvel wrote:
> 
> [From memory] the arm64 ELF psABI mandates a 16 byte stack alignment
> at function entry, and 8 byte alignment at all other times. This means
> compiled code will typically preserve 16 byte alignment, and
> __aligned(16) on a stack variable will likely not result in an
> explicit alignment of the stack pointer *. But the arm64 ISA does not
> have any load/store instructions that would trigger a misalignment
> fault on an address that is 8 byte aligned but not 16 byte aligned, so
> the situation is very different from x86 (assuming I am correct in
> asserting that there are no failure modes resulting from a misaligned
> stack other than this one and a potential performance hit)

OK, sounds like we're already using 16-byte aligned stacks on
ARM64.  So unless x86-64 stacks are much smaller, I don't see
the need to use 8-byte aligned stacks at least from a stack space
point-of-view.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
