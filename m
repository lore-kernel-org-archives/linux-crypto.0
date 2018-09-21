From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Fri, 21 Sep 2018 02:11:43 +0200
Message-ID: <CAHmME9rJq=q7xj_E_84GN5FuzSW2KdP4Ch=y527Lem0ME4GnLg@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com>
 <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com> <CAK8P3a0CS3QzEKEV5==qj8hUYgW+q2v1f13jA+s0TjQd8kYXFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0CS3QzEKEV5==qj8hUYgW+q2v1f13jA+s0TjQd8kYXFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Arnd,

On Thu, Sep 20, 2018 at 6:02 PM Arnd Bergmann <arnd@arndb.de> wrote:
> Right, if you hit a stack requirement like this, it's usually the compiler
> doing something bad, not just using too much stack but also generating
> rather slow object code in the process. It's better to fix the bug by
> optimizing the code to not spill registers to the stack.
>
> In the long run, I'd like to reduce the stack frame size further, so
> best assume that anything over 1024 bytes (on 32-bit) or 1280 bytes
> (on 64-bit) is a bug in the code, and stay below that.
>
> For prototyping, you can just mark the broken functions individually
> by setting the warning limit for a specific function that is known to
> be misoptimized by the compiler (with a comment about which compiler
> and architectures are affected), but not override the limit for the
> entire file.

Thanks for the explanation. Fortunately in my case, the issues were
trivially fixable to get it under 1024/1280. (By the way, why does
64-bit have a slightly larger stack frame? To account for 32 pointers
taking double the space or something?) That will be rectified in v6.

There is one exception though: sometimes KASAN bloats the frame on
64-bit compiles. How would you feel about me adding
'ccflags-$(CONFIG_KASAN) += -Wframe-larger-than=16384' in my makefile?
I'm not remotely close to reaching that limit (it's just a tiny bit
over 1280), but it does seem like telling gcc to quiet down about
stack frames when KASAN is being used might make sense. Alternatively,
I see the defaults for FRAME_WARN are:

config FRAME_WARN
       int "Warn for stack frames larger than (needs gcc 4.4)"
       range 0 8192
       default 3072 if KASAN_EXTRA
       default 2048 if GCC_PLUGIN_LATENT_ENTROPY
       default 1280 if (!64BIT && PARISC)
       default 1024 if (!64BIT && !PARISC)
       default 2048 if 64BIT

What about changing that KASAN_EXTRA into just KASAN? This seems
cleanest; I'll send a patch for it.

On the other hand, this KASAN behavior is only observable on 64-bit
systems when I force it to be 1280, whereas the default is still 2048,
so probably this isn't a problem *now* for this patchset. But it is
something to think about for down the road when you lower the default
frame.

Regards,
Jason
