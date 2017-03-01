From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Wed, 1 Mar 2017 10:30:20 +0200
Message-ID: <CAOtvUMf3c0fUjABmbfMrbs0W4gyhKVZyc_tZH3rQg65zF18YMg@mail.gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
	<CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
	<CAHv-k_8rgArzV2uQ64h1ZTNRpssX1jMf=RwuPoBmsjQ0FhCsWA@mail.gmail.com>
	<68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Binoy Jayan <binoy.jayan@linaro.org>, Rajendra <rnayak@codeaurora.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, Oded <oded.golombek@arm.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>, Ofir <Ofir.Drang@arm.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com>
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

On Tue, Feb 28, 2017 at 11:05 PM, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 02/22/2017 07:12 AM, Binoy Jayan wrote:
> >
> > I was wondering if this is near to be ready for submission (apart from
> > the testmgr.c
> > changes) or I need to make some changes to make it similar to the IPSec offload?
>
> I just tried this and except it registers the IV for every new device again, it works...
> (After a while you have many duplicate entries in /proc/crypto.)
>
> But I would like to see some summary why such a big patch is needed in the first place.
> (During an internal discussions seems that people are already lost in mails and
> patches here, so Ondra promised me to send some summary mail soon here.)
>
> IIRC the first initial problem was dmcrypt performance on some embedded
> crypto processors that are not able to cope with small crypto requests effectively.
>
>
> Do you have some real performance numbers that proves that such a patch is adequate?
>
> I would really like to see the performance issue fixed but I am really not sure
> this approach works for everyone. It would be better to avoid repeating this exercise later.
> IIRC Ondra's "bulk" mode, despite rejected, shows that there is a potential
> to speedup things even for crypt drivers that do not support own IV generators.
>

AFAIK the problem that we are trying to solve is that if the IV is
generated outside the crypto API
domain than you are forced to have an invocation of the crypto API per
each block because you
need to provide the IV for each block.

By putting the IV generation responsibility in the Crypto API we open
the way to do a single invocation
of the crypto API for a whole sequence of blocks.

For software implementation of XTS this doesn't matter much - but for
hardware based XTS providers
that can do the IV generation themselves it's the difference between a
sequence of small invocation,
with all the overhead that that entails  and a single big invocatio -
and this can be big.

This lead some vendors to ship hacked up versions of dm-crypt to match
the specific crypto hardware
they were using, or so I've heard at least - didn't see the code myself.

I believe Binoy is trying to address this in a generic upstream worthy
way instead.

Anyway, you are only supposed to see s difference when using a
hardware based XTS provider algo
that supports IV generation.

> I like the patch is now contained inside dmcrypt, but it still exposes IVs that
> are designed just for old, insecure, compatibility-only containers.
>
> I really do not think every compatible crap must be accessible through crypto API.
> (I wrote the dmcrypt lrw and tcw compatibility IVs and I would never do that this way
> if I know it is accessible outside of dmcrypt internals...)
> Even the ESSIV is something that was born to fix predictive IVs (CBC watermarking
> attacks) for disk encryption only, no reason to expose it outside of disk encryption.
>

The point is that you have more than one implementation of these
"compatible crap" - the
software implementation that you wrote and potentially multiple
hardware implementations
and putting this in the crypto API domain is the way to abstract this
so you use the one
that works best of your platform.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
