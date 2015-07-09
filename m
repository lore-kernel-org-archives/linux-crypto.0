From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 12/14] crypto: nx - Use new IV convention
Date: Thu, 9 Jul 2015 15:11:19 +0800
Message-ID: <20150709071119.GB430@gondor.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
 <2029636.zIROss5U0I@tauon.atsec.com>
 <20150709065615.GB32698@gondor.apana.org.au>
 <1909056.vXiC6IPPsr@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60028 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbbGIHLW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2015 03:11:22 -0400
Content-Disposition: inline
In-Reply-To: <1909056.vXiC6IPPsr@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 09, 2015 at 09:07:51AM +0200, Stephan Mueller wrote:
>
> Ok, will try. When is which tree used?

The crypto tree goes into the current mainline kernel so it's
for serious bug fixes/regressions only.

I will merge it into cryptodev when necessary.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
