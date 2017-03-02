From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Thu, 2 Mar 2017 16:01:03 +0200
Message-ID: <CAOtvUMf9Ph5Q=Pq_d3OpjSN1eXRNFLFmxcFgnm+KRKYskQ-d2w@mail.gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
	<CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
	<CAHv-k_8rgArzV2uQ64h1ZTNRpssX1jMf=RwuPoBmsjQ0FhCsWA@mail.gmail.com>
	<68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com>
	<CAOtvUMf3c0fUjABmbfMrbs0W4gyhKVZyc_tZH3rQg65zF18YMg@mail.gmail.com>
	<b563eb97-82ba-69d2-c4c5-66bc716a7507@gmail.com>
	<CAOtvUMePYT7OJDKL7i0y3y6Jvqsxyx6Je6g9aGKVq6PLZ_-Z8w@mail.gmail.com>
	<CAFqZXNugEK0do+BYC061i4CidMVgg8_BZue8gUVa2g7_RYsAEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Binoy Jayan <binoy.jayan@linaro.org>, Rajendra <rnayak@codeaurora.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, Oded <oded.golombek@arm.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Milan Broz <gmazyland@gmail.com>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>, Ofir <Ofir.Drang@arm.com>
To: Ondrej Mosnacek <omosnace@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFqZXNugEK0do+BYC061i4CidMVgg8_BZue8gUVa2g7_RYsAEw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 1, 2017 at 3:21 PM, Ondrej Mosnacek <omosnace@redhat.com> wrote:
> 2017-03-01 13:42 GMT+01:00 Gilad Ben-Yossef <gilad@benyossef.com>:
>
> Wouldn't adopting a bulk request API (something like what I tried to
> do here [1]) that allows users to supply multiple messages, each with
> their own IV, fulfill this purpose? That way, we wouldn't need to
> introduce any new modes into Crypto API and the drivers/accelerators
> would only need to provide bulk implementations of common modes
> (xts(aes), cbc(aes), ...) to provide better performance for dm-crypt
> (and possibly other users, too).
>
> I'm not sure how exactly these crypto accelerators work, but wouldn't
> it help if the drivers simply get more messages (in our case sectors)
> in a single call? I wonder, would (efficiently) supporting such a
> scheme require changes in the HW itself or could it be achieved just
> by modifying driver code (let's say specifically for your CryptoCell
> accelerator)?
>
> [1] https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg23007.html
>


>From a general perspective - that is things are expect to be true not
just for CryptoCell but for most HW crypto engines,
you want two things - for the HW engine to be able to burst work for a
long time and than rest for a long time vs. a stop and go scheme
(engine utilization)
and for the average IO transaction to be relatively long (bus utilization)

So, a big cluster size i.e. Milan's proposal) works great - you get both.

Submitting a series of sequential small clusters where the HW can
calculate the IV (e.g. Binoy's proposal) works great if the HW
supports it - you get both.

A batched series of small clusters + IV is less favorable - if your HW
engines has lots of parallel context processing (this is expensive for
HW) you might enjoy engine utilization but the bus utilization will be
low - lots of small transactions.

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
