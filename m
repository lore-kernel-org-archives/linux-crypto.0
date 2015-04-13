From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Mon, 13 Apr 2015 11:39:16 +0200
Message-ID: <552B8EC4.209@free-electrons.com>
References: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com> <20150410135056.GB28873@io.lakedaemon.net> <20150410171148.07bc9429@bbrezillon> <20150410223008.GA18660@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <info@free-electrons.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>
To: Jason Cooper <jason@lakedaemon.net>,
	Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150410223008.GA18660@io.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason, Boris,

On 11/04/2015 00:30, Jason Cooper wrote:
> Hey Boris,
> 
> On Fri, Apr 10, 2015 at 05:11:48PM +0200, Boris Brezillon wrote:
>> On Fri, 10 Apr 2015 13:50:56 +0000 Jason Cooper <jason@lakedaemon.net> wrote:
>>> On Thu, Apr 09, 2015 at 04:58:41PM +0200, Boris Brezillon wrote:
>>>> I know we usually try to adapt existing drivers instead of replacing them
>>>> by new ones, but after trying to refactor the mv_cesa driver I realized it
>>>> would take longer than writing an new one from scratch.
>>>
>>> I'm sorry, but this makes me *very* uncomfortable.  Any organization
>>> worth it's salt will do a very careful audit of code touching
>>> cryptographic material and sensitive (decrypted) data.  From that point
>>> on, small audits of the changes to the code allow the organization to
>>> build a comfort level with kernel updates.  iow, following the git
>>> history of the driver.
>>>
>>> By apply this series, we are basically forcing those organizations to
>>> either a) stop updating, or b) expend significant resources to do
>>> another full audit.
>>>
>>> In short, this series breaks the audit chain for the mv_cesa driver.
>>>
>>> Maybe I'm the only person with this level of paranoia.  If so, I'm sure
>>> others will override me.
>>>
>>> From my POV, it looks like the *only* reason we've chosen this route is
>>> developer convenience.  I don't think that's sufficient reason to break
>>> the change history of a driver handling sensitive data.
>>
>> Well, I understand you concern, but if you read carefully the old and
>> new drivers, you'll notice that they are completely different (the only
>> thing I kept are the macro definitions).
> 
> Yes, that's the worrying part for me. ;-)

I understand the logic behind your concern, but I wonder if it is really
an issue. My knowledge ans my background around crypto is very limited,
so I really would like the opinion of other people on the subject.

> 
>> I really tried to adapt the existing driver to add the missing
>> features (especially the support for TDMA), but all my attempts
>> ended up introducing hackish code (not even talking about the
>> performance penalty of this approach).
> 
> Ok, fair enough.  It would be helpful if this account of attempting to
> reconcile the old driver made it into the commit message.  This puts us
> in "perfect is the enemy of getting it done" territory.
> 
>> I have another solution though: keep the existing driver for old
>> marvell SoCs (orion, kirkwood and dove), and add a new one for modern
>> SoCs (armada 370, XP, 375 and 38x), so that users of the mv_cesa driver
>> won't have to audit the new code.
> 
> A fair proposal, but I'll freely admit the number of people actually auditing
> their code paths is orders of magnitude smaller than the number of users
> of the driver.
> 
> There's such a large population of compatible legacy SoCs in the wild,
> adding an artificial boundary doesn't make sense.  Especially since
> we're talking about features everyone would want to use.
> 
> Perhaps we should keep both around, and deprecate the legacy driver over
> 3 to 4 cycles?

But I guess that some users will want to use the new driver on the "old" marvell
SoCs (especially kirkwood and dove). If we go to this path, then the best solution
would be to still update all the the dts, and modifying the old driver to be able to
use the new binding: for my point of view the only adaptation should be related
to the SRAM. It will be also needed to find a way to be able to load only one driver
at a time: either the old or the new, but not both.

However I still wonder if it worth the effort.


Thanks,

Gregory




> 
> thx,
> 
> Jason.
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
