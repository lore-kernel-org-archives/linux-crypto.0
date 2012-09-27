From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: talitos fixes for 3.6-rc7
Date: Thu, 27 Sep 2012 01:14:25 -0700
Message-ID: <20120927081425.GB23122@gondor.apana.org.au>
References: <1348080820-22250-1-git-send-email-horia.geanta@freescale.com>
 <20120927052539.GA22160@gondor.apana.org.au>
 <506407EE.50406@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:51382 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756196Ab2I0IO1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 04:14:27 -0400
Content-Disposition: inline
In-Reply-To: <506407EE.50406@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 27, 2012 at 11:01:50AM +0300, Horia Geanta wrote:
>
> Again, this patch (e46e9a) is not the culprit, it merely exposes the
> deficiencies in the talitos driver.
> AFAICT, these cases (zero assoc data, noncontiguous iv and assoc
> data) have never been handled correctly in the driver.

OK, without the patches does the driver crash the self-test or
merely fail the self-test?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
