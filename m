From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Tue, 10 Jan 2017 09:09:40 -0800
Message-ID: <CALCETrXygy1ACDyeWRE++hLF=b4q17mTYOmWWY94wKN1Fm7xGQ@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au> <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 10, 2017 at 9:05 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jan 10, 2017 at 6:39 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> BTW this is with Debian gcc 4.7.2 which does not allow an 8-byte
>> stack alignment as attempted by the Makefile:
>
> I'm pretty sure we have random asm code that may not maintain a
> sus16-byte stack alignment when it calls other code (including, in some
> cases, calling C code).

I suspect so.

If we change this, changing pt_regs might make sense but is kind of
weird.  It also needs to be tested with and without frame pointers.

>
> So I'm not at all convinced that this is a good idea. We shouldn't
> expect 16-byte alignment to be something trustworthy.
>
>                  Linus



-- 
Andy Lutomirski
AMA Capital Management, LLC
