From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto:caam - Correct the dma mapping for sg table
Date: Wed, 25 Jun 2014 21:49:57 +0800
Message-ID: <20140625134957.GD10379@gondor.apana.org.au>
References: <1403533226-13240-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, alexandru.porosanu@freescale.com,
	kim.phillips@freescale.com, dan.carpenter@oracle.com,
	horia.geanta@freescale.com, marex@denx.de
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41723 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaFYNuD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2014 09:50:03 -0400
Content-Disposition: inline
In-Reply-To: <1403533226-13240-1-git-send-email-ruchika.gupta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 23, 2014 at 07:50:26PM +0530, Ruchika Gupta wrote:
> At few places in caamhash and caamalg, after allocating a dmable
> buffer for sg table , the buffer was being modified.  As per
> definition of DMA_FROM_DEVICE ,afer allocation the memory should
> be treated as read-only by the driver. This patch shifts the
> allocation of dmable buffer for sg table after it is populated
> by the  driver, making it read-only as per the DMA API's requirement.
> 
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
