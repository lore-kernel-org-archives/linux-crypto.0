From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH 0/8] ARM: mvebu: Add support for RAID6 PQ offloading
Date: Wed, 27 May 2015 14:52:34 +0300
Message-ID: <5565B002.5090404@plexistor.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>	<CAPcyv4gshyaji2HarAeOg3XOiNnmGwnSOMuFGWpuDu8ZTGg=jw@mail.gmail.com>	<20150513091733.GW10961@lukather>	<CAPcyv4jv=xWHbrO=rKhnWt9zFn8vkhS2J5mJiCBKKwESdUk5tg@mail.gmail.com>	<20150518091454.GP4004@lukather>	<CAPcyv4jbW=B_mYfx5HfKckLYeWctfC-9jYeDf0Z1APvQZfHj6Q@mail.gmail.com>	<20150526094511.GP8557@lukather> <CAPcyv4i06Mwis_CSrKV1Yo6crD1vrjb9it6RtYdtwbgOOY9a4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
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
	"David S. Miller" <davem@davemloft.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Boaz Harrosh <boaz@plexistor.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33143 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbE0Lwi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 07:52:38 -0400
Received: by wgez8 with SMTP id z8so7234727wge.0
        for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 04:52:37 -0700 (PDT)
In-Reply-To: <CAPcyv4i06Mwis_CSrKV1Yo6crD1vrjb9it6RtYdtwbgOOY9a4g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/26/2015 07:31 PM, Dan Williams wrote:
> [ adding Boaz as this discussion has implications for ore_raid ]
> 
<>
>> You're not talking about deprecating it, you're talking about removing
>> it entirely.
> 
> True, and adding more users makes that removal more difficult.  I'm
> willing to help out on the design and review for this work, I just
> can't commit to doing the implementation and testing.
> 
<>

Hi

So for ore_raid, Yes it uses both xor and pq functions, and I expect
that to work also after the API changes.

That said, I never really cared for the HW offload engines of these
APIs. Actually I never met any. On a modern machine I always got
the DCE/MMX kick in or one of the other CPU variants. With preliminary
testing of XOR I got an almost memory speed for xor (read n pages
+ write one) So with multy-core CPUs I fail to see how an HW do
better, memory caching and all. The PQ was not that far behind.

All I need is an abstract API that gives me the best implementation
on any ARCH / configuration. Actually the async_tx API is a pain
and a sync API would make things simple. I do not use the concurrent
async submit, wait later at all. I submit then wait.

So anything you change this to, as long as you keep the wonderful
dce implementation is good with me, just that the code keeps running
after the new API is fine with me.

(And the common structures between XOR and PQ was also nice, but I
 can also use a union, its always either or in ore_raid)

Once you make API changes and modify code, CC me I'll run tests

good luck
Boaz
