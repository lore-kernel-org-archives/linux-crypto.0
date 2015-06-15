From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [RESEND PATCH v4 04/14] crypto: add a new driver for Marvell's
 CESA
Date: Mon, 15 Jun 2015 13:38:53 +0200
Message-ID: <20150615133853.57687ecf@bbrezillon>
References: <1434093366-14681-1-git-send-email-boris.brezillon@free-electrons.com>
	<1434093366-14681-5-git-send-email-boris.brezillon@free-electrons.com>
	<20150615094827.GA32073@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:33063 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbbFOLi5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 07:38:57 -0400
In-Reply-To: <20150615094827.GA32073@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 15 Jun 2015 17:48:27 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Jun 12, 2015 at 09:15:56AM +0200, Boris Brezillon wrote:
> >
> > +static void mv_cesa_dequeue_req_unlocked(struct mv_cesa_engine *engine)
> > +{
> > +	struct crypto_async_request *req;
> > +	struct mv_cesa_ctx *ctx;
> > +
> > +	spin_lock_bh(&cesa_dev->lock);
> > +	req = crypto_dequeue_request(&cesa_dev->queue);
> 
> Need to call crypto_get_backlog before this so you can do the
> backlog notification afterwards.

Oh right.
I still have trouble understanding the need for the backlog concept
(maybe you can give some insight): the backlog is just another list
where we put all the requests when the queue has exceeded the limit
fixed in crypto_queue_init, but the result is pretty much the same, the
request stored in the backlog will be handled at some point, so what's
the real point of this backlog.

Anyway, this question was just for my own understanding of this thing:
I'll fix the code to notify users that their request is in progress.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
