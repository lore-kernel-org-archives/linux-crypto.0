From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 03/20] zinc: ChaCha20 generic C implementation
 and selftest
Date: Wed, 19 Sep 2018 04:02:51 +0200
Message-ID: <CAHmME9qOZEBNr0yndDWmfGMwuFSsN16n4KCDUSdHCPtCVe+Afw@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-4-Jason@zx2c4.com>
 <20180919010816.GD74746@gmail.com>
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
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180919010816.GD74746@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 19, 2018 at 3:08 AM Eric Biggers <ebiggers@kernel.org> wrote:
> Does this consistently perform as well as an implementation that organizes the
> operations such that the quarterrounds for all columns/diagonals are
> interleaved?  As-is, there are tight dependencies in QUARTER_ROUND() (as well as
> in the existing chacha20_block() in lib/chacha20.c, for that matter), so we're
> heavily depending on the compiler to do the needed interleaving so as to not get
> potentially disastrous performance.  Making it explicit could be a good idea.

It does perform as well, and the compiler outputs good code, even on
older compilers. Notably that's all a single statement (via the comma
operator).

> > +}
> > +
> > +static void chacha20_generic(u8 *out, const u8 *in, u32 len, const u32 key[8],
> > +                          const u32 counter[4])
> > +{
> > +     __le32 buf[CHACHA20_BLOCK_WORDS];
> > +     u32 x[] = {
> > +             EXPAND_32_BYTE_K,
> > +             key[0], key[1], key[2], key[3],
> > +             key[4], key[5], key[6], key[7],
> > +             counter[0], counter[1], counter[2], counter[3]
> > +     };
> > +
> > +     if (out != in)
> > +             memmove(out, in, len);
> > +
> > +     while (len >= CHACHA20_BLOCK_SIZE) {
> > +             chacha20_block_generic(buf, x);
> > +             crypto_xor(out, (u8 *)buf, CHACHA20_BLOCK_SIZE);
> > +             len -= CHACHA20_BLOCK_SIZE;
> > +             out += CHACHA20_BLOCK_SIZE;
> > +     }
> > +     if (len) {
> > +             chacha20_block_generic(buf, x);
> > +             crypto_xor(out, (u8 *)buf, len);
> > +     }
> > +}
>
> If crypto_xor_cpy() is used instead of crypto_xor(), and 'in' is incremented
> along with 'out', then the memmove() is not needed.

Nice idea, thanks. Implemented.

Jason
