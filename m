From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/3] crypto: fixes for Marvell hash
Date: Fri, 9 Oct 2015 13:31:32 +0100
Message-ID: <20151009123132.GP32532@n2100.arm.linux.org.uk>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
 <20151009141243.329dd60d@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:50327 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbbJIMbk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 08:31:40 -0400
Content-Disposition: inline
In-Reply-To: <20151009141243.329dd60d@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 09, 2015 at 02:12:43PM +0200, Thomas Petazzoni wrote:
> Hello Russell,
> 
> On Fri, 9 Oct 2015 11:29:05 +0100, Russell King - ARM Linux wrote:
> > This small series of patches addresses oopses seen when trying to use
> > the AF_ALG interface via openssl with openssh.  This series does not
> > address all problems, but merely stops the kernel from smashing its
> > kernel stack and oopsing.
> 
> Thanks for debugging this and for the patches. However, could you Cc
> the main authors of the driver:
> 
> Boris Brezillon <boris.brezillon@free-electrons.com>
> Arnaud Ebalard <arno@natisbad.org>

Hmm.  You know, given how broken this is, I've a good mind to say that
this is more hassle than it's worth to get these simple fixes merged,
especially as there's no MAINTAINERS entry for them.  I'm not sending
the patch series a third time.  I could say if maintainers can't be
bothered to ensure that they're listed in MAINTAINERS then they aren't
maintainers at all.

If this means it won't be merged, so be it, I don't care enough given
that there's very little userspace support for kernel hw crypto.

> > I'm not sure who the maintainer for drivers/crypto/marvell is, so I've
> > picked Thomas.  It would be nice if there was an entry in MAINTAINERS
> > for this driver.
> 
> Indeed. However get_maintainer.pl gets this right:

Try with --no-git, which is the only sane mode for using get_maintainer.pl.
Picking up everyone who's ever touched a driver with as little as a spelling
fix in a git commit is abhorrent.

> $ ./scripts/get_maintainer.pl -f drivers/crypto/marvell/cesa.c 
> Herbert Xu <herbert@gondor.apana.org.au> (maintainer:CRYPTO API,commit_signer:11/12=92%)
> "David S. Miller" <davem@davemloft.net> (maintainer:CRYPTO API)
> Boris BREZILLON <boris.brezillon@free-electrons.com> (commit_signer:11/12=92%,authored:6/12=50%,added_lines:538/558=96%,removed_lines:7/12=58%)
> Arnaud Ebalard <arno@natisbad.org> (commit_signer:7/12=58%,authored:4/12=33%,removed_lines:1/12=8%)
> Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com> (commit_signer:1/12=8%,authored:1/12=8%,removed_lines:3/12=25%)
> Krzysztof Kozlowski <k.kozlowski@samsung.com> (commit_signer:1/12=8%,authored:1/12=8%,removed_lines:1/12=8%)
> 
> Thomas
> -- 
> Thomas Petazzoni, CTO, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
