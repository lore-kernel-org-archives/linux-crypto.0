From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] [RESEND, net-next, v2] tcp: use monotonic timestamps for
 PAWS
Date: Wed, 11 Jul 2018 05:17:47 -0700
Message-ID: <ff297506-d0eb-f242-b623-3b158dbabe0c@gmail.com>
References: <20180711101757.3929777-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Atul Gupta <atul.gupta@chelsio.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Michael Werner <werner@chelsio.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711101757.3929777-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 07/11/2018 03:16 AM, Arnd Bergmann wrote:
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

Nit: This is only manipulated under socket lock protection, so it is safe even on 
32bit kernels.

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

SGTM, thanks Arnd

Signed-off-by: Eric Dumazet <edumazet@google.com>
