From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: fixes for Marvell hash
Date: Fri, 9 Oct 2015 22:35:48 +0800
Message-ID: <20151009143547.GA3391@gondor.apana.org.au>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
 <20151009141243.329dd60d@free-electrons.com>
 <20151009123132.GP32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34378 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbbJIOf7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 10:35:59 -0400
Content-Disposition: inline
In-Reply-To: <20151009123132.GP32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 09, 2015 at 01:31:32PM +0100, Russell King - ARM Linux wrote:
> 
> Hmm.  You know, given how broken this is, I've a good mind to say that
> this is more hassle than it's worth to get these simple fixes merged,
> especially as there's no MAINTAINERS entry for them.  I'm not sending
> the patch series a third time.  I could say if maintainers can't be
> bothered to ensure that they're listed in MAINTAINERS then they aren't
> maintainers at all.

There is no need to send them again Russell.  They look good to me
and I'll apply them.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
