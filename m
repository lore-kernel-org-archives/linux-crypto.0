From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 03/18] crypto: marvell: add flag to determine algorithm
 endianness
Date: Mon, 19 Oct 2015 16:25:07 +0100
Message-ID: <20151019152507.GL32532@n2100.arm.linux.org.uk>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
 <E1ZnqkG-0005WH-TE@rmk-PC.arm.linux.org.uk>
 <20151019150451.GB3953@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:48052 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbbJSPZV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 11:25:21 -0400
Content-Disposition: inline
In-Reply-To: <20151019150451.GB3953@io.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 19, 2015 at 03:04:51PM +0000, Jason Cooper wrote:
> Hey Russell,
> 
> On Sun, Oct 18, 2015 at 05:23:40PM +0100, Russell King wrote:
> >  static int mv_cesa_ahash_init(struct ahash_request *req,
> > -			      struct mv_cesa_op_ctx *tmpl)
> > +			      struct mv_cesa_op_ctx *tmpl, bool algo_le)
> 
> nit: Would it make more sense the do bool algo_endian, and then ...

I don't like "bool"s that don't self-document what they mean.
What does "if (algo_endian)" mean?  It's pretty clear what
"if (algo_le)" means in the context of endianness, though I'll
give you that "if (algo_little_endian)" would be a lot better.

> 
> > @@ -861,7 +862,7 @@ static int mv_cesa_md5_init(struct ahash_request *req)
> >  
> >  	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
> >  
> > -	mv_cesa_ahash_init(req, &tmpl);
> > +	mv_cesa_ahash_init(req, &tmpl, true);
> 
> 	mv_cesa_ahash_init(req, &tmpl, ALGO_ENDIAN_LITTLE);
> 
> 'true' doesn't seem as obvious.  But again, nit-picky.

I did think about:

enum {
	ALGO_LITTLE_ENDIAN,
	ALGO_BIG_ENDIAN,
};

and passing an int algo_endian around, but that seemed to be like too
much bloat... though if you want to insist, I could make that change.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
