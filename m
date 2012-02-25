From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: ux500 - Add driver for CRYP/HASH hardware.
Date: Sat, 25 Feb 2012 20:21:31 +1100
Message-ID: <20120225092130.GA19592@gondor.apana.org.au>
References: <1330091841-10709-1-git-send-email-andreas.westin@stericsson.com> <1330091841-10709-2-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:40366 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755316Ab2BYJVi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Feb 2012 04:21:38 -0500
Content-Disposition: inline
In-Reply-To: <1330091841-10709-2-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 24, 2012 at 02:57:20PM +0100, Andreas Westin wrote:
> This crypto hardware module is used in ST-Ericsson U8500
> boards. It supports AES, DES, SHA-1 and SHA-2. This driver implements
> support for AES-ECB, CBC and CTR, DES, 3DES and both supported SHA modes.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Andreas Westin <andreas.westin@stericsson.com>

Sorry, your patch doesn't apply against the cryptodev tree.  So
either it was damaged in transit, or you based it on something else.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
