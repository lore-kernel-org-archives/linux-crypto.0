From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif_rng - zeroize buffer holding random data
Date: Fri, 13 Mar 2015 21:31:37 +1100
Message-ID: <20150313103137.GA1442@gondor.apana.org.au>
References: <7837811.JDlpL5zc04@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:37656 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbbCMKbo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2015 06:31:44 -0400
Content-Disposition: inline
In-Reply-To: <7837811.JDlpL5zc04@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 11, 2015 at 07:45:35AM +0100, Stephan Mueller wrote:
> Due to the change to RNGs to always return zero in success case, the RNG
> interface must zeroize the buffer with the length provided by the
> caller.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Your patch is line-wrapped and doesn't apply.  Please resend.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
