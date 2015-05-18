From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/8] ARM: mvebu: Add support for RAID6 PQ offloading
Date: Mon, 18 May 2015 10:06:55 -0700
Message-ID: <CAPcyv4jbW=B_mYfx5HfKckLYeWctfC-9jYeDf0Z1APvQZfHj6Q@mail.gmail.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
	<CAPcyv4gshyaji2HarAeOg3XOiNnmGwnSOMuFGWpuDu8ZTGg=jw@mail.gmail.com>
	<20150513091733.GW10961@lukather>
	<CAPcyv4jv=xWHbrO=rKhnWt9zFn8vkhS2J5mJiCBKKwESdUk5tg@mail.gmail.com>
	<20150518091454.GP4004@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Vinod Koul <vinod.koul@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	"dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150518091454.GP4004@lukather>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 18, 2015 at 2:14 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi Dan,
>
> On Wed, May 13, 2015 at 09:00:46AM -0700, Dan Williams wrote:
>> On Wed, May 13, 2015 at 2:17 AM, Maxime Ripard
>> <maxime.ripard@free-electrons.com> wrote:
>> > Hi Dan,
>> >
>> > On Tue, May 12, 2015 at 09:05:41AM -0700, Dan Williams wrote:
>> >> On Tue, May 12, 2015 at 8:37 AM, Maxime Ripard
>> >> <maxime.ripard@free-electrons.com> wrote:
>> >> > Hi,
>> >> >
>> >> > This serie refactors the mv_xor in order to support the latest Armada
>> >> > 38x features, including the PQ support in order to offload the RAID6
>> >> > PQ operations.
>> >> >
>> >> > Not all the PQ operations are supported by the XOR engine, so we had
>> >> > to introduce new async_tx flags in the process to identify
>> >> > un-supported operations.
>> >> >
>> >> > Please note that this is currently not usable because of a possible
>> >> > regression in the RAID stack in 4.1 that is being discussed at the
>> >> > moment here: https://lkml.org/lkml/2015/5/7/527
>> >>
>> >> This is problematic as async_tx is a wart on the dmaengine subsystem
>> >> and needs to be deprecated, I just have yet to find the time to do
>> >> that work.  It turns out it was a mistake to hide the device details
>> >> from md, it should be explicitly managing the dma channels, not
>> >> relying on a abstraction api.  The async_tx api usage of the
>> >> dma-mapping api is broken in that it relies on overlapping mappings of
>> >> the same address.  This happens to work on x86, but on arm it needs
>> >> explicit non-overlapping mappings.  I started the work to reference
>> >> count dma-mappings in 3.13, and we need to teach md to use
>> >> dmaengine_unmap_data explicitly.  Yielding dma channel management to
>> >> md also results in a more efficient implementation as we can dma_map()
>> >> the stripe cache once rather than per-io.  The  "async_tx_ack()"
>> >> disaster can also go away when md is explicitly handling channel
>> >> switching.
>> >
>> > Even though I'd be very much in favor of deprecating / removing
>> > async_tx, is it something likely to happen soon?
>>
>> Not unless someone else takes it on, I'm actively asking for help.
>>
>> > I remember discussing this with Vinod at Plumbers back in October, but
>> > haven't seen anything since then.
>>
>> Right, "help!" :)
>>
>> > If not, I think that we shouldn't really hold back patches to
>> > async_tx, even though we know than in a year from now, it's going to
>> > be gone.
>>
>> We definitely should block new usages, because they make a bad
>> situation worse.  Russell already warned that the dma_mapping api
>> abuse could lead to data corruption on ARM (speculative pre-fetching).
>> We need to mark ASYNC_TX_DMA as "depends on !ARM" or even "depends on
>> BROKEN" until we can get this resolved.
>
> I'm not sure what the issues exactly are with async_tx and ARM, but
> these patches have been tested on ARM and are working quite well.

https://lkml.org/lkml/2011/7/8/363

> What I'm doing here is merely using the existing API, I'm not making
> it worse, just using the API that is used by numerous drivers
> already. So I'm not sure this is really reasonable to ask for such a
> huge rework (with a huge potential of regressions) before merging my
> patches.

It happens.

https://lwn.net/Articles/641443/

I'm not happy about not having had the time to do this rework myself.
Linux is better off with this api deprecated.
