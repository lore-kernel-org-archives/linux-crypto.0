From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 06/14] crypto: marvell/CESA: add DES support
Date: Thu, 18 Jun 2015 15:02:59 +0800
Message-ID: <20150618070259.GA28882@gondor.apana.org.au>
References: <1434527142-3609-1-git-send-email-boris.brezillon@free-electrons.com>
 <1434527142-3609-7-git-send-email-boris.brezillon@free-electrons.com>
 <20150618085709.2180759d@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Imre Kaloz <kaloz@openwrt.org>,
	Sandy Harris <sandyinchina@gmail.
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36505 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbbFRHDq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 03:03:46 -0400
Content-Disposition: inline
In-Reply-To: <20150618085709.2180759d@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 18, 2015 at 08:57:09AM +0200, Boris Brezillon wrote:
> Hi Herbert,
> 
> On Wed, 17 Jun 2015 09:45:34 +0200
> Boris Brezillon <boris.brezillon@free-electrons.com> wrote:
> 
> > Add support for DES operations.
> 
> The addition of DES support seems controversial. At first I thought it
> would be good to support all the algorithms supported by the CESA
> engine, but I think I'll drop it in the next iteration.
> 
> Do you think Triple-DES should be dropped too ?

We're not here to make policy decisions.  So I don't see anything
wrong with keeping it.  However, if you don't wish to add it then
it's fine by me too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
