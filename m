From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 12/20] zinc: BLAKE2s generic C implementation
 and selftest
Date: Wed, 19 Sep 2018 02:45:46 +0200
Message-ID: <CAHmME9quryj4RW6gDEYiXpz61oh-xcEett3kv36ZZ4y1in-yTQ@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-13-Jason@zx2c4.com>
 <20180919004132.GB74746@gmail.com>
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
In-Reply-To: <20180919004132.GB74746@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Eric,

On Wed, Sep 19, 2018 at 2:41 AM Eric Biggers <ebiggers@kernel.org> wrote:
> This buffer is 4 times too long.

Nice catch.

> Or how about something much simpler:
>
> static inline void blake2s_final(struct blake2s_state *state, u8 *out,
>                                  const size_t outlen)
> {
> #ifdef DEBUG
>         BUG_ON(!out || !outlen || outlen > BLAKE2S_OUTBYTES);
> #endif
>         __blake2s_final(state);
>
>         cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
>         memcpy(out, state->h, outlen);
>
>         memzero_explicit(state, sizeof(*state));
> }

Oh, that's excellent, thanks. Much better than prior. I'll do exactly that.

Jason
