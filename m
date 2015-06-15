From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RESEND PATCH v4 04/14] crypto: add a new driver for Marvell's
 CESA
Date: Mon, 15 Jun 2015 20:40:00 +0800
Message-ID: <20150615124000.GB1646@gondor.apana.org.au>
References: <1434093366-14681-1-git-send-email-boris.brezillon@free-electrons.com>
 <1434093366-14681-5-git-send-email-boris.brezillon@free-electrons.com>
 <20150615094827.GA32073@gondor.apana.org.au>
 <20150615133853.57687ecf@bbrezillon>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:40991 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbbFOMk1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 08:40:27 -0400
Content-Disposition: inline
In-Reply-To: <20150615133853.57687ecf@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 01:38:53PM +0200, Boris Brezillon wrote:
> Oh right.
> I still have trouble understanding the need for the backlog concept
> (maybe you can give some insight): the backlog is just another list
> where we put all the requests when the queue has exceeded the limit
> fixed in crypto_queue_init, but the result is pretty much the same, the
> request stored in the backlog will be handled at some point, so what's
> the real point of this backlog.

The point is to tell the user to stop sending requests by returning
EBUSY.  When the queue clears up again we then invoke the callback
and tell the user that they can send requests again.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
