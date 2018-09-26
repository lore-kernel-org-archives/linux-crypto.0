From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64 implementations
Date: Wed, 26 Sep 2018 19:07:19 +0200
Message-ID: <CAHmME9o4usa8TDPA0=mHY-8ijQNVc-jH4UMU-EZuSK2wqaieKQ@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-8-Jason@zx2c4.com>
 <CAKv+Gu9mVAfdBvOMCFqRJj+wBiWu3JVOgPZdkcdjzqSdQQ5Jrw@mail.gmail.com>
 <CAHmME9r9KppoFwwNVpzpYbU+9dCPzb7Pit+4iRa4MY_ouJBWrA@mail.gmail.com>
 <CAKv+Gu8ih-TsASRGqK+ST_5+EQ0=Zo-zhGCadOdGyPjucMFTCg@mail.gmail.com>
 <CAHmME9p5b=L0FSL72gCszhvut-kr=aD4ZniY9qsJxiBnZk8qNQ@mail.gmail.com> <CAKv+Gu9hOW0pOjDjrvg1q-v85aiwSZRnjivnvRTCwxMdph4j7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9hOW0pOjDjrvg1q-v85aiwSZRnjivnvRTCwxMdph4j7g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 26, 2018 at 6:55 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Framing it as /needless/ complexity does not help at all. The changes
> you are proposing are very useful, but nobody wants two crypto
> subsystems with two different maintainers in the kernel, so I would
> like to understand where this is going in the future. I am not saying
> it should block these patches though.

Thanks for clarifying. I understood you to be intending to block the
patches until they were converted to an async interface, which is not
what Zinc's about. Seeing as you're just curious about future
directions, that seems much more tenable.

> Also, I have spent a *lot* of time looking at your code, and trying to
> make it better, especially for use cases that weren't on your radar to
> begin with

I am extremely grateful for a good portion of your reviews indeed. As
I mentioned earlier, much is very useful. But in other places, I fear
you're steering this in a direction I really am hesitant to go.

> (e.g., 'pet projects' [your words]

Taken out of context.

> consideration for other aspects of kernel programming, e.g.,
> preemption under -rt, stack size constraints, coding style, importing
> code from other projects etc.

And indeed all of these concerns I've been pretty amenable to, and
continue to do so. What I'm commenting on are things outside of these.


> - please try to be less dismissive of
> feedback first time around, but try to understand why people are
> raising these issues

Apologies, and duly noted. I'll give you the benefit of the doubt.

Jason
