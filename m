From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64
 implementations
Date: Wed, 26 Sep 2018 10:37:21 -0700
Message-ID: <20180926173720.GA248906@gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-8-Jason@zx2c4.com>
 <CAKv+Gu9mVAfdBvOMCFqRJj+wBiWu3JVOgPZdkcdjzqSdQQ5Jrw@mail.gmail.com>
 <CAHmME9r9KppoFwwNVpzpYbU+9dCPzb7Pit+4iRa4MY_ouJBWrA@mail.gmail.com>
 <CAKv+Gu8ih-TsASRGqK+ST_5+EQ0=Zo-zhGCadOdGyPjucMFTCg@mail.gmail.com>
 <CAHmME9p5b=L0FSL72gCszhvut-kr=aD4ZniY9qsJxiBnZk8qNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9p5b=L0FSL72gCszhvut-kr=aD4ZniY9qsJxiBnZk8qNQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 26, 2018 at 05:41:12PM +0200, Jason A. Donenfeld wrote:
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

Can you please stop accusing Ard of "filibustering" your patchset?  Spending too
long in non-preemptible code is a real problem even on non-RT systems.
syzkaller has been reporting bugs where the kernel spins too long without any
preemption points, both in crypto-related code and elsewhere in the kernel.  So
we've had to add explicit preemption points to address those, as otherwise users
can lock up all CPUs for tens of seconds.  The issue being discussed here is
basically the same except here preemption is being explicitly disabled via
kernel_neon_begin(), so it becomes a problem even on non-CONFIG_PREEMPT kernels.

It's much better to address this problem (which is a regression from the current
skcipher API which only maps a page at a time) up front rather than have to rush
to patch it after the fact once the syzbot reports start coming in.

- Eric
