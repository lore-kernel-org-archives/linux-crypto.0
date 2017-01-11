From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Wed, 11 Jan 2017 11:26:45 +0800
Message-ID: <20170111032645.GE4515@gondor.apana.org.au>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <CAKv+Gu8xVrfR=J5b2pGK7R5Tv-M3xZhL_dnTvvM7nTZLLtC-EQ@mail.gmail.com>
 <CALCETrWGihhtbdkKcSD0kBrx-fWxM_TyUOUafvhsKMYXq5yEEQ@mail.gmail.com>
 <CAKv+Gu8XVUXQrWCzgL6WRA=zY=5iTbbJ3Jp2kegCm0R7d6LwGA@mail.gmail.com>
 <CALCETrW7mXxntZBTTHOgvaRLV4=9hcsNoTKM3o2O5Jod_6RR6Q@mail.gmail.com>
 <CAKv+Gu_Te-D5V3eG-GHtpP2hdpb+aTCgxBhmvf1DVK-pKPT54g@mail.gmail.com>
 <CALCETrW4DZeq=tcEnEyPc=H3Z35J-o6BGPwxEfcdKjg2tDqBGg@mail.gmail.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:52223 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S964859AbdAKD06 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2017 22:26:58 -0500
Content-Disposition: inline
In-Reply-To: <CALCETrW4DZeq=tcEnEyPc=H3Z35J-o6BGPwxEfcdKjg2tDqBGg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 10, 2017 at 03:25:47PM -0800, Andy Lutomirski wrote:
>
> > If it does what it says on the tin, it should fix the issue, but after
> > adding the attribute, I get the exact same object output, so there's
> > something dodgy going on here.
> 
> Ugh, that's annoying.  Maybe it needs noinline too?

Perhaps something to do with

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66697

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
