From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RESEND PATCH v4 05/14] crypto: marvell/CESA: add TDMA support
Date: Mon, 15 Jun 2015 18:09:20 +0800
Message-ID: <20150615100920.GB32199@gondor.apana.org.au>
References: <1434093366-14681-1-git-send-email-boris.brezillon@free-electrons.com>
 <1434093366-14681-6-git-send-email-boris.brezillon@free-electrons.com>
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
	Imre Kaloz <kaloz@openwrt.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48898 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbbFOKJu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 06:09:50 -0400
Content-Disposition: inline
In-Reply-To: <1434093366-14681-6-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 12, 2015 at 09:15:57AM +0200, Boris Brezillon wrote:
>
> +	ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
> +			 DMA_TO_DEVICE);
> +	if (ret < 0)

This function returns zero on error, not negative.  See
Documentation/DMA-API-HOWTO.txt for details.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
