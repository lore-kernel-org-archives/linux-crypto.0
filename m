From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [RESEND PATCH v4 04/14] crypto: add a new driver for Marvell's
 CESA
Date: Mon, 15 Jun 2015 13:31:35 +0200
Message-ID: <20150615133135.47ffd3e3@bbrezillon>
References: <1434093366-14681-1-git-send-email-boris.brezillon@free-electrons.com>
	<1434093366-14681-5-git-send-email-boris.brezillon@free-electrons.com>
	<20150615095421.GA32158@gondor.apana.org.au>
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
Received: from down.free-electrons.com ([37.187.137.238]:32832 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753183AbbFOLbj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 07:31:39 -0400
In-Reply-To: <20150615095421.GA32158@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 15 Jun 2015 17:54:21 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Jun 12, 2015 at 09:15:56AM +0200, Boris Brezillon wrote:
> >
> > +static int mv_cesa_cbc_aes_op(struct ablkcipher_request *req,
> > +			      struct mv_cesa_op_ctx *tmpl)
> > +{
> > +	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTCM_CBC,
> > +			      CESA_SA_DESC_CFG_CRYPTCM_MSK);
> > +	memcpy(tmpl->ctx.blkcipher.iv, req->info, 16);
> 
> You need to copy the IV back into req->info after completion.

I haven't found any driver updating the req->info field with the new
IV. Could you point me to one of them.

> 
> Incidentally we don't seem to test for output IVs in our self-
> test so bugs like this can slip through until someone tries to
> do chaining with it.  That's something worth adding to testmgr.

Yes, that makes sense, but since a lot a drivers (if not all of them)
are not updating this field we'll break them when adding this test
unless we make it optional (with a new flag ?).

Do you have any suggestion to address this problem ?

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
