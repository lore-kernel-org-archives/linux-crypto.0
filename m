From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: user - fix empty string test in report API
Date: Mon, 4 Feb 2013 21:15:52 +0800
Message-ID: <20130204131552.GA21584@gondor.apana.org.au>
References: <1359889741-23335-1-git-send-email-minipli@googlemail.com>
 <1359889741-23335-3-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:37640 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755066Ab3BDNQH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Feb 2013 08:16:07 -0500
Content-Disposition: inline
In-Reply-To: <1359889741-23335-3-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 03, 2013 at 12:09:01PM +0100, Mathias Krause wrote:
> The current test for empty strings fails because it is testing the
> address of a field, not a pointer. So the test will always be true.
> Test for the string length instead.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>

Good catch.  However, what if cru_driver_name isn't NUL-terminated?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
