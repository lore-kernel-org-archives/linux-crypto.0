From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3 V2] crypto: Fix the pointer voodoo in unaligned ahash
Date: Thu, 13 Mar 2014 09:56:25 +0800
Message-ID: <20140313015624.GA2680@gondor.apana.org.au>
References: <1389720829-5963-1-git-send-email-marex@denx.de>
 <1393806108-6374-1-git-send-email-marex@denx.de>
 <20140312120814.GA25881@gondor.apana.org.au>
 <201403130220.29346.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:44844 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaCMB4m (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Mar 2014 21:56:42 -0400
Content-Disposition: inline
In-Reply-To: <201403130220.29346.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 13, 2014 at 02:20:29AM +0100, Marek Vasut wrote:
>
> OK, understood. But shall we not preserve the request intact in case a crypto-
> api function called crypto_ahash_final() with request which has .priv already 
> set? Then we would have really funny corruption of the request going on and I'm 
> not sure that'd be nice.

The priv field is only ever used by ahash.c so how can this happen?
The crypto API refers to code in the API itself, excluding drivers
and users.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
