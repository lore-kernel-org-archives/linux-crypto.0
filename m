From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Wed, 11 Jan 2017 11:11:24 +0800
Message-ID: <20170111031124.GA4515@gondor.apana.org.au>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 10, 2017 at 09:05:28AM -0800, Linus Torvalds wrote:
> On Tue, Jan 10, 2017 at 6:39 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > BTW this is with Debian gcc 4.7.2 which does not allow an 8-byte
> > stack alignment as attempted by the Makefile:
> 
> I'm pretty sure we have random asm code that may not maintain a
> 16-byte stack alignment when it calls other code (including, in some
> cases, calling C code).
> 
> So I'm not at all convinced that this is a good idea. We shouldn't
> expect 16-byte alignment to be something trustworthy.

Well the only other alternative I see is to ban compilers which
enforce 16-byte stack alignment, such as gcc 4.7.2.  Or is there
another way?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
