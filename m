From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 07/20] zinc: Poly1305 generic C
 implementations and selftest
Date: Wed, 19 Sep 2018 03:41:44 +0200
Message-ID: <CAHmME9rzRMHMWFUSGPsVDP573cdrVCYN36WuAet-aSsir0DFMQ@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-8-Jason@zx2c4.com>
 <20180919005054.GC74746@gmail.com> <CAHmME9rab92gc68tGX384eGR71q+7JtovpxBLSYrYNHA7L5zFw@mail.gmail.com>
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
In-Reply-To: <CAHmME9rab92gc68tGX384eGR71q+7JtovpxBLSYrYNHA7L5zFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 19, 2018 at 3:39 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> > > +     const size_t num = ctx->num % POLY1305_BLOCK_SIZE;
> > 0 <= ctx->num < POLY1305_BLOCK_SIZE, so no need to mod by POLY1305_BLOCK_SIZE.
> > > +     size_t num = ctx->num % POLY1305_BLOCK_SIZE;
> > Same here.
>
> I know, but I was having a hard time convincing gcc-8 of that
> invariant, and it was warning me. Perhaps this is something they
> fixed, though, between 8.1 and 8.2 though. I'll check back and adjust
> accordingly.

This was changed here:
https://git.zx2c4.com/WireGuard/commit/?id=37f114a73ba37219b00a66f0a51219a696599745

I can't reproduce with 8.2 anymore, so perhaps I should remove it now.
Unless you'd like to avoid a warning on old compilers. Since there's
no difference in speed, probably we should avoid the 8.1 warning and
leave it be?
