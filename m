From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Wed, 14 Apr 2010 08:50:02 +0800
Message-ID: <20100414005001.GC18044@gondor.apana.org.au>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC44446.2010405@nokia.com> <20100413121004.GB10822@gondor.apana.org.au> <4BC47543.1020508@nokia.com> <20100413144843.GD12695@gondor.apana.org.au> <4BC4925A.4010109@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:44271 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752071Ab0DNAuM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 20:50:12 -0400
Content-Disposition: inline
In-Reply-To: <4BC4925A.4010109@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 13, 2010 at 06:48:42PM +0300, Dmitry Kasatkin wrote:
>
> About import/export.
>
> The problem with HW is that it always handles 64 byte blocks except last  
> one.
> So until finup/final it is not known if it is the last data. So some  
> buffer is kept in context.
>
> With DMA it is very inefficient to have small buffer.
> I use page 4k for that.
> So after a certain update there is a data in the cache.
>
> Doing export means that we need to get out intermediate hash and that  
> buffer.
>
> Any suggestion?

There is no need to buffer extra data in the driver.  If we need
to do that that should be done in the upper layer.

So my suggestion would be to feed everything you get in update to
the hardware immediately, unless of course if it's less than a
single block.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
