From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/1] crypto: Added support for Freescale's DCP
 co-processor
Date: Tue, 28 May 2013 17:51:24 +0800
Message-ID: <20130528095123.GD24414@gondor.apana.org.au>
References: <1368993578-23661-1-git-send-email-tobias.rauter@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Tobias Rauter <tobias.rauter@gmail.com>
To: Tobias Rauter <tobiasrauter@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:39178 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933813Ab3E1Jv1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 May 2013 05:51:27 -0400
Content-Disposition: inline
In-Reply-To: <1368993578-23661-1-git-send-email-tobias.rauter@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 19, 2013 at 09:59:38PM +0200, Tobias Rauter wrote:
> This patch enables the DCP crypto functionality on imx28.
> Currently, only aes-128-cbc is supported.
> Moreover, the dcpboot misc-device, which is used by Freescale's
> SDK tools and uses a non-software-readable OTP-key, is added.
> 
> Changes of v2:
> - ring buffer for hardware-descriptors
> - use of ablkcipher walk
> - OTP key encryption/decryption via misc-device
>   (compatible to Freescale-SDK)
> - overall cleanup
> 
> The DCP is also capable of sha1/sha256 but I won't be able to add 
> that anytime soon.
> Tested with built-in runtime-self-test, tcrypt and openssl via 
> cryptodev 1.6 on imx28-evk and a custom built imx28-board.
> 
> 
> Signed-off-by: Tobias Rauter <tobias.rauter@gmail.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
