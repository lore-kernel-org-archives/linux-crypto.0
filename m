From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Wed, 14 Apr 2010 08:47:14 +0800
Message-ID: <20100414004714.GB18044@gondor.apana.org.au>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC44446.2010405@nokia.com> <20100413121004.GB10822@gondor.apana.org.au> <4BC47543.1020508@nokia.com> <4BC48178.4020104@nokia.com> <20100413144250.GB12695@gondor.apana.org.au> <4BC48EE7.5000306@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:44092 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752071Ab0DNArX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 20:47:23 -0400
Content-Disposition: inline
In-Reply-To: <4BC48EE7.5000306@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 13, 2010 at 06:33:59PM +0300, Dmitry Kasatkin wrote:
>
> Then state must be kept in req ctx, not tfm ctx.
> Right?

Correct, the same thing applies to both shash and ahash.

> Then when handling different request HW must be re-initialized.
> If handling the same request then no need to reinitialize.

Yes, you're allowed to cache state in the HW so that two requests
in a row that use the same state can avoid reinitialisation.

> Also not possible to call update(reqa) until previous completed.
> Otherwise it will mess up data in reqa.

That is up to the user to enforce.  You just need to ensure that
the hardware remains in a sane state even if the user screws up.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
