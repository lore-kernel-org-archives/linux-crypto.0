From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-sham - Only release DMA channel if
 successfully requested
Date: Thu, 5 Dec 2013 22:35:29 +0800
Message-ID: <20131205143529.GB1976@gondor.apana.org.au>
References: <1384287147-19656-1-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Joel Fernandes <joelf@ti.com>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:41583 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3LEOfj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Dec 2013 09:35:39 -0500
Content-Disposition: inline
In-Reply-To: <1384287147-19656-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 12, 2013 at 01:12:27PM -0700, Mark A. Greer wrote:
> In omap_sham_probe() and omap_sham_remove(), 'dd->dma_lch'
> is released without checking to see if it was successfully
> requested or not.  This is a bug and was identified and
> reported by Dan Carpenter here:
> 
> 	http://www.spinics.net/lists/devicetree/msg11023.html
> 
> Add code to only release 'dd->dma_lch' when its not NULL
> (that is, when it was successfully requested).
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> CC: Joel Fernandes <joelf@ti.com>
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
