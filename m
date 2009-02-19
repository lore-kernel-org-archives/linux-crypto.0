From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ahash - fix ahash digest size
Date: Thu, 19 Feb 2009 14:47:07 +0800
Message-ID: <20090219064707.GA2094@gondor.apana.org.au>
References: <1234997380.362.495.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Lee Nipper <lee.nipper@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38554 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757932AbZBSGrK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Feb 2009 01:47:10 -0500
Content-Disposition: inline
In-Reply-To: <1234997380.362.495.camel@al08linux99>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Lee Nipper <lee.nipper@freescale.com> wrote:
> crypto_ahash_show changed to use cra_ahash for digestsize reference.
> 
> Signed-off-by: Lee Nipper <lee.nipper@freescale.com>

Good catch! Applied to crpyto-2.6.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
