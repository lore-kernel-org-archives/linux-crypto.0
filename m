From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64 implementations
Date: Wed, 26 Sep 2018 18:54:56 +0200
Message-ID: <CAKv+Gu9hOW0pOjDjrvg1q-v85aiwSZRnjivnvRTCwxMdph4j7g@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-8-Jason@zx2c4.com>
 <CAKv+Gu9mVAfdBvOMCFqRJj+wBiWu3JVOgPZdkcdjzqSdQQ5Jrw@mail.gmail.com>
 <CAHmME9r9KppoFwwNVpzpYbU+9dCPzb7Pit+4iRa4MY_ouJBWrA@mail.gmail.com>
 <CAKv+Gu8ih-TsASRGqK+ST_5+EQ0=Zo-zhGCadOdGyPjucMFTCg@mail.gmail.com> <CAHmME9p5b=L0FSL72gCszhvut-kr=aD4ZniY9qsJxiBnZk8qNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHmME9p5b=L0FSL72gCszhvut-kr=aD4ZniY9qsJxiBnZk8qNQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 26 Sep 2018 at 17:41, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Sep 26, 2018 at 4:02 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> > I don't think it makes sense to keep
> > it simple now and add the complexity later (and the same concern
> > applies to async support btw).
>
> Ugh, no. I don't want to add needless complexity, period. Zinc is
> synchronous, not asynchronous. It provides software implementations.
> That's what it does. While many of your reviews have been useful, many
> of your comments indicate some desire to change and mold the purpose
> and focus of Zinc away from Zinc's intents. Stop that. It's not going
> to become a bloated mess of "things Ard wanted and quipped about on
> LKML." Things like these only serve to filibuster the patchset
> indefinitely. But maybe that's what you'd like all along? Hard to
> tell, honestly. So, no, sorry, Zinc isn't gaining an async interface
> right now.

Framing it as /needless/ complexity does not help at all. The changes
you are proposing are very useful, but nobody wants two crypto
subsystems with two different maintainers in the kernel, so I would
like to understand where this is going in the future. I am not saying
it should block these patches though.

Also, I have spent a *lot* of time looking at your code, and trying to
make it better, especially for use cases that weren't on your radar to
begin with (e.g., 'pet projects' [your words] like the Cortex-A7 which
will be in almost every new 32-bit Android phone). So characterizing
my feedback as some kind of sabotage is not very productive either.

Contrary to what you seem to think, I am not deeply invested in the
crypto API. What I do care about is that the ARM crypto pieces in the
kernel are maintained, supported and improved by someone who
understands the use cases Linaro's members care about, and is willing
to make an effort to gain such understanding if he doesn't. I have no
doubt that your involvement in the kernel's crypto subsystem will have
a significant positive impact when it comes to code quality,
robustness and usability. I'd just like to see a bit more
consideration for other aspects of kernel programming, e.g.,
preemption under -rt, stack size constraints, coding style, importing
code from other projects etc. - please try to be less dismissive of
feedback first time around, but try to understand why people are
raising these issues; I'm sure you will appreciate it when future
contributors to zinc will do the same.
