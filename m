From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 14/16] ARM: marvell/dt: enable crypto on armada-xp-gp
Date: Tue, 26 May 2015 13:57:46 +0200
Message-ID: <20150526115746.GA28523@lunn.ch>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
 <1432301642-11470-15-git-send-email-boris.brezillon@free-electrons.com>
 <55633B6D.7080307@free-electrons.com>
 <20150526105936.25db3afb@bbrezillon>
 <op.xy8j7ryh2s3iss@ecaz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Imre Kaloz <kaloz@openwrt.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [178.209.37.122] ([178.209.37.122]:40687 "EHLO vps0.lunn.ch"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbbEZMEN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 08:04:13 -0400
Content-Disposition: inline
In-Reply-To: <op.xy8j7ryh2s3iss@ecaz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 26, 2015 at 11:22:45AM +0200, Imre Kaloz wrote:
> On Tue, 26 May 2015 10:59:36 +0200, Boris Brezillon
> <boris.brezillon@free-electrons.com> wrote:
> 
> <snip>
> 
> >>As the crypto engine really depend on the SoC itself and not of
> >>the board,
> >>what about updating the dts of the other board using an Armada XP?
> >
> >But that means introducing changes I haven't tested. Are you okay with
> >that ?
> 
> Well, worst case send it as a separate patch as RFC - I'm sure
> people will test and report back.

Yes, there are a few of us with diverse hardware that can perform
tests. It is best if you provide a git tree with all the patches
applied, and instructions how to test.

	 Andrew
