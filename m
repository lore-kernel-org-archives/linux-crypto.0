From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: omap-sham - potential Oops on error in probe
Date: Thu, 19 May 2016 18:07:22 +0800
Message-ID: <20160519100722.GB25981@gondor.apana.org.au>
References: <20160518103905.GA10470@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44892 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbcESKHm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 May 2016 06:07:42 -0400
Content-Disposition: inline
In-Reply-To: <20160518103905.GA10470@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 18, 2016 at 01:39:05PM +0300, Dan Carpenter wrote:
> This if statement is reversed so we end up either leaking or Oopsing on
> error.
> 
> Fixes: dbe246209bc1 ('crypto: omap-sham - Use dma_request_chan() for requesting DMA channel')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
