From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: pcrypt - call the complete function on error
Date: Thu, 4 Feb 2010 11:40:33 +1100
Message-ID: <20100204004033.GB28890@gondor.apana.org.au>
References: <20100201093937.GH6619@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43902 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756225Ab0BDAkg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2010 19:40:36 -0500
Content-Disposition: inline
In-Reply-To: <20100201093937.GH6619@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 01, 2010 at 10:39:37AM +0100, Steffen Klassert wrote:
> This fixes three forgotten calls to the complete function
> in the error case.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
