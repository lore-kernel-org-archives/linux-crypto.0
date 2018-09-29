From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 04/23] zinc: ChaCha20 x86_64 implementation
Date: Sat, 29 Sep 2018 04:01:53 +0200
Message-ID: <CAHmME9rc5zgN4HhBy0_oq+EbEXdS8nePzA7qW39nocx_y4ay1Q@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-5-Jason@zx2c4.com>
 <CAKv+Gu9aOiYdEzHHrHFHUFK=hNfeS=zEsvMe9OWD8hEdAYkffg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        X86 ML <x86@kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9aOiYdEzHHrHFHUFK=hNfeS=zEsvMe9OWD8hEdAYkffg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ard,

On Fri, Sep 28, 2018 at 5:47 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Please drop this SOB line: SOB is not about (co-)authorship but about
> who handled the patch on its way into mainline.

The s-o-b line is about the DCoO, which is given here by both of us,
with the code starting in a shared tree that only had that s-o-b. I
can remove it though if you think it's strange to have two s-o-bs.

> You are sending the
> patch so your SOB should come last.

I was wondering about the ordering of these, actually. I've seen s-o-b
on top and s-o-b on bottom of the cc list in lots of commits and
haven't yet divined the One True Position.

> You can drop the #ifdefs above ...

Yep. All of those ifdefs in this and in the other primitives are
already gone, and everything is fully IS_ENABLEDenabled now.

> > +#ifdef CONFIG_AS_AVX512
>
> ... and use IS_ENABLED(CONFIG_AS_AVX512) here inside the if().

Already done, per your suggestion a few days ago.

> > -#ifndef HAVE_CHACHA20_ARCH_IMPLEMENTATION
>
> As I mentioned in reply to the previous patch, please get rid of this
> CPP symbol ^^^

Ack.

Jason
