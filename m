From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
Date: Thu, 27 Sep 2018 03:15:26 +0200
Message-ID: <20180927011526.GB1193@lunn.ch>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-24-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180925145622.29959-24-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason

I know you have been concentrating on the crypto code, so i'm not
expecting too many changes at the moment in the network code.

It would be good to further reduce the number of checkpatch warnings.
The biggest problem i have at the moment is that all the trivial to
fix warnings are hiding a few more important warnings. There are a few
like these which are not obvious to see:

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#2984: FILE: drivers/net/wireguard/noise.c:293:
+       BUG_ON(first_len > BLAKE2S_HASH_SIZE || second_len > BLAKE2S_HASH_SIZE ||

WARNING: Macros with flow control statements should be avoided
#5471: FILE: drivers/net/wireguard/selftest/allowedips.h:456:
+#define init_peer(name) do {                                               \
+               name = kzalloc(sizeof(*name), GFP_KERNEL);                 \
+               if (unlikely(!name)) {                                     \
+                       pr_info("allowedips self-test: out of memory\n");  \
+                       goto free;                                         \
+               }                                                          \
+               kref_init(&name->refcount);                                \
+       } while (0)


The namespace pollution also needs to be addresses. You have some
pretty generic named global symbols. I picked out a few examples from
objdump

00002a94 g     F .text	    00000060 peer_put
00003484 g     F .text	    0000004c timers_stop
00003520 g     F .text	    00000114 packet_queue_init
00002640 g     F .text	    00000034 device_uninit
000026bc g     F .text	    00000288 peer_create
000090d4 g     F .text	    000001bc ratelimiter_init

Please make use of a prefix for global symbols, e.g. wg_.

       Andrew
