From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 04/14] crypto: add a new driver for Marvell's CESA
Date: Fri, 19 Jun 2015 22:03:15 +0800
Message-ID: <20150619140315.GA14692@gondor.apana.org.au>
References: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
 <1434635190-27733-5-git-send-email-boris.brezillon@free-electrons.com>
 <20150619064256.GA10246@gondor.apana.org.au>
 <20150619102407.01187ff0@free-electrons.com>
 <5583D56F.7020808@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
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
	Russell King - ARM Linux <linux@a
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45050 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbbFSODx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2015 10:03:53 -0400
Content-Disposition: inline
In-Reply-To: <5583D56F.7020808@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2015 at 10:40:15AM +0200, Gregory CLEMENT wrote:
> 
> For this option you can use the branch mvebu/drivers located at
>  git://git.infradead.org/linux-mvebu.git.
> 
> In this branch there is the commit "bus: mvebu-mbus: add mv_mbus_dram_info_nooverlap()"
> but not only this one because it depends also on fixes which have been
> merged in this same branch.

It looks like the parent of this changeset is already in the mainline
so it's literally just a single patch.  I'll try to pull it into
cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
