From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam: fix missing dma unmap on error path
Date: Thu, 6 Nov 2014 23:13:08 +0800
Message-ID: <20141106151308.GA4446@gondor.apana.org.au>
References: <1414672822-5067-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56956 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaKFPNR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 10:13:17 -0500
Content-Disposition: inline
In-Reply-To: <1414672822-5067-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 30, 2014 at 02:40:22PM +0200, Cristian Stoica wrote:
> If dma mapping for dma_addr_out fails, the descriptor memory is freed
> but the previous dma mapping for dma_addr_in remains.
> This patch resolves the missing dma unmap and groups resource
> allocations at function start.
> 
> Cc: <stable@vger.kernel.org> # 3.13+
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Patch applied to crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
