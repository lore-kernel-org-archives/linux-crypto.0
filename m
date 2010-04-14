From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Wed, 14 Apr 2010 14:55:00 +0800
Message-ID: <20100414065500.GA20713@gondor.apana.org.au>
References: <4BC443DB.1030602@nokia.com> <20100413120243.GA10822@gondor.apana.org.au> <4BC46ADB.3000501@nokia.com> <20100413144527.GC12695@gondor.apana.org.au> <4BC48AE1.4010103@jdland.co.il> <4BC48C08.7040608@nokia.com> <20100414004453.GA18044@gondor.apana.org.au> <4BC562BB.4040800@nokia.com> <20100414064423.GA20555@gondor.apana.org.au> <4BC565EA.2090109@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:55196 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753365Ab0DNGzI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Apr 2010 02:55:08 -0400
Content-Disposition: inline
In-Reply-To: <4BC565EA.2090109@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 14, 2010 at 09:51:22AM +0300, Dmitry Kasatkin wrote:
>
> What do you mean by "merge operation".
> request merging?

By buffering user data, you're in essence merging requests.

I have no objections to doing that, but let's not do it in every
driver.

Of course, the ultimate solution is for the end-user to produce
requests that do not need merging.  So when considering this we
need to be aware of what users are being targeted.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
