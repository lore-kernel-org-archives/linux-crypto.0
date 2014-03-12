From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3 V2] crypto: Simplify the ahash_finup implementation
Date: Wed, 12 Mar 2014 20:11:01 +0800
Message-ID: <20140312121101.GB25881@gondor.apana.org.au>
References: <1389720829-5963-1-git-send-email-marex@denx.de>
 <1393806108-6374-1-git-send-email-marex@denx.de>
 <1393806108-6374-3-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38547 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaCLMLJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Mar 2014 08:11:09 -0400
Content-Disposition: inline
In-Reply-To: <1393806108-6374-3-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 03, 2014 at 01:21:48AM +0100, Marek Vasut wrote:
>
> -static void ahash_def_finup_done2(struct crypto_async_request *req, int err)
> +static void ahash_def_finup_done2(struct crypto_async_request *areq, int err)

Please keep the existing name to be consistent with the rest
of the crypto API code.  You should also use the same name in
your second patch for consistency.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
