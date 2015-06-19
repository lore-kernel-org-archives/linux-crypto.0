From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 00/14] crypto: add a new driver for Marvell's CESA
Date: Fri, 19 Jun 2015 22:24:44 +0800
Message-ID: <20150619142444.GA15234@gondor.apana.org.au>
References: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
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
	Russell King - ARM Linux <linux@a
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37106 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbbFSOZP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2015 10:25:15 -0400
Content-Disposition: inline
In-Reply-To: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 18, 2015 at 03:46:16PM +0200, Boris Brezillon wrote:
> Hello,
> 
> This patch series adds a new driver supporting Marvell's CESA IP.
> This driver addresses some limitations of the existing one.
> >From a performance and CPU load point of view the most important
> limitation in the existing driver is the lack of DMA support, thus
> preventing us from chaining crypto operations.

All applied to cryptodev.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
