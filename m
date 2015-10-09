From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 0/3] crypto: fixes for Marvell hash
Date: Fri, 9 Oct 2015 14:40:54 +0200
Message-ID: <20151009144054.46a319c1@free-electrons.com>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
	<20151009141243.329dd60d@free-electrons.com>
	<20151009123132.GP32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57878 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754401AbbJIMk6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 08:40:58 -0400
In-Reply-To: <20151009123132.GP32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

On Fri, 9 Oct 2015 13:31:32 +0100, Russell King - ARM Linux wrote:

> > Thanks for debugging this and for the patches. However, could you Cc
> > the main authors of the driver:
> > 
> > Boris Brezillon <boris.brezillon@free-electrons.com>
> > Arnaud Ebalard <arno@natisbad.org>
> 
> Hmm.  You know, given how broken this is, I've a good mind to say that
> this is more hassle than it's worth to get these simple fixes merged,
> especially as there's no MAINTAINERS entry for them.  I'm not sending
> the patch series a third time.  I could say if maintainers can't be
> bothered to ensure that they're listed in MAINTAINERS then they aren't
> maintainers at all.

I agree they should be list in MAINTAINERS. But rather than immediately
becoming nervous, maybe we can simply consider this as an oversight
that Boris and Arnaud will fix by sending a simple patch, and the
problem is done?

> If this means it won't be merged, so be it, I don't care enough given
> that there's very little userspace support for kernel hw crypto.

These fixes will definitely be merged. Boris and Arnaud are not stupid
to the point of rejecting patches simply because the submitter forgot
to Cc: them. The value of such fixes is higher than a silly procedural
discussion about Cc's.

> > Indeed. However get_maintainer.pl gets this right:
> 
> Try with --no-git, which is the only sane mode for using get_maintainer.pl.
> Picking up everyone who's ever touched a driver with as little as a spelling
> fix in a git commit is abhorrent.

Agreed. I myself never used get_maintainer.pl for this reason :-)

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
