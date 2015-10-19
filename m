From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 03/18] crypto: marvell: add flag to determine algorithm
 endianness
Date: Mon, 19 Oct 2015 16:15:09 +0000
Message-ID: <20151019161509.GC3953@io.lakedaemon.net>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
 <E1ZnqkG-0005WH-TE@rmk-PC.arm.linux.org.uk>
 <20151019150451.GB3953@io.lakedaemon.net>
 <20151019152507.GL32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pmta2.delivery5.ore.mailhop.org ([54.186.218.12]:15421 "EHLO
	pmta2.delivery5.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbbJSQbO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 12:31:14 -0400
Content-Disposition: inline
In-Reply-To: <20151019152507.GL32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 19, 2015 at 04:25:07PM +0100, Russell King - ARM Linux wrote:
> On Mon, Oct 19, 2015 at 03:04:51PM +0000, Jason Cooper wrote:
> > Hey Russell,
> > 
> > On Sun, Oct 18, 2015 at 05:23:40PM +0100, Russell King wrote:
> > >  static int mv_cesa_ahash_init(struct ahash_request *req,
> > > -			      struct mv_cesa_op_ctx *tmpl)
> > > +			      struct mv_cesa_op_ctx *tmpl, bool algo_le)
> > 
> > nit: Would it make more sense the do bool algo_endian, and then ...
> 
> I don't like "bool"s that don't self-document what they mean.
> What does "if (algo_endian)" mean?  It's pretty clear what

That's where I would go with an enum.  "if (algo_endian ==
ALGO_ENDIAN_LITTLE) ..."

> "if (algo_le)" means in the context of endianness, though I'll
> give you that "if (algo_little_endian)" would be a lot better.

Right, it's really a question of where do we want readability?  I was
focusing on the call site, since the context isn't there for newcomers to
easily grok 'true'.

> > > @@ -861,7 +862,7 @@ static int mv_cesa_md5_init(struct ahash_request *req)
> > >  
> > >  	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
> > >  
> > > -	mv_cesa_ahash_init(req, &tmpl);
> > > +	mv_cesa_ahash_init(req, &tmpl, true);
> > 
> > 	mv_cesa_ahash_init(req, &tmpl, ALGO_ENDIAN_LITTLE);
> > 
> > 'true' doesn't seem as obvious.  But again, nit-picky.
> 
> I did think about:
> 
> enum {
> 	ALGO_LITTLE_ENDIAN,
> 	ALGO_BIG_ENDIAN,
> };
> 
> and passing an int algo_endian around, but that seemed to be like too
> much bloat... though if you want to insist, I could make that change.

Like I said, it's a nit.  Either a self-documenting bool, or an enum
will work.


thx,

Jason.
