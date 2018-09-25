From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Tue, 25 Sep 2018 09:18:05 +0200
Message-ID: <CAK8P3a3j0eqAPc-Vkp7YFxT56R2-LrqL_EcULQFam5Bm93gPyw@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com>
 <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
 <CAK8P3a0CS3QzEKEV5==qj8hUYgW+q2v1f13jA+s0TjQd8kYXFA@mail.gmail.com>
 <CAHmME9rJq=q7xj_E_84GN5FuzSW2KdP4Ch=y527Lem0ME4GnLg@mail.gmail.com> <CAK8P3a2VL16mtyq0HjNOXuSp8YJXik4J9Z_aPzksmTAbFB+=_g@mail.gmail.com>
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
In-Reply-To: <CAK8P3a2VL16mtyq0HjNOXuSp8YJXik4J9Z_aPzksmTAbFB+=_g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 22, 2018 at 6:11 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Sep 20, 2018 at 5:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Hey Arnd,
> >
> > On Thu, Sep 20, 2018 at 6:02 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > Right, if you hit a stack requirement like this, it's usually the compiler
> > > doing something bad, not just using too much stack but also generating
> > > rather slow object code in the process. It's better to fix the bug by
> > > optimizing the code to not spill registers to the stack.
> > >
> > > In the long run, I'd like to reduce the stack frame size further, so
> > > best assume that anything over 1024 bytes (on 32-bit) or 1280 bytes
> > > (on 64-bit) is a bug in the code, and stay below that.
> > >
> > > For prototyping, you can just mark the broken functions individually
> > > by setting the warning limit for a specific function that is known to
> > > be misoptimized by the compiler (with a comment about which compiler
> > > and architectures are affected), but not override the limit for the
> > > entire file.
> >
> > Thanks for the explanation. Fortunately in my case, the issues were
> > trivially fixable to get it under 1024/1280
>
> A lot of these bugs are not trivial, but we still need a full analysis of what
> failed and what the possible mititgations are. Can you describe more
> specifically what causes it?

I think I misread your earlier sentence and thought you had said the
exact opposite.

For confirmation, I've downloaded your git tree and built it with my
collection of compilers (gcc-4.6 through 8.1) and tried building it
in various configurations. Nothing alarming stood out, the only
thing that I think would might warrant some investigation is this one:

lib/zinc/curve25519/curve25519-hacl64.h: In function 'curve25519_generic':
lib/zinc/curve25519/curve25519-hacl64.h:785:1: warning: the frame size
of 1536 bytes is larger than 500 bytes [-Wframe-larger-than=]

Without KASAN, this takes 832 bytes, which is still more than it should
use from a look at the source code.

I first suspected some misoptimization around the get/put_unaligned_le64()
calls, but playing around with it some more led me to this patch:

diff --git a/lib/zinc/curve25519/curve25519-hacl64.h
b/lib/zinc/curve25519/curve25519-hacl64.h
index c7b2924a68c2..1f6eb5708a0e 100644
--- a/lib/zinc/curve25519/curve25519-hacl64.h
+++ b/lib/zinc/curve25519/curve25519-hacl64.h
@@ -182,8 +182,7 @@ static __always_inline void
fmul_mul_shift_reduce_(u128 *output, u64 *input,

 static __always_inline void fmul_fmul(u64 *output, u64 *input, u64 *input21)
 {
-       u64 tmp[5];
-       memcpy(tmp, input, 5 * sizeof(*input));
+       u64 tmp[5] = { input[0], input[1], input[2], input[3], input[4] };
        {
                u128 b4;
                u128 b0;

That change gets it down to

lib/zinc/curve25519/curve25519-hacl64.h: In function 'curve25519_generic':
lib/zinc/curve25519/curve25519-hacl64.h:788:1: warning: the frame size
of 640 bytes is larger than 500 bytes [-Wframe-larger-than=]

with KASAN, or 496 bytes without it. This indicates that there might
be something wrong with either gcc-8 or with our fortified memset()
function that requires more investigation. Maybe you can see
something there that I missed.

        Arnd
