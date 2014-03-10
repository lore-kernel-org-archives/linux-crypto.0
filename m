From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mxs-dcp: Align the bounce buffers
Date: Mon, 10 Mar 2014 20:22:00 +0800
Message-ID: <20140310122200.GF10556@gondor.apana.org.au>
References: <1393806195-6415-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:46234 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaCJMWR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Mar 2014 08:22:17 -0400
Content-Disposition: inline
In-Reply-To: <1393806195-6415-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 03, 2014 at 01:23:15AM +0100, Marek Vasut wrote:
> The DCP needs the bounce buffers, DMA descriptors and result buffers aligned
> to 64 bytes (yet another hardware limitation). Make sure they are aligned by
> properly aligning the structure which contains them during allocation.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
