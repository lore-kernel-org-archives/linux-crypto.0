From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 03/18] crypto: marvell: add flag to determine algorithm
 endianness
Date: Tue, 20 Oct 2015 00:18:46 +0800
Message-ID: <20151019161846.GA9423@gondor.apana.org.au>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
 <E1ZnqkG-0005WH-TE@rmk-PC.arm.linux.org.uk>
 <20151019150451.GB3953@io.lakedaemon.net>
 <20151019152507.GL32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jason Cooper <jason@lakedaemon.net>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33008 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbbJSQTG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 12:19:06 -0400
Content-Disposition: inline
In-Reply-To: <20151019152507.GL32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 19, 2015 at 04:25:07PM +0100, Russell King - ARM Linux wrote:
>
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

I think the patch is fine as it is.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
