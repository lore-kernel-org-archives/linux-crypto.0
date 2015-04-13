From: arno@natisbad.org (Arnaud Ebalard)
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Mon, 13 Apr 2015 18:06:49 +0200
Message-ID: <87r3rom2qu.fsf@natisbad.org>
References: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
	<20150410135056.GB28873@io.lakedaemon.net>
	<20150410171148.07bc9429@bbrezillon>
	<20150410223008.GA18660@io.lakedaemon.net>
	<552B8EC4.209@free-electrons.com>
	<20150413124711.GI18660@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <info@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Eran Ben-Avi <benavi@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>, devicetree@vger.kernel.org,
	Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	linux-crypto@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Lior Amsalem <alior@marvell.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 36.223.133.77.rev.sfr.net ([77.133.223.36]:43900 "EHLO
	smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbbDMQHt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Apr 2015 12:07:49 -0400
In-Reply-To: <20150413124711.GI18660@io.lakedaemon.net> (Jason Cooper's
	message of "Mon, 13 Apr 2015 12:47:11 +0000")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jason,

Jason Cooper <jason@lakedaemon.net> writes:

> It's not about the crypto, it's about trust.  imho, one of the most
> important security advances in the past 20 years is the default use of
> git (or other SCMs) by open source projects.  Now, no one is forced to
> trust the authors and maintainers tarball dumps.  Regular code audits
> and security updates are *much* more feasible because you can audit
> small changes.  It can even be automated to a large extent.
>
> All this means the user has a choice: they can trust the authors and
> maintainers, or they can trust their own audits.  Since updates are an
> essential part of a security posture, small commits facilitate
> maintaining the 'trust in audits'.
>
> It's not about "Should you trust free-electrons?"  Or, "Should you trust
> Jason / Herbert / Linus?"  It's about "Should you have to trust any of
> them?"

It's ok, you can call our driver fat. It is ;-) More seriously, I tend
to agree w/ what you write above.


>> >> I really tried to adapt the existing driver to add the missing
>> >> features (especially the support for TDMA), but all my attempts
>> >> ended up introducing hackish code (not even talking about the
>> >> performance penalty of this approach).
>> > 
>> > Ok, fair enough.  It would be helpful if this account of attempting to
>> > reconcile the old driver made it into the commit message.  This puts us
>> > in "perfect is the enemy of getting it done" territory.
>> > 
>> >> I have another solution though: keep the existing driver for old
>> >> marvell SoCs (orion, kirkwood and dove), and add a new one for modern
>> >> SoCs (armada 370, XP, 375 and 38x), so that users of the mv_cesa driver
>> >> won't have to audit the new code.
>> > 
>> > A fair proposal, but I'll freely admit the number of people actually auditing
>> > their code paths is orders of magnitude smaller than the number of users
>> > of the driver.
>> > 
>> > There's such a large population of compatible legacy SoCs in the wild,
>> > adding an artificial boundary doesn't make sense.  Especially since
>> > we're talking about features everyone would want to use.
>> > 
>> > Perhaps we should keep both around, and deprecate the legacy driver over
>> > 3 to 4 cycles?
>> 
>> But I guess that some users will want to use the new driver on the "old" marvell
>> SoCs (especially kirkwood and dove).
>
> Yes, despite my arguments, I'm one of those people.  :-P
>
>> If we go to this path, then the best solution would be to still update
>> all the the dts, and modifying the old driver to be able to use the
>> new binding: for my point of view the only adaptation should be
>> related to the SRAM. It will be also needed to find a way to be able
>> to load only one driver at a time: either the old or the new, but not
>> both.

The approach Boris proposed above seems to make everyone happy:

 1) Keep the old driver for old marvells SoCs (kirkwood, dove and orion)
 2) Introduce the new driver for those that are not supported by the old
    driver, i.e. armada (370, XP, 375, 38x)

AFAICT, this can easily be done (based on compatible strings) and it
will let everyone the time to audit the new driver. Current users will
not be taken by surprise. At some point, when everyone is confident w/
the new driver, we can then switch to that one for all SoCs so that
old platform get more performance.

Additionnally, for those who want to get the feature of the new driver
for their old SoC right now, we *could* add a simple kernel config option
for the new driver to use it for the old SoC too (that one disabling the
old one).


> I'd appreciate if we'd look into it.  I understand from on-list and
> off-list discussion that the rewrite was unavoidable.  So I'm willing to
> concede that.  Giving people time to migrate from old to new while still
> being able to update for other security fixes seems reasonable.

Jason, what do you think of the approach above? 

Cheers,

a+
