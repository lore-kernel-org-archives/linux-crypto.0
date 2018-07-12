From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] [RESEND, net-next, v2] tcp: use monotonic timestamps
 for PAWS
Date: Thu, 12 Jul 2018 14:50:53 -0700 (PDT)
Message-ID: <20180712.145053.375746969660293612.davem@davemloft.net>
References: <20180711101757.3929777-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        harsh@chelsio.com, herbert@gondor.apana.org.au,
        atul.gupta@chelsio.com, gustavo@embeddedor.com, werner@chelsio.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
To: arnd@arndb.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711101757.3929777-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 11 Jul 2018 12:16:12 +0200

> Using get_seconds() for timestamps is deprecated since it can lead
> to overflows on 32-bit systems. While the interface generally doesn't
> overflow until year 2106, the specific implementation of the TCP PAWS
> algorithm breaks in 2038 when the intermediate signed 32-bit timestamps
> overflow.
> 
> A related problem is that the local timestamps in CLOCK_REALTIME form
> lead to unexpected behavior when settimeofday is called to set the system
> clock backwards or forwards by more than 24 days.
> 
> While the first problem could be solved by using an overflow-safe method
> of comparing the timestamps, a nicer solution is to use a monotonic
> clocksource with ktime_get_seconds() that simply doesn't overflow (at
> least not until 136 years after boot) and that doesn't change during
> settimeofday().
> 
> To make 32-bit and 64-bit architectures behave the same way here, and
> also save a few bytes in the tcp_options_received structure, I'm changing
> the type to a 32-bit integer, which is now safe on all architectures.
> 
> Finally, the ts_recent_stamp field also (confusingly) gets used to store
> a jiffies value in tcp_synq_overflow()/tcp_synq_no_recent_overflow().
> This is currently safe, but changing the type to 32-bit requires
> some small changes there to keep it working.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: use time_before32()/time_after32() everywhere as suggested
>     Eric Dumazet in https://lore.kernel.org/lkml/67ebb94d-c73f-6c9f-493b-00c86f595120@gmail.com/

Applied.
