From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Thu, 20 Sep 2018 09:02:07 -0700
Message-ID: <CAK8P3a0CS3QzEKEV5==qj8hUYgW+q2v1f13jA+s0TjQd8kYXFA@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com>
 <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, David Miller <davem@davemloft.net>,
        gregkh <gregkh@linuxfoundation.org>, sneves@dei.uc.pt,
        Andy Lutomirski <luto@kernel.org>,
        jeanphilippe.aumasson@gmail.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 20, 2018 at 8:41 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> (+ Arnd, Eric)
>
> On 18 September 2018 at 09:16, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> ...
>
> > diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
> > new file mode 100644
> > index 000000000000..83dfd63988c0
> > --- /dev/null
> > +++ b/lib/zinc/Makefile
> > @@ -0,0 +1,4 @@
>
> Apologies for not spotting these before:
>
> > +ccflags-y := -O3
>
> -O3 optimization has been problematic in the past, at least on x86 but
> I think on other architectures as well. Please stick with -O2.
>
> > +ccflags-y += -Wframe-larger-than=$(if (CONFIG_KASAN),16384,8192)
>
> There is no way we can support code in the kernel with that kind of
> stack space requirements. I will let Arnd comment on what we typically
> allow, since he deals with such issues on a regular basis.

Right, if you hit a stack requirement like this, it's usually the compiler
doing something bad, not just using too much stack but also generating
rather slow object code in the process. It's better to fix the bug by
optimizing the code to not spill registers to the stack.

In the long run, I'd like to reduce the stack frame size further, so
best assume that anything over 1024 bytes (on 32-bit) or 1280 bytes
(on 64-bit) is a bug in the code, and stay below that.

For prototyping, you can just mark the broken functions individually
by setting the warning limit for a specific function that is known to
be misoptimized by the compiler (with a comment about which compiler
and architectures are affected), but not override the limit for the
entire file.

       Arnd
