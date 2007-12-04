From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HMAC broken on s390
Date: Tue, 4 Dec 2007 19:51:20 +1100
Message-ID: <20071204085120.GA6492@gondor.apana.org.au>
References: <1196688700.4799.5.camel@localhost.localdomain> <20071203220900.GA8573@gondor.apana.org.au> <20071204082511.GC23294@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Glauber <jang@linux.vnet.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3246 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751461AbXLDIvi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Dec 2007 03:51:38 -0500
Content-Disposition: inline
In-Reply-To: <20071204082511.GC23294@kernel.dk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 04, 2007 at 09:25:11AM +0100, Jens Axboe wrote:
> 
> You should continue to do your own chaining if it's a requirement for
> the driver/layer to function, until we get rid of ARCH_HAS_SG_CHAIN.
> That'll happen when all archs are converted.

Thanks for the confirmation.  I'll back out my conversion patch.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
