From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 02/16] crypto: add a new driver for Marvell's CESA
Date: Mon, 25 May 2015 10:10:16 +0200
Message-ID: <20150525101016.252a1dc0@bbrezillon>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
	<1432301642-11470-3-git-send-email-boris.brezillon@free-electrons.com>
	<20150525075812.GA28689@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:55231 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750848AbbEYIKW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 04:10:22 -0400
In-Reply-To: <20150525075812.GA28689@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Mon, 25 May 2015 15:58:12 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, May 22, 2015 at 03:33:48PM +0200, Boris Brezillon wrote:
> >
> > +static int mv_cesa_sha1_export(struct ahash_request *req, void *out)
> > +{
> > +	struct sha1_state *out_state = out;
> > +	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
> > +	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
> > +	unsigned int digsize = crypto_ahash_digestsize(ahash);
> > +
> > +	out_state->count = creq->len;
> > +	memcpy(out_state->state, creq->state, digsize);
> > +	memset(out_state->buffer, 0, sizeof(out_state->buffer));
> > +	if (creq->cache)
> > +		memcpy(out_state->buffer, creq->cache, creq->cache_ptr);
> > +
> > +	return 0;
> > +}
> 
> Where is the import function?

Yep, I noticed that after submitting this version. I guess I only
needed the import function for my test cases and thus forgot to
implement the import function.
Anyway, I just added the the import functions (they'll be available in
my v4).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
