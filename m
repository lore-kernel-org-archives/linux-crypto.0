From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] [net-next, v2] tcp: use monotonic timestamps for PAWS
Date: Tue, 19 Jun 2018 16:38:11 -0700
Message-ID: <e3552cdb-a22c-5577-42a0-0f695e42e784@gmail.com>
References: <20180619123724.2535981-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: y2038@lists.linaro.org, Harsh Jain <harsh@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Michael Werner <werner@chelsio.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>,
        Lawrence Brakmo <brakmo@fb.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619123724.2535981-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 06/19/2018 05:36 AM, Arnd Bergmann wrote:
> Using get_seconds() for timestamps is deprecated since it can lead
> to overflows on 32-bit systems. While the interface generally doesn't
> overflow until year 2106, the specific implementation of the TCP PAWS
> algorithm breaks in 2038 when the intermediate signed 32-bit timestamps
> overflow.
> 
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: use time_before32()/time_after32() everywhere as suggested
>     Eric Dumazet


Thanks a lot Arnd.

Signed-off-by: Eric Dumazet <edumazet@google.com>
