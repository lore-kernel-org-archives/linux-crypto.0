From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 19/23] zinc: Curve25519 ARM implementation
Date: Fri, 5 Oct 2018 17:16:08 +0200
Message-ID: <CAKv+Gu8SFbKXwO_fngymM6Rh6jU4=B14=V0NaCBOTOCoO3M-kA@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-20-Jason@zx2c4.com>
 <CAKv+Gu9FLDRLxHReKcveZYHNYerR5Y2pZd9gn-hWrU0jb2KgfA@mail.gmail.com>
 <CAHmME9rp0Fi5ObK5oi8FHj1_nK5hP4T2Bq7_dAmzq4OQ0mp0uw@mail.gmail.com> <20181005150538.17006.qmail@cr.yp.to>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        peter@cryptojedi.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181005150538.17006.qmail@cr.yp.to>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 5 October 2018 at 17:05, D. J. Bernstein <djb@cr.yp.to> wrote:
> For the in-order ARM Cortex-A8 (the target for this code), adjacent
> multiply-add instructions forward summands quickly. A simple in-order
> dot-product computation has no latency problems, while interleaving
> computations, as suggested in this thread, creates problems. Also, on
> this microarchitecture, occasional ARM instructions run in parallel with
> NEON, so trying to manually eliminate ARM instructions through global
> pointer tracking wouldn't gain speed; it would simply create unnecessary
> code-maintenance problems.
>
> See https://cr.yp.to/papers.html#neoncrypto for analysis of the
> performance of---and remaining bottlenecks in---this code. Further
> speedups should be possible on this microarchitecture, but, for anyone
> interested in this, I recommend focusing on building a cycle-accurate
> simulator (e.g., fixing inaccuracies in the Sobole simulator) first.
>
> Of course, there are other ARM microarchitectures, and there are many
> cases where different microarchitectures prefer different optimizations.
> The kernel already has boot-time benchmarks for different optimizations
> for raid6, and should do the same for crypto code, so that implementors
> can focus on each microarchitecture separately rather than living in the
> barbaric world of having to choose which CPUs to favor.
>

Thanks Dan for the insight.

We have already established in a separate discussion that Cortex-A7,
which is main optimization target for future development, does not
have the microarchitectural peculiarity that you are referring to that
ARM instructions are essentially free when interleaved with NEON code.

But I take your point re benchmarking (as I already indicated in my
reply to Jason): if we optimize towards speed, we should ideally reuse
the existing benchmarking infrastructure we have to select the fastest
implementation at runtime. For instance, it turns out that scalar
ChaCha20 is almost as fast as NEON (or even faster?) on A7, and using
NEON in the kernel has some issues of its own.
