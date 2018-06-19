From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next 3/3] tcp: use monotonic timestamps for PAWS
Date: Tue, 19 Jun 2018 11:23:45 +0200
Message-ID: <CAK8P3a2Z+H7r=dWqYmKbJ2mAMZEdvT6GdKjSMbweabqBwOZYEg@mail.gmail.com>
References: <20180618152242.1566661-1-arnd@arndb.de> <20180618152242.1566661-3-arnd@arndb.de>
 <67ebb94d-c73f-6c9f-493b-00c86f595120@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Atul Gupta <atul.gupta@chelsio.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Michael Werner <werner@chelsio.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Ursula Braun <ubraun@linux.vnet.ibm.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        D
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <67ebb94d-c73f-6c9f-493b-00c86f595120@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 18, 2018 at 5:59 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 06/18/2018 08:22 AM, Arnd Bergmann wrote:
>
> Please use the time_after32(), since ktime_get_seconds() is time64_t while ts_recent_stamp is int.
>
> Same remark for tcp_twsk_unique()
>
> Lets clean up this stuff, thanks !

Sure, no problem. Note that as ktime_get_seconds() uses CLOCK_MONOTONIC, it is
guaranteed to return a number that fits into a positive 32-bit number
(for about 136
years after boot to be precise). Most users of time_after() or
time_after32() are for
jiffies values that do overflow regularly, but it doesn't hurt to use
time_after32()
here for illustration.

        Arnd
