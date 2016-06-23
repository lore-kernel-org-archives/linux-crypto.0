From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: user - re-add size check for CRYPTO_MSG_GETALG
Date: Thu, 23 Jun 2016 18:43:57 +0800
Message-ID: <20160623104357.GA10350@gondor.apana.org.au>
References: <1466620177-10998-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40034 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbcFWKoI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 06:44:08 -0400
Content-Disposition: inline
In-Reply-To: <1466620177-10998-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 08:29:37PM +0200, Mathias Krause wrote:
> Commit 9aa867e46565 ("crypto: user - Add CRYPTO_MSG_DELRNG")
> accidentally removed the minimum size check for CRYPTO_MSG_GETALG
> netlink messages. This allows userland to send a truncated
> CRYPTO_MSG_GETALG message as short as a netlink header only making
> crypto_report() operate on uninitialized memory by accessing data
> beyond the end of the netlink message.
> 
> Fix this be re-adding the minimum required size of CRYPTO_MSG_GETALG
> messages to the crypto_msg_min[] array.
> 
> Fixes: 9aa867e46565 ("crypto: user - Add CRYPTO_MSG_DELRNG")
> Cc: stable@vger.kernel.org	# v4.2
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> ---
> This should go on top of crypto-2.6/master.

Patch applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
