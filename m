From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 07/20] zinc: Poly1305 generic C
 implementations and selftest
Date: Wed, 19 Sep 2018 03:35:15 +0200
Message-ID: <CAHmME9oL98adRp6xXqaXxA0E4Oa4ecPW+JHChCS3hTgH7RLPjA@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-8-Jason@zx2c4.com>
 <20180919005054.GC74746@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919005054.GC74746@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 19, 2018 at 2:50 AM Eric Biggers <ebiggers@kernel.org> wrote:
> Hardcoding the 'input' array to 600 bytes forces the full amount of space to be
> reserved in the kernel image for every test vector.  Also, if anyone adds a
> longer test vector they will need to remember to increase the value.
>
> It should be a const pointer instead, like the test vectors in crypto/testmgr.h.

I know. The agony. This has been really annoying me. I originally did
it the right way, but removed it last week, when I noticed that gcc
failed to put it in the initconst section:

https://git.zx2c4.com/WireGuard/commit/?id=f4698d20f13946afc6ce99e98685ba3f9adc4474

Even changing the (u8[]){ ... } into a (const u8[]){ ... } or even
into a const string literal does not do the trick. It makes it into
the constant data section with const, but it does not make it into the
initconst section. What a bummer.

I went asking about this on the gcc mailing list, to see if there was
just some aspect of C that I had overlooked:
https://gcc.gnu.org/ml/gcc/2018-09/msg00043.html So far, it looks like
we're SOL. I could probably make some macros to do this in a .S file
but... that's pretty unacceptably gross. Or I could define lots and
lots of variables in __initconst, and then connect them all together
at the end, but that's pretty gross too. Or I could have all this data
in one variable and record offsets into it, but that's even more
atrocious.

So I think it comes down to these two non-ugly options:
- We use fixed sized buffers, waste a lot of space, and be happy that
it's cleared from memory immediately after init/insertion anyway, so
it's not actually wasting ram.
- We use const string literals / constant compound literals, save
space on disk, but not benefit from having it cleared from memory
after init/insertion.

Of these, which would you prefer? I can see the argument both ways,
but in the end opted for the first. Or perhaps you have a better third
option?

Jason
