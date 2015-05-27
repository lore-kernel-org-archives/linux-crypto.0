From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v3 14/16] ARM: marvell/dt: enable crypto on armada-xp-gp
Date: Wed, 27 May 2015 13:33:37 +0200
Message-ID: <5565AB91.1010008@free-electrons.com>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>	<1432301642-11470-15-git-send-email-boris.brezillon@free-electrons.com>	<55633B6D.7080307@free-electrons.com>	<20150526105936.25db3afb@bbrezillon>	<55659A81.3040600@free-electrons.com> <20150527132346.40bf820c@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57224 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585AbbE0Ldj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 07:33:39 -0400
In-Reply-To: <20150527132346.40bf820c@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Thomas, Boris,

On 27/05/2015 13:23, Thomas Petazzoni wrote:
> Dear Gregory CLEMENT,
> 
> On Wed, 27 May 2015 12:20:49 +0200, Gregory CLEMENT wrote:
> 
>> But is it really depending of the board itself?
>> I see that the first lines are the same on all the dts, I just remember that
>> there was a reason why we could not put it in the dtsi.
> 
> Yes, because the DT language doesn't have a += operator, basically.
> 
> Some of the MBus ranges are inherently board-specific: when you have a
> NOR flash, you need a specific MBus range for it. And such a MBus range
> is board-specific.
> 
> Since it's not possible to do:
> 
> 	ranges = <SoC level ranges>
> 
> in .dtsi, and:
> 
> 	ranges += <board level ranges>
> 
> in .dts, we simply decided to always put:
> 
> 	ranges = <SoC level and board level ranges>
> 
> in the .dts.
> 
> It does create some duplication, but that's the best we could do with
> the existing DT infrastructure.

Thanks for the remainder.

So I think we should duplicate the crypto related part in all the dts
file which use an Armada XP SoC. And we don't have to test it again
as soon as it was tested on an Armada XP board (and it is the case
with the Armada XP one).

Gregory


> 
> Best regards,
> 
> Thomas
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
