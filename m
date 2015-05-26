From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v3 15/16] ARM: marvell/dt: add crypto node to armada 370
 dtsi
Date: Tue, 26 May 2015 11:10:41 +0200
Message-ID: <20150526111041.1f8fc385@free-electrons.com>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
	<1432301642-11470-16-git-send-email-boris.brezillon@free-electrons.com>
	<556340C4.5090208@free-electrons.com>
	<20150526110345.663efb51@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
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
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [37.187.137.238] ([37.187.137.238]:49172 "EHLO
	mail.free-electrons.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243AbbEZJLG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 05:11:06 -0400
In-Reply-To: <20150526110345.663efb51@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Boris Brezillon,

On Tue, 26 May 2015 11:03:45 +0200, Boris Brezillon wrote:

> > There is no clocks property. After a quick look on the datasheet, indeed I didn't
> > find any clock which match the CESA. In this case you should update the binding
> > documentation by adding that the clock is optional for armada-370-crypto.
> 
> Hm, actually the clock is defined in Marvell's LSP, but not described
> in the datasheet. Which one should I trust :-) ?

I'd say: trust the reality. Declare the clock in the clock driver, but
don't take a reference to it from your crypto driver. The kernel will
disable it at the end of the boot. Check if crypto still works or not,
and you'll get your answer :-)

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
