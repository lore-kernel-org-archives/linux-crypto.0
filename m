From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-aes: Use dma_request_chan() for requesting
 DMA channel
Date: Tue, 3 May 2016 16:16:39 +0800
Message-ID: <20160503081639.GB17166@gondor.apana.org.au>
References: <1461934938-28297-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	t-kristo@ti.com, lokeshvutla@ti.com
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461934938-28297-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 29, 2016 at 04:02:18PM +0300, Peter Ujfalusi wrote:
> With the new dma_request_chan() the client driver does not need to look for
> the DMA resource and it does not need to pass filter_fn anymore.
> By switching to the new API the driver can now support deferred probing
> against DMA.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Lokesh Vutla <lokeshvutla@ti.com>

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
