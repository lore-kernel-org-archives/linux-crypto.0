From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: convert "crypto" subdirectory to UTF-8
Date: Wed, 2 May 2007 14:43:45 +1000
Message-ID: <20070502044345.GA29384@gondor.apana.org.au>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4124 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754638AbXEBEoJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 May 2007 00:44:09 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 17, 2007 at 01:25:49PM -0400, John Anthony Kazos Jr. wrote:
> From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>
> 
> Convert the subdirectory "crypto" to UTF-8. The files changed are 
> <crypto/fcrypt.c> and <crypto/api.c>.
> 
> Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Thanks.  Could you fix up include/linux/crypto.h as well?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
