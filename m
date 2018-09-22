From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Sat, 22 Sep 2018 09:11:03 -0700
Message-ID: <CAK8P3a2VL16mtyq0HjNOXuSp8YJXik4J9Z_aPzksmTAbFB+=_g@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com>
 <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
 <CAK8P3a0CS3QzEKEV5==qj8hUYgW+q2v1f13jA+s0TjQd8kYXFA@mail.gmail.com> <CAHmME9rJq=q7xj_E_84GN5FuzSW2KdP4Ch=y527Lem0ME4GnLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, David Miller <davem@davemloft.net>,
        gregkh <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9rJq=q7xj_E_84GN5FuzSW2KdP4Ch=y527Lem0ME4GnLg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 20, 2018 at 5:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hey Arnd,
>
> On Thu, Sep 20, 2018 at 6:02 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > Right, if you hit a stack requirement like this, it's usually the compiler
> > doing something bad, not just using too much stack but also generating
> > rather slow object code in the process. It's better to fix the bug by
> > optimizing the code to not spill registers to the stack.
> >
> > In the long run, I'd like to reduce the stack frame size further, so
> > best assume that anything over 1024 bytes (on 32-bit) or 1280 bytes
> > (on 64-bit) is a bug in the code, and stay below that.
> >
> > For prototyping, you can just mark the broken functions individually
> > by setting the warning limit for a specific function that is known to
> > be misoptimized by the compiler (with a comment about which compiler
> > and architectures are affected), but not override the limit for the
> > entire file.
>
> Thanks for the explanation. Fortunately in my case, the issues were
> trivially fixable to get it under 1024/1280

A lot of these bugs are not trivial, but we still need a full analysis of what
failed and what the possible mititgations are. Can you describe more
specifically what causes it?

> (By the way, why does
> 64-bit have a slightly larger stack frame? To account for 32 pointers
> taking double the space or something?) That will be rectified in v6.

Correct. We have some functions in the kernel that take 128 pointers
on the stack. This fits fine within the 1024 byte limit on 32 bit, but goes
beyond the same limit on 64 bit. Everything that took more than 1280
bytes (without KASAN) in my analysis was a real problem and reducing
the stack size fixed a bug or improved the code in other ways. I never got
around to reposting all those bug fixes I made back then, and there are
probably a couple new ones we'd need.

> There is one exception though: sometimes KASAN bloats the frame on
> 64-bit compiles. How would you feel about me adding
> 'ccflags-$(CONFIG_KASAN) += -Wframe-larger-than=16384' in my makefile?

I ran into several ciphers in the kernel that required a large stack allocation,
with or without KASAN. Typically these turned out to be optimization bugs
in gcc where gcc tried to be smart about optimizing part of the cipher that
was intentionally designed to not be optimizable, but in the process it
ended up spilling registers to the stack. Adding KASAN into the mix then
added an extra redzone around each of those.

My best approach here was to figure out which optimization step in gcc
caused the register spilling in the first place, and adjust the set of
optimizations done to a specific function in that cipher.

Note that some crypto ciphers are rather performance sensitive and we
have users that care about every percent of performance one can get
out. The bugs that cause the stack size explode beyond a few hundred
bytes that one might expect are usually the same bugs that make the
ciphers much slower than they should be even without KASAN.

For a cryptographic library it might therefore even make sense to have an
even smaller limit (e.g. 400 bytes) in the Makefile and then audit each
case that does not fit into that after determining what exactly caused the
problem, and making sure we find  workaround that produces optmized
object code. When you end up with a function that gcc-8 still
misoptimizes in all optmization levels and you find no other workaround,
please set the higher limit specifically for that function with a gcc version
check in it, and add a comment pointing to the gcc bugzilla report you
have. gcc developers tend to be good about fixing these issues in new
compilers, but the version check helps to ensure we find it if a future
version regresses again, and of course we have to make sure we apply
the hack on all unpatched compilers.

> I'm not remotely close to reaching that limit (it's just a tiny bit
> over 1280), but it does seem like telling gcc to quiet down about
> stack frames when KASAN is being used might make sense. Alternatively,
> I see the defaults for FRAME_WARN are:
>
> config FRAME_WARN
>        int "Warn for stack frames larger than (needs gcc 4.4)"
>        range 0 8192
>        default 3072 if KASAN_EXTRA
>        default 2048 if GCC_PLUGIN_LATENT_ENTROPY
>        default 1280 if (!64BIT && PARISC)
>        default 1024 if (!64BIT && !PARISC)
>        default 2048 if 64BIT
>
> What about changing that KASAN_EXTRA into just KASAN? This seems
> cleanest; I'll send a patch for it.

I saw you already posted a patch for that, sorry for not being able to
reply earlier. I actually spent several months of my work to introduce
the KASAN_EXTRA option specifically in order to have a separate
stack size limit for that, so I definitely object to that one. We need the
default (allmodconfig) stack size check to be as small as we can in
order to catch kernel and gcc bugs that bloat the stack more than
it is currently at.

> On the other hand, this KASAN behavior is only observable on 64-bit
> systems when I force it to be 1280, whereas the default is still 2048,
> so probably this isn't a problem *now* for this patchset. But it is
> something to think about for down the road when you lower the default
> frame.

Right. Some background about that limit: 2048 has been what we used
traditionally on 64-bit before KASAN. When I first saw the problems
with KASAN, I had a more detailed look at it and found that we can
significantly reduce it without KASAN, but obviously KASAN needs a
little extra space. I got all my patches upstream to get the KASAN
limit below 2048 and remove that special case for it, and I sent a
lot of the other patches to reduce the limit further to 1280/1535
without/with KASAN, but not all those patches got accepted, so for
the moment that traditional limit is still in place.

clang with KASAN still has known bugs that make it go beyond
2048 bytes, as I said in the other thread, and this is something that
first needs to be addressed in clang before we can take specific
measures in the kernel to work around any remaining unrelated
bugs with clang building our kernel with KASAN.

        Arnd
