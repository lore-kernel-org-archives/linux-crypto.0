From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 05/14] crypto: marvell/CESA: add TDMA support
Date: Wed, 17 Jun 2015 20:25:33 +0800
Message-ID: <20150617122533.GA13185@gondor.apana.org.au>
References: <1434527142-3609-1-git-send-email-boris.brezillon@free-electrons.com>
 <1434527142-3609-6-git-send-email-boris.brezillon@free-electrons.com>
 <20150617095001.GA11538@gondor.apana.org.au>
 <20150617133324.1ee6ad55@bbrezillon>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:41424 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbbFQM00 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 08:26:26 -0400
Content-Disposition: inline
In-Reply-To: <20150617133324.1ee6ad55@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 17, 2015 at 01:33:24PM +0200, Boris Brezillon wrote:
>
> Actually, I think I don't need to save the dma_map_sg return val, since
> I'm using the sg_next function to iterate over the scatterlist. Am I
> right ?
> IOW, is the ->map_sg() function (in dma_map_ops) supposed to merge the
> contiguous entries and then flag the unused entries with the is_chain
> flag ?

Right.  If you're simply using sg_dma_length in conjunction with
sg_next then you don't need the new length.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
