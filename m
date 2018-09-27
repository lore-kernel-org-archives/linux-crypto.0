From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
Date: Fri, 28 Sep 2018 00:37:03 +0200
Message-ID: <CAHmME9q7WRGF3TTRhhy0i_EB4ad2DaSD=tnHM92zfV4Cckyw=A@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-24-Jason@zx2c4.com>
 <20180927011526.GB1193@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927011526.GB1193@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Andrew,

Thanks for following up with this.

On Thu, Sep 27, 2018 at 3:15 AM Andrew Lunn <andrew@lunn.ch> wrote:
> I know you have been concentrating on the crypto code, so i'm not
> expecting too many changes at the moment in the network code.

I should be addressing things in parallel, actually, so I'm happy to
work on this.

> WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> #2984: FILE: drivers/net/wireguard/noise.c:293:
> +       BUG_ON(first_len > BLAKE2S_HASH_SIZE || second_len > BLAKE2S_HASH_SIZE ||

I was actually going to ask you about this, because it applies
similarly in another context too that I'm trying to refine. The above
function you quote has the following properties:

- Only ever accepts fixed length parameters, so the compiler can
constant fold invocations of it fantastically. Those parameters are
fixed length in the sense that they're enum/macro constants. They
never come from the user or from a packet or something.
- Never produces an incorrect result. For said constants, all inputs
are valid, and so it succeeds in producing an output every time.
- Is a "pure" function, just knocking bytes around, without needing to
interact with fancy kernel-y things; could be implemented on some sort
of WWII-era rotor machine provided you had the patience.

Because of the above, there's never any error to return to the user of
the function. Also, because it only ever takes constant sized inputs,
in theory I should be able to change that BUG_ON() to BUILD_BUG_ON(),
but in practice the optimizer/inliner isn't actually that aggressive.

But what I would like is some way of signaling to the developer using
this function that they've passed it an illegal value, and their code
should not ship until that's fixed, under any circumstances at all  --
that their usage of the function is completely unacceptable and wrong.
Bla bla strong statements.

For this, I figured the notion would come across with the aberrant
behavior of "crash the developer's [in this case, my] QEMU instance"
when "#ifdef DEBUG is true". This is the same kind of place where I'd
have an "assert()" statement in userland. It sounds like what you're
saying is that a WARN_ON is equally as effective instead? Or given the
above, do you think the BUG_ON is actually sensible? Or neither and I
should do something else?

> WARNING: Macros with flow control statements should be avoided
> #5471: FILE: drivers/net/wireguard/selftest/allowedips.h:456:
> +#define init_peer(name) do {                                               \
> +               name = kzalloc(sizeof(*name), GFP_KERNEL);                 \
> +               if (unlikely(!name)) {                                     \
> +                       pr_info("allowedips self-test: out of memory\n");  \
> +                       goto free;                                         \
> +               }                                                          \
> +               kref_init(&name->refcount);                                \
> +       } while (0)

This is part of a debugging selftest, where I'm initing a bunch of
peers one after another, and this macro helps keep the test clear
while offloading the actual irrelevant coding part to this macro. The
test itself then just has code like:

    init_peer(a);
    init_peer(b);
    init_peer(c);
    init_peer(d);
    init_peer(e);
    init_peer(f);
    init_peer(g);
    init_peer(h);

    insert(4, a, 192, 168, 4, 0, 24);
    insert(4, b, 192, 168, 4, 4, 32);
    insert(4, c, 192, 168, 0, 0, 16);
    insert(4, d, 192, 95, 5, 64, 27);
    /* replaces previous entry, and maskself is required */
    insert(4, c, 192, 95, 5, 65, 27);
    insert(6, d, 0x26075300, 0x60006b00, 0, 0xc05f0543, 128);
    insert(6, c, 0x26075300, 0x60006b00, 0, 0, 64);
    ...

And so forth. I can probably figure out a different way to code this
if you really want, but I thought this would be clear.

> The namespace pollution also needs to be addresses. You have some
> pretty generic named global symbols. I picked out a few examples from
> objdump
>
> 00002a94 g     F .text      00000060 peer_put
> 00003484 g     F .text      0000004c timers_stop
> 00003520 g     F .text      00000114 packet_queue_init
> 00002640 g     F .text      00000034 device_uninit
> 000026bc g     F .text      00000288 peer_create
> 000090d4 g     F .text      000001bc ratelimiter_init
>
> Please make use of a prefix for global symbols, e.g. wg_.

Will do. v7 will include the wg_ prefix.

On a slightly related note, out of curiosity, any idea what's up with
the future of LTO in the kernel? It sounds like that'd be nice to have
on a module-by-module basis. IOW, I'd love to LTO all of my .c files
in wireguard together, and then only ever expose mod_init/exit and
whatever I explicitly EXPORT_SYMBOL, and then have the compiler and
linker treat the rest of everything as essentially in one .c file and
optimize the heck out of it, and then strip all the symbols. It would,
incidentally, remove the need for said symbol prefixes, since I
wouldn't be making anything global. (Probably perf/ftrace/etc would
become harder to use though.)

Jason
