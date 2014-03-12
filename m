From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3 V2] crypto: Fix the pointer voodoo in unaligned ahash
Date: Wed, 12 Mar 2014 20:08:14 +0800
Message-ID: <20140312120814.GA25881@gondor.apana.org.au>
References: <1389720829-5963-1-git-send-email-marex@denx.de>
 <1393806108-6374-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38229 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaCLMIr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Mar 2014 08:08:47 -0400
Content-Disposition: inline
In-Reply-To: <1393806108-6374-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 03, 2014 at 01:21:46AM +0100, Marek Vasut wrote:
> Add documentation for the pointer voodoo that is happening in crypto/ahash.c
> in ahash_op_unaligned(). This code is quite confusing, so add a beefy chunk
> of documentation.
> 
> Moreover, make sure the mangled request is completely restored after finishing
> this unaligned operation. This means restoring all of .result, .priv, .base.data
> and .base.complete .

There is no point in saving priv because it is only meant to be
used by the crypto API.

Otherwise the patch looks OK to me.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
