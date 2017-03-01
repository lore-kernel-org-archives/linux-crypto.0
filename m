From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Wed, 1 Mar 2017 14:42:04 +0200
Message-ID: <CAOtvUMePYT7OJDKL7i0y3y6Jvqsxyx6Je6g9aGKVq6PLZ_-Z8w@mail.gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
	<CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
	<CAHv-k_8rgArzV2uQ64h1ZTNRpssX1jMf=RwuPoBmsjQ0FhCsWA@mail.gmail.com>
	<68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com>
	<CAOtvUMf3c0fUjABmbfMrbs0W4gyhKVZyc_tZH3rQg65zF18YMg@mail.gmail.com>
	<b563eb97-82ba-69d2-c4c5-66bc716a7507@gmail.com>
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
In-Reply-To: <b563eb97-82ba-69d2-c4c5-66bc716a7507@gmail.com>
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

On Wed, Mar 1, 2017 at 11:29 AM, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 03/01/2017 09:30 AM, Gilad Ben-Yossef wrote:
> > On Tue, Feb 28, 2017 at 11:05 PM, Milan Broz <gmazyland@gmail.com> wrote:
> >>
> >> On 02/22/2017 07:12 AM, Binoy Jayan wrote:
> >>>
> >>> I was wondering if this is near to be ready for submission (apart from
> >>> the testmgr.c
> >>> changes) or I need to make some changes to make it similar to the IPSec offload?
> >>
> >> I just tried this and except it registers the IV for every new device again, it works...
> >> (After a while you have many duplicate entries in /proc/crypto.)
> >>
> >> But I would like to see some summary why such a big patch is needed in the first place.
> >> (During an internal discussions seems that people are already lost in mails and
> >> patches here, so Ondra promised me to send some summary mail soon here.)
> >>
> >> IIRC the first initial problem was dmcrypt performance on some embedded
> >> crypto processors that are not able to cope with small crypto requests effectively.
> >>
> >>
> >> Do you have some real performance numbers that proves that such a patch is adequate?
> >>
> >> I would really like to see the performance issue fixed but I am really not sure
> >> this approach works for everyone. It would be better to avoid repeating this exercise later.
> >> IIRC Ondra's "bulk" mode, despite rejected, shows that there is a potential
> >> to speedup things even for crypt drivers that do not support own IV generators.
> >>
> >
> > AFAIK the problem that we are trying to solve is that if the IV is
> > generated outside the crypto API
> > domain than you are forced to have an invocation of the crypto API per
> > each block because you
> > need to provide the IV for each block.
> >
> > By putting the IV generation responsibility in the Crypto API we open
> > the way to do a single invocation
> > of the crypto API for a whole sequence of blocks.
>
> Sure, but this is theory. Does it really work on some hw already?
> Do you have performance measurements or comparison?

I'm working on up streaming a driver for Arm  CryptoCell that supports
this and working
offline to get Binoy a board to test this with. Alas, shipping crypto
HW has its fair share
of regulatory challenges... :-)

I can certainly understand if you don't wont to take the patch until
we have results with
dm-crypt itself but the difference between 8 separate invocation of
the engine for 512
bytes of XTS and a single invocation for 4KB are pretty big.

>From what I know of HW engines I'd be surprised if this is in any way
unique to CryptoCell.

> > For software implementation of XTS this doesn't matter much - but for
> > hardware based XTS providers
>
> It is not only embedded crypto, we have some more reports in the past
> that 512B sectors are not ideal even for other systems.
> (IIRC it was also with AES-NI that represents really big group of users).

I never said anything about embedded :-)

It really is an observation about overhead of context switches between
dm-crypt and
whatever/wherever you handle crypto - be it an off CPU hardware engine
or a bunch
of parallel kernel threads running on other cores. You really want to
burst as much as
possible.


>
> > This lead some vendors to ship hacked up versions of dm-crypt to match
> > the specific crypto hardware
> > they were using, or so I've heard at least - didn't see the code myself.
>
> I saw few version of that. There was a very hacky way to provide request-based dmcrypt
> (see old "Introduce the request handling for dm-crypt" thread on dm-devel).
> This is not the acceptable way but definitely it points to the same problem.
>
> > I believe Binoy is trying to address this in a generic upstream worthy
> > way instead.
>
> IIRC the problem is performance, if we can solve it by some generic way,
> good, but for now it seems to be a big change and just hope it helps later...
>

I see what you're saying. We need number to back this up.

> > Anyway, you are only supposed to see s difference when using a
> > hardware based XTS provider algo
> > that supports IV generation.
> >
> >> I like the patch is now contained inside dmcrypt, but it still exposes IVs that
> >> are designed just for old, insecure, compatibility-only containers.
> >>
> >> I really do not think every compatible crap must be accessible through crypto API.
> >> (I wrote the dmcrypt lrw and tcw compatibility IVs and I would never do that this way
> >> if I know it is accessible outside of dmcrypt internals...)
> >> Even the ESSIV is something that was born to fix predictive IVs (CBC watermarking
> >> attacks) for disk encryption only, no reason to expose it outside of disk encryption.
> >>
> >
> > The point is that you have more than one implementation of these
> > "compatible crap" - the
> > software implementation that you wrote and potentially multiple
> > hardware implementations
> > and putting this in the crypto API domain is the way to abstract this
> > so you use the one
> > that works best of your platform.
>
> For XTS you need just simple linear IV. No problem with that, implementation
> in crypto API and hw is trivial.
>
> But for compatible IV (that provides compatibility with loopAES and very old TrueCrypt),
> these should be never ever implemented again anywhere.

>
> Specifically "tcw" is broken, insecure and provided here just to help people to migrate
> from old Truecrypt containers. Even Truecrypt followers removed it from the codebase.
> (It is basically combination of IV and slight modification of CBC mode. All
> recent version switched to XTS and plain IV.)
>
> So building abstraction over something known to be broken and that is now intentionally
> isolated inside dmcrypt is, in my opinion, really not a good idea.
>

I don't think anyone is interested in these modes. How do you support
XTS and essiv in
a generic way without supporting this broken modes is not something
I'm clear on though.

>
> But please do get me wrong,  I do not want to block any improvement.
>
> But it seems to me that this thread focused on creating nice crypto API interface
> for FDE IVs instead of demonstration that the proposed solution really solves
> the performance issue.
> And not only for your hw driver, maybe other systems could benefit from the better
> processing of small requests as well.
>

Of course, the benefits at large needs to outweigh the cost. But I
don't think functioning
better when working on large bursts is in any way special to specific HW.

Indeed, I wonder if we can show a benefit for just cryptd use case.
I'll look into that.

Thanks,
Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
