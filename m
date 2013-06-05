From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: blowfish - disable AVX2 implementation
Date: Wed, 5 Jun 2013 16:34:25 +0800
Message-ID: <20130605083425.GA12202@gondor.apana.org.au>
References: <20130602165147.25743.88831.stgit@localhost6.localdomain6>
 <20130602165152.25743.90142.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:47536 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752988Ab3FEIe3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Jun 2013 04:34:29 -0400
Content-Disposition: inline
In-Reply-To: <20130602165152.25743.90142.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 02, 2013 at 07:51:52PM +0300, Jussi Kivilinna wrote:
> It appears that the performance of 'vpgatherdd' is suboptimal for this kind of
> workload (tested on Core i5-4570) and causes blowfish-avx2 to be significantly
> slower than blowfish-amd64. So disable the AVX2 implementation to avoid
> performance regressions.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Both patches applied to crypto.  I presume you're working on
a more permanent solution on this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
