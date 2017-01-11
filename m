From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Wed, 11 Jan 2017 11:16:58 +0800
Message-ID: <20170111031658.GC4515@gondor.apana.org.au>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <CAKv+Gu8xVrfR=J5b2pGK7R5Tv-M3xZhL_dnTvvM7nTZLLtC-EQ@mail.gmail.com>
 <CALCETrWGihhtbdkKcSD0kBrx-fWxM_TyUOUafvhsKMYXq5yEEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53097 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753343AbdAKDRa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2017 22:17:30 -0500
Content-Disposition: inline
In-Reply-To: <CALCETrWGihhtbdkKcSD0kBrx-fWxM_TyUOUafvhsKMYXq5yEEQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 10, 2017 at 11:00:31AM -0800, Andy Lutomirski wrote:
> 
> Here's what I think is really going on.  This is partially from
> memory, so I could be off base.  The kernel is up against
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383, which means that,
> on some GCC versions (like the bad one and maybe even current ones),
> things compiled without -mno-sse can't have the stack alignment set
> properly.  IMO we should fix this in the affected code, not the entry

No that's not it.  My compiler (gcc 4.7.2) doesn't support it period:

$ gcc -S -O2 -mno-sse -mpreferred-stack-boundary=3 a.c
a.c:1:0: error: -mpreferred-stack-boundary=3 is not between 4 and 12
$ 

So you either have to ban all compilers older than whatever version
that started supporting 8-byte stack alignment, or fix the kernel.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
